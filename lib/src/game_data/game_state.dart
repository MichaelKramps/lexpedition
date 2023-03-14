import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/accepted_guess.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';

class GameState extends ChangeNotifier {
  LetterGrid primaryLetterGrid;
  LetterGrid? secondaryLetterGrid;
  List<AcceptedGuess> guessList = [];

  GameState({required this.primaryLetterGrid, this.secondaryLetterGrid});
}
