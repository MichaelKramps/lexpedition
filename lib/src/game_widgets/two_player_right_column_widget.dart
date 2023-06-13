import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/game_mode.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:lexpedition/src/game_widgets/letter_grid_widget.dart';
import 'package:lexpedition/src/level_info/level_db_connection.dart';
import 'package:lexpedition/src/user_interface/basic_game_button.dart';

class TwoPlayerRightColumnWidget extends StatelessWidget {
  final GameState gameState;

  const TwoPlayerRightColumnWidget({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BasicGameButton(
          onPressed: () {
            gameState.resetPuzzle(notify: true, loadNew: false);
            logPuzzleQuit();
          },
          buttonText: 'Restart',
        ),
        SizedBox(height: 12),
        determinePartnerScreen(),
        SizedBox(height: 12),
        BasicGameButton(
        onPressed: () {
          logPuzzleQuit();
          GoRouter.of(context).push('/');
        },
        buttonText: 'Home',
      )
      ],
    );
  }

  Widget determinePartnerScreen() {
    if (gameState.getTheirGrid() != null && gameState.getMyGrid() != null) {
      return FittedBox(
          child: LetterGridWidget(
              gameState: gameState, letterGrid: gameState.getTheirGrid()!));
    } else {
      return SizedBox.shrink();
    }
  }

  void logPuzzleQuit() {
    if (gameState.level.puzzleId != null) {
      switch (gameState.gameMode) {
        case GameMode.OnePlayerFreePlay:
        case GameMode.OnePlayerLexpedition:
          LevelDatabaseConnection.logOnePlayerUnfinishedPuzzleResults(
            gameState.level.puzzleId as int);
          break;
        case GameMode.TwoPlayerFreePlay:
        case GameMode.TwoPlayerLexpedition:
          LevelDatabaseConnection.logTwoPlayerUnfinishedPuzzleResults(
            gameState.level.puzzleId as int);
          break;
        default:
          break;
      }
    }
  }
}
