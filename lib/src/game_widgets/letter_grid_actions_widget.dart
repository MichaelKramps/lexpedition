import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:lexpedition/src/game_widgets/blast_direction_widget.dart';
import 'package:lexpedition/src/user_interface/basic_game_button.dart';
import 'package:lexpedition/src/user_interface/featured_game_button.dart';

class LetterGridActionsWidget extends StatelessWidget {
  final GameState gameState;

  const LetterGridActionsWidget({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      BlastDirectionWidget(gameState: gameState),
      Container(
          width: Constants().tileSize() * 3,
          margin: EdgeInsets.all(Constants().tileMargin() * 2),
          child: Text(gameState.getCurrentGuessString(true),
              style: TextStyle(
                  fontSize: Constants().tileSize() * 0.4,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  color: gameState.showBadGuess ? Colors.red : Colors.black))),
      Container(
          margin: EdgeInsets.all(Constants().tileMargin() * 2),
          child: FeaturedGameButton(
              onPressed: () => gameState.submitGuess(context, true),
              muted: true,
              buttonText: 'Submit')),
      BasicGameButton(
          onPressed: () => gameState.clearGuessAndNotify(true),
          buttonText: 'Clear'),
    ]);
  }
}
