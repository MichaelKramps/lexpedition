import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_state.dart';

class CurrentGuessWidget extends StatelessWidget {
  final GameState gameState;
  final bool myGrid;

  const CurrentGuessWidget({super.key, required this.gameState, required this.myGrid});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: Constants().tileSize() * 3,
        margin: EdgeInsets.all(Constants().tileMargin() * 2),
        child: Text(gameState.getCurrentGuessString(myGrid),
            style: TextStyle(
                fontSize: Constants().tileSize() * 0.4,
                backgroundColor: Colors.white.withOpacity(0.3),
                color: gameState.showBadGuess ? Colors.red : Colors.black)));
  }
}
