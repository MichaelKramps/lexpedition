import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:lexpedition/src/level_info/level_db_connection.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class FreePlay extends StatelessWidget {
  const FreePlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(builder: (context, gameState, child) {
      return Scaffold(
          body: SizedBox.expand(
              child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                gameState.loadOnePlayerPuzzle();
                GoRouter.of(context).push('/freeplay/oneplayer');
              },
              child: Text('One Player')),
          SizedBox(width: Constants.smallFont),
          ElevatedButton(
              onPressed: () {
                gameState.loadTwoPlayerPuzzle();
                GoRouter.of(context).push('/freeplay/twoplayer');
              },
              child: Text('Two Player')),
          SizedBox(width: Constants.smallFont),
          ElevatedButton(
              onPressed: () => GoRouter.of(context).push('/'),
              child: Text('Back'))
        ],
      )));
    });
  }
}
