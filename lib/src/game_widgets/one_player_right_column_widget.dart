import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_widgets/game_instance_widget.dart';
import 'package:lexpedition/src/level_info/level_db_connection.dart';

class OnePlayerRightColumnWidget extends StatelessWidget {
  final GameInstanceWidgetStateManager gameInstanceWidgetStateManager;

  OnePlayerRightColumnWidget(
      {super.key, required this.gameInstanceWidgetStateManager});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Text(gameInstanceWidgetStateManager.getGrid().guesses.length.toString(),
          style: TextStyle(fontSize: 45, color: Colors.black)),
      InkResponse(
        onTap: () => GoRouter.of(context).push('/settings'),
        child: Image.asset(
          'assets/images/settings.png',
          semanticLabel: 'Settings',
        ),
      ),
      ElevatedButton(
        onPressed: () {
          gameInstanceWidgetStateManager.resetPuzzle();
          logPuzzleQuit();
        },
        child: const Text('Restart'),
      ),
      SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          logPuzzleQuit();
          GoRouter.of(context).go('/');
        },
        child: const Text('Home'),
      )
    ]);
  }

  void logPuzzleQuit() {
    if (gameInstanceWidgetStateManager.getGameLevel().puzzleId != null) {
      LevelDatabaseConnection.logOnePlayerUnfinishedPuzzleResults(
          gameInstanceWidgetStateManager.getGameLevel().puzzleId as int);
    }
  }
}
