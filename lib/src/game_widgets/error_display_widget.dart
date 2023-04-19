import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/error_definitions.dart';
import 'package:provider/provider.dart';
import 'package:lexpedition/src/game_data/game_state.dart';

class GameStateErrorDisplay extends StatelessWidget {
  const GameStateErrorDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(builder: (context, gameState, child) {
      if (gameState.errorDefinition != ErrorDefinition.noError)
      {
        return AlertDialog(
          content:
                Text(getErrorMessage(gameState.errorDefinition)),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                gameState.resetError();
              },
            )
          ]
        );
      } else {
      return Container();
      }
    });
  }
}