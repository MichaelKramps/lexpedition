import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/blast_direction.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/letter_tile.dart';
import 'package:lexpedition/src/game_widgets/obstacle_widget.dart';
import 'package:lexpedition/src/game_widgets/blast_widget.dart';
import 'package:lexpedition/src/game_widgets/tile_info_widget.dart';

class LetterTileWidget extends StatelessWidget {
  final LetterTile letterTile;
  final BlastDirection blastDirection;

  const LetterTileWidget(
      {super.key, required this.letterTile, required this.blastDirection});

  @override
  Widget build(BuildContext context) {
    if (letterTile.tileType != TileType.empty) {
      final ButtonStyle style = TextButton.styleFrom(
          fixedSize: Size.square(Constants.tileSize),
          backgroundColor: Colors.black.withOpacity(0.0),
          side: determineTileBorder(letterTile));

      return Stack(children: [
        Container(
            margin: EdgeInsets.all(Constants.tileMargin),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(determineTileImage(letterTile)),
                    fit: BoxFit.cover)),
            child: TextButton(
                onPressed: () {},
                style: style,
                child: TileInfoWidget(letterTile: letterTile))),
        ObstacleWidget(visible: !letterTile.clearOfObstacles()),
        BlastWidget(
            blastDirection: blastDirection,
            beginBlastAnimation: letterTile.blastFrom)
      ]);
    } else {
      return Stack(children: [
        Container(
            margin: EdgeInsets.all(Constants.tileMargin),
            width: Constants.tileSize,
            height: Constants.tileSize,
            color: determineEmptyColor(letterTile)),
        BlastWidget(
            blastDirection: blastDirection,
            beginBlastAnimation: letterTile.blastFrom)
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

  BorderSide determineTileBorder(LetterTile letterTile) {
    if (letterTile.primedForBlast) {
      return BorderSide(width: 3, color: Color.fromARGB(255, 63, 181, 150));
    } else if (letterTile.selected) {
      return BorderSide(width: 2, color: Colors.orange);
    } else {
      return BorderSide(width: 0, color: Colors.transparent);
    }
  }

  Color determineEmptyColor(LetterTile letterTile) {
    if (letterTile.selected) {
      return Colors.orange.shade300.withOpacity(0.3);
    } else {
      return Colors.grey.shade300.withOpacity(0.2);
    }
  }
}
