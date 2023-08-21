import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/components/player.dart';

class Level extends World {
  late final String levelName;
  final Player player;
  Level({required this.levelName, required this.player});

  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));

    add(level);
    final spawnPointinstLayer =
        level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    for (final spawnmPoint in spawnPointinstLayer!.objects) {
      switch (spawnmPoint.class_) {
        case 'Player':
          player.position = Vector2(spawnmPoint.x, spawnmPoint.y);
          add(player);
          break;
        default:
      }
    }

    return super.onLoad();
  }
}
