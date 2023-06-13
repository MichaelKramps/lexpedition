import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:lexpedition/src/level_info/level_db_connection.dart';
import 'package:lexpedition/src/user_interface/basic_game_button.dart';

class OnePlayerRightColumnWidget extends StatelessWidget {
  final GameState gameState;

  OnePlayerRightColumnWidget(
      {super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      InkResponse(
        onTap: () => GoRouter.of(context).push('/settings'),
        child: Image.asset(
          'assets/images/settings.png',
          semanticLabel: 'Settings',
        ),
      ),
      BasicGameButton(
        onPressed: () {
          gameState.resetPuzzle(notify: true, loadNew: false);
          logPuzzleQuit();
        },
        buttonText: 'Restart',
      ),
      SizedBox(height: 10),
      BasicGameButton(
        onPressed: () {
          logPuzzleQuit();
          GoRouter.of(context).push('/');
        },
        buttonText: 'Home',
      )
    ]);
  }

  void logPuzzleQuit() {
    if (gameState.level.puzzleId != null) {
      LevelDatabaseConnection.logOnePlayerUnfinishedPuzzleResults(
          gameState.level.puzzleId as int);
    }
  }
}
