import 'package:flutter/material.dart';
import 'package:game_template/src/game_data/letter_grid.dart';
import 'package:game_template/src/game_widgets/letter_tile_widget.dart';

class LetterGridWidget extends StatelessWidget {
  final LetterGrid letterGrid;

  LetterGridWidget({super.key, required this.letterGrid});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      for (var row in letterGrid.rows) ...[
        Row(children: [
          for (var letterTile in row) ...[
            LetterTileWidget(letterTile: letterTile)
          ]
        ])
      ]
    ]);
  }
}
