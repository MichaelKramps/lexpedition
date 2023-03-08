import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_widgets/game_instance_widget.dart';

class OnePlayerLeftColumnWidget extends StatelessWidget {
  final GameInstanceWidgetStateManager gameInstanceWidgetStateManager;

  const OnePlayerLeftColumnWidget(
      {super.key, required this.gameInstanceWidgetStateManager});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start, 
      children:[
        Text(gameInstanceWidgetStateManager.getGrid().guesses.length.toString() + ' Guesses',
        style: TextStyle(fontSize: Constants.smallFont)),
        for (String guess in gameInstanceWidgetStateManager.getGrid().guesses.reversed) ...[
          Text(guess, style: TextStyle(fontSize: Constants.smallFont))
        ]
      ]
    );
  }
}
