bool checkCollesion(player, block) {
  final playerX = player.position.x;
  final playerY = player.position.y;
  final playerWidth = player.width;
  final playerHeight = player.height;

  final blockX = block.x;
  final bloxkY = block.y;
  final bloxkWidth = block.width;
  final blockHeight = block.height;

  final fixedX = player.scale.x < 0 ? playerX - playerWidth : playerX;

  return (playerY < bloxkY + blockHeight &&
      playerY + playerHeight > bloxkY &&
      fixedX < blockX + bloxkWidth &&
      fixedX + playerWidth > blockX);
}
