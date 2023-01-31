import 'package:flutter/material.dart';
import 'package:game_template/src/game_data/letter_grid.dart';
import 'package:game_template/src/game_data/letter_tile.dart';
import 'package:game_template/src/game_widgets/obstacle_widget.dart';
import 'package:game_template/src/game_widgets/spray_widget.dart';
import 'package:game_template/src/game_widgets/tile_info_widget.dart';

class LetterTileWidget extends StatelessWidget {
  final LetterTile letterTile;
  final SprayDirection sprayDirection;

  const LetterTileWidget(
      {super.key, required this.letterTile, required this.sprayDirection});

  @override
  Widget build(BuildContext context) {
    if (letterTile.tileType != TileType.empty) {
      final ButtonStyle style = TextButton.styleFrom(
          fixedSize: Size.square(80),
          backgroundColor: Colors.black.withOpacity(0.0),
          side: determineBorder(letterTile));

      return Stack(children: [
        Container(
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(determineTileImage(letterTile)),
                    fit: BoxFit.cover)),
            child: TextButton(
                onPressed: () {},
                style: style,
                child: TileInfoWidget(letterTile: letterTile))),
        ObstacleWidget(visible: !letterTile.clearOfObstacles()),
        SprayWidget(
            sprayDirection: sprayDirection,
            beginSprayAnimation: letterTile.sprayFrom)
      ]);
    } else {
      return Stack(children: [
        Container(
            margin: EdgeInsets.all(2),
            width: 80,
            height: 80,
            color: Colors.grey.shade300.withOpacity(0.2)),
        SprayWidget(
            sprayDirection: sprayDirection,
            beginSprayAnimation: letterTile.sprayFrom)
      ]);
    }
  }

  String determineTileImage(LetterTile? letterTile) {
    String imagePath = 'assets/images/';

    if (letterTile != null && letterTile.isCharged()) {
      switch (letterTile.tileType) {
        case (TileType.start):
          return imagePath + 'yellow-start.png';
        case (TileType.end):
          return imagePath + 'yellow-end.png';
        default:
          return imagePath + 'yellow-basic.png';
      }
    }

    if (letterTile != null) {
      switch (letterTile.tileType) {
        case (TileType.start):
          return imagePath + 'green-start.png';
        case (TileType.end):
          return imagePath + 'red-end.png';
        default:
          return imagePath + 'blue-basic.png';
      }
    }

    return imagePath + 'blue-basic.png';
  }

  BorderSide determineBorder(LetterTile? letterTile) {
    if (letterTile != null && letterTile.selected) {
      return BorderSide(width: 2, color: Colors.orange);
    } else {
      return BorderSide(width: 0, color: Colors.transparent);
    }
  }
}
