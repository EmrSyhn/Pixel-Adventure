import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import '../pixel_adventure.dart';

enum PlayerState { idle, run }

enum PlayerDirection { left, right, none }

class Player extends SpriteAnimationComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler {
  Player({
    position,
    this.character = 'Ninja Frog',
  }) : super(position: position);
  String character;

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runAnimation;
  final double stepTime = 0.05;

  PlayerDirection direction = PlayerDirection.none;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;

  @override
  FutureOr<void> onLoad() {
    _loadAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    if (isLeftKeyPressed && isRightKeyPressed) {
      direction = PlayerDirection.none;
    } else if (isLeftKeyPressed) {
      direction = PlayerDirection.left;
    } else if (isRightKeyPressed) {
      direction = PlayerDirection.right;
    } else {
      direction = PlayerDirection.none;
    }
    return super.onKeyEvent(event, keysPressed);
  }

  void _loadAnimations() {
    idleAnimation = _spriteAnimations('Idle', 11);
    runAnimation = _spriteAnimations('Run', 12);

    animation =
        PlayerState.idle == PlayerState.idle ? idleAnimation : runAnimation;
  }

  SpriteAnimation _spriteAnimations(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  void _updatePlayerMovement(double dt) {
    double dirX = 0.0;
    switch (direction) {
      case PlayerDirection.left:
        animation = runAnimation;
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        dirX -= moveSpeed;
        break;
      case PlayerDirection.right:
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        animation = runAnimation;

        dirX += moveSpeed;
        break;
      case PlayerDirection.none:
        animation = idleAnimation;

        break;
    }
    velocity = Vector2(dirX, 0.0);
    position += velocity * dt;
  }
}
