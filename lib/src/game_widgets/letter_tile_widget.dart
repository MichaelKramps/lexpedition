import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lexpedition/src/game_data/blast_direction.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/game_data/letter_tile.dart';
import 'package:lexpedition/src/game_widgets/obstacle_widget.dart';
import 'package:lexpedition/src/game_widgets/blast_widget.dart';
import 'package:lexpedition/src/game_widgets/tile_info_widget.dart';

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
      return Stack(children: [
        determineTileAnimation(getBaseTileWidget()),
        ObstacleWidget(visible: !letterTile.clearOfObstacles()),
        BlastWidget(
            blastDirection: blastDirection,
            beginBlastAnimation: letterTile.blastFrom)
      ]);
    } else {
      return Stack(children: [
        determineTileAnimation(getBaseEmptyWidget()),
        BlastWidget(
            blastDirection: blastDirection,
            beginBlastAnimation: letterTile.blastFrom)
      ]);
    }
  }

  Widget determineTileAnimation(Widget baseWidget) {
    if (letterTile.blastFrom) {
      return baseWidget;
    } else if (letterTile.primedForBlast) {
      if (gameState.showBadGuess) {
        return baseWidget.animate().shakeX(duration: 400.ms);
      } else {
        return baseWidget
          .animate(onPlay: (controller) => controller.repeat())
          .shake(rotation: 0.03, hz: 10);
      }
    } else if (letterTile.selected) {
      if (gameState.showBadGuess) {
        // shake letters in the bad guess
        return baseWidget.animate().shakeX(duration: 400.ms);
      } else {
        // shake letter when selected
        return baseWidget.animate().shake(duration: 350.ms, rotation: 0.03);
      }
    } else {
      return baseWidget;
    }
  }

  Widget getBaseTileWidget() {
    final ButtonStyle style = TextButton.styleFrom(
        fixedSize: Size.square(Constants().tileSize()),
        side: determineTileBorder());
    return Container(
        margin: EdgeInsets.all(Constants().tileMargin()),
        decoration: determineTileBackground(),
        child: TextButton(
            onPressed: () {},
            style: style,
            child: TileInfoWidget(letterTile: letterTile)));
  }

  Widget getBaseEmptyWidget() {
    return Container(
        margin: EdgeInsets.all(Constants().tileMargin()),
        width: Constants().tileSize(),
        height: Constants().tileSize(),
        decoration: BoxDecoration(
            border: determineEmptyBorder(), color: determineBackgroundColor()));
  }

  Decoration? determineTileBackground() {
    switch (letterTile.tileType) {
      case (TileType.start):
        return BoxDecoration(
          color: determineBackgroundColor(),
          image: DecorationImage(
            image: AssetImage("assets/images/circle.png"),
            fit: BoxFit.cover,
          ),
        );
      case (TileType.end):
        return BoxDecoration(
          color: determineBackgroundColor(),
          image: DecorationImage(
            image: AssetImage("assets/images/square.png"),
            fit: BoxFit.fill,
          ),
        );
      default:
        return BoxDecoration(
          color: determineBackgroundColor(),
        );
    }
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
      if (gameState.showBadGuess) {
        return Colors.orange.shade900.withOpacity(0.3);
      } else {
        return Colors.green.shade300.withOpacity(0.3);
      }
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
          gameState.currentGuess.last.index,
          gameState.primaryLetterGrid.blastDirection);
      return indexesToBeBlasted.contains(letterTile.index);
    }
  }
}
