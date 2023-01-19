import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:game_template/src/game_data/letter_grid.dart';
import 'package:game_template/src/game_data/letter_tile.dart';
import 'package:game_template/src/game_data/word_helper.dart';
import 'package:game_template/src/game_widgets/letter_tile_widget.dart';

class LetterGridWidget extends StatefulWidget {
  final LetterGrid letterGrid;

  const LetterGridWidget({super.key, required this.letterGrid});

  @override
  State<LetterGridWidget> createState() => _LetterGridWidgetState();
}

class _LetterGridWidgetState extends State<LetterGridWidget> {
  late LetterGrid _grid = widget.letterGrid;
  String _guess = '';

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(_guess, style: TextStyle(fontSize: 32)),
      for (var row in _grid.rows) ...[
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          for (var letterTile in row) ...[
            LetterTileWidget(
                letterTile: letterTile, updateGuess: this.updateGuess)
          ]
        ])
      ],
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton(onPressed: submitGuess, child: Text('Submit')),
        ElevatedButton(onPressed: clearGuess, child: Text('Clear')),
      ])
    ]);
  }

  void updateGuess(String letter) {
    setState(() {
      _guess += letter;
    });
  }

  void clearGuess() {
    setState(() {
      _guess = '';
      for (LetterTile? tile in _grid.letterTiles) {
        if (tile != null) {
          tile.selected = false;
        }
      }
    });
  }

  void submitGuess() {
    if (_guess.length < 3) {
      log('guess must be at least 3 letters');
    } else if (WordHelper.isValidWord(_guess)) {
      setState(() {
        for (LetterTile? tile in _grid.letterTiles) {
          if (tile != null && tile.selected) {
            //will need to consider start and end tiles
            tile.selected = false;
            tile.addCharge();
          }
        }
      });
      // check for win condition
      if (_grid.isFullyCharged()) {
        log('grid fully charged!');
      }
    } else {
      log('invalid word');
    }
    clearGuess();
  }
}
