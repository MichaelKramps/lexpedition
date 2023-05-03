import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/blast_direction.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/game_data/letter_tile.dart';
import 'package:lexpedition/src/game_widgets/obstacle_widget.dart';
import 'package:lexpedition/src/game_widgets/blast_widget.dart';
import 'package:lexpedition/src/game_widgets/tile_info_widget.dart';
import 'package:logging/logging.dart';

class LetterTileWidget extends StatelessWidget {
  final LetterTile letterTile;
  final BlastDirection blastDirection;
  final GameState gameState;

  const LetterTileWidget(
      {super.key,
      required this.letterTile,
      required this.blastDirection,
      required this.gameState});

  @override
  Widget build(BuildContext context) {
    if (letterTile.tileType != TileType.empty) {
      final ButtonStyle style = TextButton.styleFrom(
          fixedSize: Size.square(Constants().tileSize()),
          side: determineTileBorder());

      return Stack(children: [
        Container(
            margin: EdgeInsets.all(Constants().tileMargin()),
            decoration: BoxDecoration(color: determineBackgroundColor()),
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
            margin: EdgeInsets.all(Constants().tileMargin()),
            width: Constants().tileSize(),
            height: Constants().tileSize(),
            decoration: BoxDecoration(
                border: determineEmptyBorder(),
                color: determineBackgroundColor())),
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

  BorderSide determineTileBorder() {
    if (qualifiesToBeBlasted() || letterTile.primedForBlastFromPartner) {
      return BorderSide(width: 3, color: Color.fromARGB(255, 63, 181, 150));
    } else {
      return BorderSide(width: 0, color: Colors.transparent);
    }
  }

  Border determineEmptyBorder() {
    if (qualifiesToBeBlasted() || letterTile.primedForBlastFromPartner) {
      return Border.all(
          color: Color.fromARGB(255, 63, 181, 150),
          width: 3,
          style: BorderStyle.solid);
    } else {
      return Border();
    }
  }

  Color determineBackgroundColor() {
    if (qualifiesToBeCharged()) {
      return Colors.green.shade300.withOpacity(0.3);
    } else if (letterTile.selected) {
      return Colors.orange.shade900.withOpacity(0.3);
    } else {
      return Colors.grey.shade300.withOpacity(0.4);
    }
  }

  bool qualifiesToBeCharged() {
    if (gameState.currentGuess.length <= 0) {
      return false;
    }
    if (letterTile.tileType == TileType.start) {
      return gameState.currentGuess.first.index == letterTile.index;
    }
    if (letterTile.tileType == TileType.end) {
      return gameState.currentGuess.last.index == letterTile.index;
    }
    return letterTile.selected;
  }

  bool qualifiesToBeBlasted() {
    if (gameState.currentGuess.length < 5) {
      return false;
    } else {
      List<int> indexesToBeBlasted = LetterGrid.indexesToBlast(
          gameState.currentGuess.last.index, gameState.primaryLetterGrid.blastDirection);
      return indexesToBeBlasted.contains(letterTile.index);
    }
  }
}
