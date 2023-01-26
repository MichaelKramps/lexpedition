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
          color: Colors.grey.shade300.withOpacity(0.2));
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
      return BorderSide(width: 1, color: Colors.orange);
    } else {
      return BorderSide(width: 0, color: Colors.transparent);
    }
  }
}
