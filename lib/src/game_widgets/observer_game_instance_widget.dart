import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/game_data/game_column.dart';
import 'package:lexpedition/src/game_widgets/blast_direction_widget.dart';
import 'package:lexpedition/src/game_widgets/letter_grid_widget.dart';
import 'package:lexpedition/src/game_widgets/two_player_left_column_widget.dart';
import 'package:lexpedition/src/game_widgets/two_player_right_column_widget.dart';

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
      Row(
        children: [
          Expanded(child: determineColumn(leftColumn)),
          Column( 
            children: [
              BlastDirectionWidget(gameState: gameState),
              LetterGridWidget(
                  letterGrid: gameState.getTheirGrid() as LetterGrid),
          ]),
          Expanded(child: determineColumn(rightColumn))
      ]),
    ]);
  }

  Widget determineColumn(GameColumn gameColumn) {
    switch (gameColumn) {
      case GameColumn.twoPlayerRightColumn:
        return TwoPlayerRightColumnWidget(gameState: gameState);
      case GameColumn.twoPlayerLeftColumn:
        return TwoPlayerLeftColumnWidget(gameState: gameState,);
      default:
        return Container();
    }
  }
}
