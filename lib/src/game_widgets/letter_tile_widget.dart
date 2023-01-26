import 'package:flutter/material.dart';
import 'package:game_template/src/game_data/letter_grid.dart';
import 'package:game_template/src/game_data/letter_tile.dart';
import 'package:game_template/src/game_widgets/obstacle_widget.dart';
import 'package:game_template/src/game_widgets/spray_widget.dart';
import 'package:game_template/src/game_widgets/tile_info_widget.dart';

class LetterTileWidget extends StatelessWidget {
  final LetterTile? letterTile;
  final SprayDirection sprayDirection;

  const LetterTileWidget(
      {super.key, required this.letterTile, required this.sprayDirection});

  @override
  Widget build(BuildContext context) {
    if (letterTile != null) {
      LetterTile nonNullTile =
          letterTile ?? new LetterTile('l', TileType.basic, 0, 0, 0);
      final ButtonStyle style = ElevatedButton.styleFrom(
          fixedSize: Size.square(80),
          backgroundColor: determineTileColor(letterTile),
          side: determineBorder(letterTile));

      return Stack(children: [
        Container(
            margin: EdgeInsets.all(2),
            child: ElevatedButton(
                onPressed: () {},
                style: style,
                child: TileInfoWidget(letterTile: nonNullTile))),
        ObstacleWidget(visible: !nonNullTile.clearOfObstacles()),
        SprayWidget(
            sprayDirection: sprayDirection,
            beginSprayAnimation: nonNullTile.sprayFrom)
      ]);
    } else {
      return Container(
          margin: EdgeInsets.all(2),
          width: 80,
          height: 80,
          color: Colors.grey.shade300);
    }
  }

  Color determineTileColor(LetterTile? letterTile) {
    if (letterTile != null && letterTile.isCharged()) {
      return Colors.amber;
    }

    if (letterTile != null) {
      switch (letterTile.tileType) {
        case (TileType.start):
          return Colors.green.shade700.withOpacity(0.2);
        case (TileType.end):
          return Colors.red.shade700.withOpacity(0.2);
        default:
          return Colors.blueGrey.shade600.withOpacity(0.2);
      }
    }

    return Colors.black.withOpacity(0.1);
  }

  BorderSide determineBorder(LetterTile? letterTile) {
    if (letterTile != null && letterTile.selected) {
      return BorderSide(width: 1, color: Colors.orange);
    } else {
      return BorderSide(width: 0);
    }
  }
}
