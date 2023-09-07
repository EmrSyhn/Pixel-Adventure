import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/components/collison_block.dart';
import 'package:pixel_adventure/components/player.dart';

class Level extends World {
  late final String levelName;
  final Player player;
  Level({required this.levelName, required this.player});

  late TiledComponent level;
  List<CollisonBlock> collisonBlocks = [];
  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));

    add(level);
    final spawnPointinstLayer =
        level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    if (spawnPointinstLayer != null) {
      for (final spawnmPoint in spawnPointinstLayer.objects) {
        switch (spawnmPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnmPoint.x, spawnmPoint.y);
            add(player);
            break;
          default:
        }
      }
    }
    final collisyonLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisyonLayer != null) {
      for (final collison in collisyonLayer.objects) {
        switch (collison.class_) {
          case 'Platform':
            final platform = CollisonBlock(
              position: Vector2(collison.x, collison.y),
              size: Vector2(collison.width, collison.height),
              isPlatform: true,
            );
            collisonBlocks.add(platform);
            add(platform);
            break;
          default:
            final block = CollisonBlock(
              position: Vector2(collison.x, collison.y),
              size: Vector2(collison.width, collison.height),
            );
            collisonBlocks.add(block);
            add(block);
        }
      }
    }
    player.collisonBlocks = collisonBlocks;
    return super.onLoad();
  }
}
