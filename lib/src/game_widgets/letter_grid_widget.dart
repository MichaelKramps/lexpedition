import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/game_data/letter_tile.dart';
import 'package:lexpedition/src/game_widgets/letter_tile_widget.dart';

class LetterGridWidget extends StatelessWidget {
  final LetterGrid letterGrid;
  final GameState gameState;

  const LetterGridWidget({super.key, required this.letterGrid, required this.gameState});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      for (var column in letterGrid.columns) ...[
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          for (LetterTile letterTile in column) ...[
            LetterTileWidget(
                letterTile: letterTile,
                gameState: gameState,
                blastDirection: letterGrid.blastDirection)
          ]
        ])
      ]
    ]);
  }
}
