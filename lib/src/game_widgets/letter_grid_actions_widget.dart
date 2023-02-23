import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_widgets/blast_direction_widget.dart';
import 'package:lexpedition/src/game_widgets/game_instance_widget.dart';

class LetterGridActionsWidget extends StatelessWidget {
  final GameInstanceWidgetStateManager gameInstanceWidgetStateManager;

  const LetterGridActionsWidget(
      {super.key, required this.gameInstanceWidgetStateManager});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = TextButton.styleFrom(
        backgroundColor: Colors.amber.withOpacity(0.75),
        side: BorderSide(width: 0, color: Colors.transparent));

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      BlastDirectionWidget(
          blastDirection:
              gameInstanceWidgetStateManager.getGrid().blastDirection,
          changeDirection: gameInstanceWidgetStateManager.toggleBlastDirection),
      Container(
          width: Constants.tileSize * 3.5,
          margin: EdgeInsets.all(Constants.tileMargin * 2),
          child: Text(gameInstanceWidgetStateManager.getCurrentGuess(),
              style: TextStyle(
                  fontSize: Constants.tileSize * 0.4,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  color: gameInstanceWidgetStateManager.showBadGuess
                      ? Colors.red
                      : Colors.black))),
      Container(
          margin: EdgeInsets.all(Constants.tileMargin * 2),
          child: ElevatedButton(
              style: buttonStyle,
              onPressed: gameInstanceWidgetStateManager.submitGuess,
              child: Text('Submit'))),
      ElevatedButton(
          style: buttonStyle,
          onPressed: gameInstanceWidgetStateManager.clearGuess,
          child: Text('Clear')),
    ]);
  }
}
