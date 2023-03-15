import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/constants.dart';

class GuessesInformationWidget extends StatefulWidget {
  final int currentGuesses;
  final int averageGuesses;
  final int bestAttempt;

  const GuessesInformationWidget(
      {super.key,
      required this.currentGuesses,
      this.averageGuesses = 100,
      this.bestAttempt = 100});

  @override
  State<GuessesInformationWidget> createState() =>
      _GuessesInformationWidgetState();
}

class _GuessesInformationWidgetState extends State<GuessesInformationWidget> {
  bool _menuOpen = false;

  @override
  Widget build(BuildContext context) {
    return determineVisibleContent();
  }

  Widget determineVisibleContent() {
    TextStyle textStyle = TextStyle(fontSize: Constants.smallFont);
    if (_menuOpen) {
      return Column(
        children: [
          Text('Mine: ' + widget.currentGuesses.toString(), style: textStyle),
          Text('Average: ' + widget.averageGuesses.toStringAsFixed(2), style: textStyle),
          Text('Best: ' + widget.bestAttempt.toString(), style: textStyle),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  _menuOpen = false;
                });
              },
              child: Text('-'))
        ],
      );
    } else {
      return ElevatedButton(
          onPressed: () {
            setState(() {
              _menuOpen = true;
            });
          },
          child: Text('+'));
    }
  }
}
