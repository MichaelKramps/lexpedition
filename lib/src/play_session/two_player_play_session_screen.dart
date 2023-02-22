import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/game_widgets/letter_grid_widget.dart';
import 'package:lexpedition/src/game_widgets/observer_letter_grid_widget.dart';

class TwoPlayerPlaySessionScreen extends StatefulWidget {
  final LetterGrid? myLetterGrid;
  final LetterGrid? theirLetterGrid;

  const TwoPlayerPlaySessionScreen(
      {super.key, required this.myLetterGrid, required this.theirLetterGrid});

  @override
  State<TwoPlayerPlaySessionScreen> createState() =>
      _TwoPlayerPlaySessionScreenState();
}

class _TwoPlayerPlaySessionScreenState
    extends State<TwoPlayerPlaySessionScreen> {
  bool _showingMyGrid = true;

  @override
  Widget build(BuildContext context) {
    if (widget.myLetterGrid != null && _showingMyGrid) {
      return LetterGridWidget(
          letterGrid: widget.myLetterGrid as LetterGrid,
          playerWon: (x, y) => {});
    } else {
      return ObserverLetterGridWidget(
          letterGrid: widget.theirLetterGrid as LetterGrid);
    }
  }
}
