import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:game_template/src/game_data/letter_grid.dart';
import 'package:game_template/src/game_data/letter_tile.dart';
import 'package:game_template/src/game_data/word_helper.dart';
import 'package:game_template/src/game_widgets/letter_tile_widget.dart';

class LetterGridWidget extends StatefulWidget {
  final LetterGrid letterGrid;

  final Function() playerWon;

  const LetterGridWidget(
      {super.key, required this.letterGrid, required this.playerWon});

  @override
  State<LetterGridWidget> createState() => _LetterGridWidgetState();
}

class _LetterGridWidgetState extends State<LetterGridWidget> {
  late LetterGrid _grid = widget.letterGrid;
  String _guess = '';
  List<LetterTile> _guessTiles = [];

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

  void updateGuess(LetterTile letterTile) {
    setState(() {
      _guess += letterTile.letter;
      _guessTiles.add(letterTile);
    });
  }

  void clearGuess() {
    setState(() {
      _guess = '';
      _guessTiles = [];
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
        for (int tile = 0; tile < _grid.letterTiles.length; tile++) {
          LetterTile? thisTile = _grid.letterTiles[tile];
          if (thisTile != null && thisTile.selected) {
            thisTile.selected = false;
            bool qualifiesAsBasicTile = thisTile.tileType == TileType.basic;
            bool qualifiesAsStartTile = thisTile.tileType == TileType.start &&
                thisTile == _guessTiles[0];
            bool qualifiesAsEndTile = thisTile.tileType == TileType.end &&
                thisTile == _guessTiles[_guessTiles.length - 1];
            if (qualifiesAsBasicTile ||
                qualifiesAsStartTile ||
                qualifiesAsEndTile) {
              thisTile.addCharge();
            }
          }
        }
      });
      // check for win condition
      if (_grid.isFullyCharged()) {
        widget.playerWon();
      }
    } else {
      log('invalid word');
    }
    clearGuess();
  }
}
