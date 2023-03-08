import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/accepted_guess.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/game_widgets/game_instance_widget.dart';
import 'package:lexpedition/src/play_session/two_player_play_session_screen.dart';
import 'package:logging/logging.dart';

class TwoPlayerLeftColumnWidget extends StatelessWidget {
  final GameInstanceWidgetStateManager? gameInstanceWidgetStateManager;
  final TwoPlayerPlaySessionStateManager twoPlayerPlaySessionStateManager;

  const TwoPlayerLeftColumnWidget(
      {super.key,
      required this.twoPlayerPlaySessionStateManager,
      this.gameInstanceWidgetStateManager});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Text(getTotalNumberGuesses() + ' Guesses',
          style: TextStyle(fontSize: Constants.smallFont)),
      for (AcceptedGuess guess in getAllGuessesInOrder()) ...[
        Text(guess.guess.toUpperCase(),
            style: TextStyle(
                fontSize: Constants.smallFont,
                color: guess.fromMe ? Colors.black : Colors.white))
      ]
    ]);
  }

  String getTotalNumberGuesses() {
    int numberGuesses = 0;

    if (twoPlayerPlaySessionStateManager.getTheirLetterGrid() != null) {
      LetterGrid theirGrid =
          twoPlayerPlaySessionStateManager.getTheirLetterGrid() as LetterGrid;
      numberGuesses += theirGrid.guesses.length;
    }

    if (twoPlayerPlaySessionStateManager.getMyLetterGrid() != null) {
      LetterGrid myGrid =
          twoPlayerPlaySessionStateManager.getMyLetterGrid() as LetterGrid;
      numberGuesses += myGrid.guesses.length;
    }

    return numberGuesses.toString();
  }

  List<AcceptedGuess> getAllGuessesInOrder() {
    List<AcceptedGuess> allGuesses = [];

    if (twoPlayerPlaySessionStateManager.getMyLetterGrid() != null) {
      LetterGrid myGrid =
          twoPlayerPlaySessionStateManager.getMyLetterGrid() as LetterGrid;
      allGuesses.addAll(myGrid.guesses);
    }

    if (twoPlayerPlaySessionStateManager.getTheirLetterGrid() != null) {
      LetterGrid theirGrid =
          twoPlayerPlaySessionStateManager.getTheirLetterGrid() as LetterGrid;
      allGuesses.addAll(theirGrid.guesses);
    }

    allGuesses.sort((a, b) => b.timeSubmitted.compareTo(a.timeSubmitted));
    return allGuesses;
  }
}
