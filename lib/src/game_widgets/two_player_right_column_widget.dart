import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/game_state.dart';

class TwoPlayerRightColumnWidget extends StatelessWidget {
  final GameState gameState;

  const TwoPlayerRightColumnWidget(
      {super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () => gameState.toggleVisibleScreen(), child: Text('Switch'));
  }
}
