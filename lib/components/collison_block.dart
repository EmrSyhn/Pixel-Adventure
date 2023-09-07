import 'package:flame/components.dart';

class CollisonBlock extends PositionComponent {
  bool isPlatform;
  CollisonBlock({
    position,
    size,
    this.isPlatform = false,
  }) : super(position: position, size: size) {
    debugMode = true;
  }
}
