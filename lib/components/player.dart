import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import '../pixel_adventure.dart';

enum PlayerState { idle, run }

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

  //PlayerDirection direction = PlayerDirection.none;
  double horizontalMovement = 0.0;
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
    _updatePlayerState();
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0.0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalMovement += isLeftKeyPressed ? -1.0 : 0;
    horizontalMovement += isRightKeyPressed ? 1.0 : 0;

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

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
      playerState = PlayerState.run;
      // Eğer sola dönüyorsa, durumu "run" olarak güncelle
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
      playerState = PlayerState.run;
      // Eğer sağa dönüyorsa, durumu "run" olarak güncelle
    } else if (velocity.x != 0) {
      playerState = PlayerState.run;
      // Eğer hız 0 değilse, durumu "run" olarak güncelle
    } else {
      playerState = PlayerState.idle;
    }
    // animation güncellemesi
    animation = playerState == PlayerState.idle ? idleAnimation : runAnimation;
  }

  void _updatePlayerMovement(double dt) {
    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }
}
