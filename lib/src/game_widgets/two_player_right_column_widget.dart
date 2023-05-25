import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:lexpedition/src/game_widgets/letter_grid_widget.dart';
import 'package:provider/provider.dart';

class TwoPlayerRightColumnWidget extends StatelessWidget {
  final GameState gameState;

  const TwoPlayerRightColumnWidget({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(builder: (context, gameState, child) {
      if (gameState.getTheirGrid() != null && gameState.getMyGrid() != null) {
        return FittedBox(
          child: LetterGridWidget(
            gameState: gameState, 
            letterGrid: gameState.getTheirGrid()!
          )
        );
      } else {
        return SizedBox.shrink();
      }
    });
  }
}
