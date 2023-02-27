import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/game_data/game_column.dart';
import 'package:lexpedition/src/game_widgets/letter_grid_widget.dart';
import 'package:lexpedition/src/game_widgets/two_player_right_column_widget.dart';
import 'package:lexpedition/src/play_session/two_player_play_session_screen.dart';
import 'package:logging/logging.dart';

class ObserverGameInstanceWidget extends StatelessWidget {
  final TwoPlayerPlaySessionStateManager twoPlayerPlaySessionStateManager;
  final GameColumn leftColumn;
  final GameColumn rightColumn;

  const ObserverGameInstanceWidget(
      {super.key,
      required this.twoPlayerPlaySessionStateManager,
      required this.leftColumn,
      required this.rightColumn});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: determineColumn(leftColumn)),
        LetterGridWidget(
            letterGrid: twoPlayerPlaySessionStateManager.getTheirLetterGrid()
                as LetterGrid),
        Expanded(child: determineColumn(rightColumn))
      ],
    );
  }

  Widget determineColumn(GameColumn gameColumn) {
    switch (gameColumn) {
      case GameColumn.twoPlayerRightColumn:
        return TwoPlayerRightColumnWidget(
            twoPlayerPlaySessionStateManager: twoPlayerPlaySessionStateManager);
      case GameColumn.twoPlayerLeftColumn:
        return TwoPlayerRightColumnWidget(
            twoPlayerPlaySessionStateManager: twoPlayerPlaySessionStateManager);
      default:
        return Container();
    }
  }
}
