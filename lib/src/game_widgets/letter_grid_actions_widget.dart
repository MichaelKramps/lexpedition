import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:lexpedition/src/game_widgets/blast_direction_widget.dart';

class LetterGridActionsWidget extends StatelessWidget {
  final GameState gameState;

  const LetterGridActionsWidget({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = TextButton.styleFrom(
        backgroundColor: Colors.amber.withOpacity(0.75),
        side: BorderSide(width: 0, color: Colors.transparent));

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      BlastDirectionWidget(gameState: gameState),
      Container(
          width: Constants.tileSize * 3.5,
          margin: EdgeInsets.all(Constants.tileMargin * 2),
          child: Text(gameState.getCurrentGuess(),
              style: TextStyle(
                  fontSize: Constants.tileSize * 0.4,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  color: gameState.showBadGuess
                      ? Colors.red
                      : Colors.black))),
      Container(
          margin: EdgeInsets.all(Constants.tileMargin * 2),
          child: ElevatedButton(
              style: buttonStyle,
              onPressed: () => gameState.submitGuess(),
              child: Text('Submit'))),
      ElevatedButton(
          style: buttonStyle,
          onPressed: () => gameState.clearGuess(),
          child: Text('Clear')),
    ]);
  }
}
