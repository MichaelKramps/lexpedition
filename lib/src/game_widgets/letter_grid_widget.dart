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
  SprayDirection sprayDirection = SprayDirection.up;

  GlobalKey gridKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(_guess, style: TextStyle(fontSize: 32)),
      Row(children: [
        Spacer(),
        Listener(
            key: gridKey,
            onPointerDown: (event) =>
                {handleMouseEvent(event.position.dx, event.position.dy)},
            onPointerMove: (event) =>
                {handleMouseEvent(event.position.dx, event.position.dy)},
            child: Column(children: [
              for (var row in _grid.rows) ...[
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  for (var letterTile in row) ...[
                    LetterTileWidget(letterTile: letterTile)
                  ]
                ])
              ]
            ])),
        Spacer()
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton(onPressed: submitGuess, child: Text('Submit')),
        ElevatedButton(onPressed: clearGuess, child: Text('Clear')),
      ])
    ]);
  }

  void updateGuess(int index) {
    LetterTile letterTile = _grid.letterTiles[index] ??
        new LetterTile('a', TileType.basic, 0, 0, 0);
    //verify we are allowed to select this tile
    if (_guess.length == 0 || _guessTiles.last.allowedToSelect(letterTile)) {
      setState(() {
        letterTile.select();
        _guess += letterTile.letter;
        _guessTiles.add(letterTile);
      });
    }
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

  void handleMouseEvent(double pointerx, double pointery) {
    int selectedIndex = determineTileIndex(pointerx, pointery);

    if (selectedIndex > -1 && _grid.letterTiles[selectedIndex] != null) {
      updateGuess(selectedIndex);
    }
  }

  int determineTileIndex(double pointerx, double pointery) {
    RenderBox? renderBox =
        gridKey.currentContext?.findRenderObject() as RenderBox;
    Offset gridPosition = renderBox.localToGlobal(Offset.zero);
    double gridx = gridPosition.dx;
    double gridy = gridPosition.dy;

    int xDistance = (pointerx - gridx).round();
    int yDistance = (pointery - gridy).round();

    int row = -1;
    int column = -1;

    if (yDistance > 10 && yDistance < 81) {
      row = 0;
    } else if (yDistance > 90 && yDistance < 161) {
      row = 1;
    } else if (yDistance > 170 && yDistance < 241) {
      row = 2;
    } else if (yDistance > 250 && yDistance < 321) {
      row = 3;
    }

    if (xDistance > 10 && xDistance < 81) {
      column = 0;
    } else if (xDistance > 90 && xDistance < 161) {
      column = 1;
    } else if (xDistance > 170 && xDistance < 241) {
      column = 2;
    } else if (xDistance > 250 && xDistance < 321) {
      column = 3;
    } else if (xDistance > 330 && xDistance < 401) {
      column = 4;
    } else if (xDistance > 410 && xDistance < 481) {
      column = 5;
    }

    if (row < 0 || column < 0) {
      return -1;
    }

    int index = (row * 6) + (column);

    return (row * 6) + (column);
  }
}
