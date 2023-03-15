import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/blast_direction.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/game_data/game_column.dart';
import 'package:lexpedition/src/game_widgets/letter_grid_widget.dart';

class ObserverGameInstanceWidget extends StatelessWidget {
  final GameState gameState;
  final GameColumn leftColumn;
  final GameColumn rightColumn;

  const ObserverGameInstanceWidget(
      {super.key,
      required this.gameState,
      required this.leftColumn,
      required this.rightColumn});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
          decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(Constants.backgroundImagePath),
            fit: BoxFit.cover),
      )),
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        /* BlastDirectionWidget(
            blastDirection: getBlastDirection(
                twoPlayerPlaySessionStateManager.getTheirLetterGrid()),
            changeDirection: () => {}), */
        Row(children: [
          Expanded(child: determineColumn(leftColumn)),
          LetterGridWidget(
              letterGrid: gameState.getTheirGrid() as LetterGrid),
          Expanded(child: determineColumn(rightColumn))
        ])
      ])
    ]);
  }

  Widget determineColumn(GameColumn gameColumn) {
    return Container();
    /* switch (gameColumn) {
      case GameColumn.twoPlayerRightColumn:
        return TwoPlayerRightColumnWidget(
            twoPlayerPlaySessionStateManager: twoPlayerPlaySessionStateManager);
      case GameColumn.twoPlayerLeftColumn:
        return TwoPlayerLeftColumnWidget(
            twoPlayerPlaySessionStateManager: twoPlayerPlaySessionStateManager);
      default:
        return Container();
    } */
  }

  getBlastDirection(LetterGrid? letterGrid) {
    if (letterGrid == null) {
      return BlastDirection.vertical;
    } else {
      return letterGrid.blastDirection;
    }
  }
}
