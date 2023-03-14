import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/accepted_guess.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_widgets/game_instance_widget.dart';
import 'package:lexpedition/src/game_widgets/guesses_info_widget.dart';

class OnePlayerLeftColumnWidget extends StatelessWidget {
  final GameInstanceWidgetStateManager gameInstanceWidgetStateManager;

  const OnePlayerLeftColumnWidget(
      {super.key, required this.gameInstanceWidgetStateManager});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start, 
      children:[
        GuessesInformationWidget(
          currentGuesses: gameInstanceWidgetStateManager.getGrid().guesses.length,
          averageGuesses: gameInstanceWidgetStateManager.getGameLevel().averageGuesses,
          bestAttempt: gameInstanceWidgetStateManager.getGameLevel().bestAttempt,),
        for (AcceptedGuess guess in gameInstanceWidgetStateManager.getGrid().guesses.reversed) ...[
          Text(guess.guess, style: TextStyle(fontSize: Constants.smallFont))
        ]
      ]
    );
  }
}
