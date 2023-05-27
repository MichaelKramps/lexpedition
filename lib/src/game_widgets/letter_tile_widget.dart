import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lexpedition/src/game_data/blast_direction.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
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
    if (gameState.loadingLevel) {
      return baseWidget.animate().flip(delay: determineAmountToDelay());
    }
    if (letterTile.blastFrom) {
      return baseWidget;
    } else if (letterTile.primedForBlast ||
        letterTile.primedForBlastFromPartner) {
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

  Duration determineAmountToDelay() {
    Duration delay = 1000.ms;

    switch (letterTile.index) {
      case 0:
        delay += 0.ms;
        break;
      case 1:
      case 6:
        delay += 150.ms;
        break;
      case 2:
      case 7:
      case 12:
        delay += 300.ms;
        break;
      case 3:
      case 8:
      case 13:
      case 18:
        delay += 450.ms;
        break;
      case 4:
      case 9:
      case 14:
      case 19:
        delay += 600.ms;
        break;
      case 5:
      case 10:
      case 15:
      case 20:
        delay += 750.ms;
        break;
      case 11:
      case 16:
      case 21:
        delay += 900.ms;
        break;
      case 17:
      case 22:
        delay += 1050.ms;
        break;
      case 23:
        delay += 1200.ms;
        gameState.doneLoading();
        break;
      default:
    }

    return delay;
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
    if (letterTile.qualifiesToBeBlasted || letterTile.qualifiesToBeBlastedFromPartner) {
      return BorderSide(width: 3, color: Color.fromARGB(255, 63, 181, 150));
    } else {
      return BorderSide(width: 0, color: Colors.transparent);
    }
  }

  Border determineEmptyBorder() {
    if (letterTile.qualifiesToBeBlasted || letterTile.qualifiesToBeBlastedFromPartner) {
      return Border.all(
          color: Color.fromARGB(255, 63, 181, 150),
          width: 3,
          style: BorderStyle.solid);
    } else {
      return Border();
    }
  }

  Color determineBackgroundColor() {
    if (letterTile.qualifiesToBeCharged) {
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
}
