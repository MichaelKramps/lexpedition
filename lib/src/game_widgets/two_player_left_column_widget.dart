import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/accepted_guess.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:lexpedition/src/game_widgets/guesses_info_widget.dart';

class TwoPlayerLeftColumnWidget extends StatelessWidget {
  final GameState gameState;

  const TwoPlayerLeftColumnWidget({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      GuessesInformationWidget(
        currentGuesses: gameState.guessList.length,
        averageGuesses: gameState.level.averageGuesses.round(),
        bestAttempt: gameState.level.bestAttempt,
      ),
      for (AcceptedGuess guess in gameState.getAllGuessesInOrder()) ...[
        Text(guess.guess.toUpperCase(),
            style: TextStyle(
                fontSize: Constants.smallFont,
                color: guess.fromMe ? Colors.black : Colors.white))
      ]
    ]);
  }
}
