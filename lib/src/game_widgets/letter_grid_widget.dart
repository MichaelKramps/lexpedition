import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/game_data/letter_tile.dart';
import 'package:lexpedition/src/game_widgets/letter_tile_widget.dart';

class LetterGridWidget extends StatelessWidget {
  final LetterGrid letterGrid;

  const LetterGridWidget({super.key, required this.letterGrid});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var row in letterGrid.rows) ...[
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            for (LetterTile letterTile in row) ...[
              LetterTileWidget(
                  letterTile: letterTile,
                  blastDirection: letterGrid.blastDirection)
            ]
          ])
        ]
      ]
    );
  }
}