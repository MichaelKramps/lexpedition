import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/accepted_guess.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:lexpedition/src/game_widgets/guesses_info_widget.dart';

class OnePlayerLeftColumnWidget extends StatelessWidget {
  final GameState gameState;

  const OnePlayerLeftColumnWidget(
      {super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 12),
      child: ListView( 
        children:[
          GuessesInformationWidget(
            currentGuesses: gameState.guessList.length,
            averageGuesses: gameState.level.averageGuesses.round(),
            bestAttempt: gameState.level.bestAttempt,),
          for (AcceptedGuess guess in gameState.guessList.reversed) ...[
            Text(guess.guess, style: TextStyle(fontSize: Constants.smallFont))
          ]
        ]
      ),
    );
  }
}
