import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:game_template/src/game_data/letter_grid.dart';
import 'package:game_template/src/game_data/letter_tile.dart';
import 'package:game_template/src/game_data/word_helper.dart';
import 'package:game_template/src/game_widgets/letter_tile_widget.dart';
import 'package:game_template/src/game_widgets/spray_direction_widget.dart';
import 'package:go_router/go_router.dart';

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
  late RenderBox renderBox =
      gridKey.currentContext?.findRenderObject() as RenderBox;
  late Offset gridPosition = renderBox.localToGlobal(Offset.zero);
  late double _gridx = gridPosition.dx;
  late double _gridy = gridPosition.dy;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(_guess, style: TextStyle(fontSize: 32)),
      Row(children: [
        Spacer(),
        Listener(
            key: gridKey,
            onPointerDown: (event) =>
                {handleMouseEvent(event.position.dx, event.position.dy, 0)},
            onPointerMove: (event) =>
                {handleMouseEvent(event.position.dx, event.position.dy, 10)},
            child: Column(children: [
              for (var row in _grid.rows) ...[
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  for (var letterTile in row) ...[
                    LetterTileWidget(
                        letterTile: letterTile,
                        sprayDirection: _grid.sprayDirection)
                  ]
                ])
              ]
            ])),
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          InkResponse(
            onTap: () => GoRouter.of(context).push('/settings'),
            child: Image.asset(
              'assets/images/settings.png',
              semanticLabel: 'Settings',
            ),
          ),
          SprayDirectionWidget(
              sprayDirection: _grid.sprayDirection,
              changeDirection: updateSprayDirection),
          ElevatedButton(onPressed: submitGuess, child: Text('Submit')),
          ElevatedButton(onPressed: clearGuess, child: Text('Clear')),
          ElevatedButton(
            onPressed: () => GoRouter.of(context).go('/tutorial'),
            child: const Text('Back'),
          ),
        ])
      ])
    ]);
  }

  void updateGuess(int index) {
    LetterTile letterTile = _grid.letterTiles[index] ??
        new LetterTile('a', TileType.basic, 0, 0, 0);
    //verify we are allowed to select this tile
    if (letterTile.clearOfObstacles() &&
        (_guess.length == 0 || _guessTiles.last.allowedToSelect(letterTile))) {
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

  void submitGuess() async {
    if (_guess.length < 3) {
      log('guess must be at least 3 letters');
    } else if (WordHelper.isValidWord(_guess)) {
      int numberFullyCharged = 0;
      setState(() {
        for (int tile = 0; tile < _guessTiles.length; tile++) {
          LetterTile thisTile = _guessTiles[tile];
          thisTile.selected = false;
          bool qualifiesAsBasicTile = thisTile.tileType == TileType.basic;
          bool qualifiesAsStartTile =
              thisTile.tileType == TileType.start && thisTile == _guessTiles[0];
          bool qualifiesAsEndTile = thisTile.tileType == TileType.end &&
              thisTile == _guessTiles[_guessTiles.length - 1];
          if (qualifiesAsBasicTile ||
              qualifiesAsStartTile ||
              qualifiesAsEndTile) {
            thisTile.addCharge();
            if (thisTile.currentCharges == thisTile.requiredCharges) {
              numberFullyCharged += 1;
            }
          }
        }
      });
      // check for win condition
      if (_grid.isFullyCharged()) {
        widget.playerWon();
      } else {
        if (_guess.length >= 5 || numberFullyCharged >= 3) {
          fireSpray(_guessTiles.last);
          if (_grid.isFullyCharged()) {
            widget.playerWon();
          }
          await Future<void>.delayed(const Duration(milliseconds: 200));
        }
      }
    } else {
      log('invalid word');
    }
    clearGuess();
  }

  void handleMouseEvent(
      double pointerx, double pointery, int shrinkClickableSpace) {
    int selectedIndex =
        determineTileIndex(pointerx, pointery, shrinkClickableSpace);

    if (selectedIndex > -1 && _grid.letterTiles[selectedIndex] != null) {
      updateGuess(selectedIndex);
    }
  }

  int determineTileIndex(double pointerx, double pointery, int shrink) {
    int xDistance = (pointerx - _gridx).round();
    int yDistance = (pointery - _gridy).round();

    int row = -1;
    int column = -1;

    if (yDistance > (10 + shrink) && yDistance < (81 - shrink)) {
      row = 0;
    } else if (yDistance > (90 + shrink) && yDistance < (161 - shrink)) {
      row = 1;
    } else if (yDistance > (170 + shrink) && yDistance < (241 - shrink)) {
      row = 2;
    } else if (yDistance > (250 + shrink) && yDistance < (321 - shrink)) {
      row = 3;
    }

    if (xDistance > (10 + shrink) && xDistance < (81 - shrink)) {
      column = 0;
    } else if (xDistance > (90 + shrink) && xDistance < (161 - shrink)) {
      column = 1;
    } else if (xDistance > (170 + shrink) && xDistance < (241 - shrink)) {
      column = 2;
    } else if (xDistance > (250 + shrink) && xDistance < (321 - shrink)) {
      column = 3;
    } else if (xDistance > (330 + shrink) && xDistance < (401 - shrink)) {
      column = 4;
    } else if (xDistance > (410 + shrink) && xDistance < (481 - shrink)) {
      column = 5;
    }

    if (row < 0 || column < 0) {
      return -1;
    }

    int index = (row * 6) + (column);

    return (row * 6) + (column);
  }

  void updateSprayDirection() {
    setState(() {
      _grid.changeSprayDirection();
    });
  }

  void fireSpray(LetterTile lastTile) async {
    List<int> indexesToSpray = findSprayedIndexes(lastTile.index);

    setState(() {
      lastTile.spray();
    });
    await Future<void>.delayed(const Duration(milliseconds: 75));
    setState(() {
      lastTile.unspray();
    });

    for (int index in indexesToSpray) {
      LetterTile? thisTile = _grid.letterTiles[index];
      await Future<void>.delayed(const Duration(milliseconds: 75));
      setState(() {
        thisTile?.spray();
        thisTile?.addCharge();
      });
      await Future<void>.delayed(const Duration(milliseconds: 75));
      setState(() {
        thisTile?.unspray();
      });
    }
  }

  List<int> findSprayedIndexes(int lastIndex) {
    List<int> indexesToSpray = [];

    int interval;

    switch (_grid.sprayDirection) {
      case (SprayDirection.up):
        interval = -6;
        break;
      case (SprayDirection.right):
        interval = 1;
        break;
      case (SprayDirection.down):
        interval = 6;
        break;
      case (SprayDirection.left):
        interval = -1;
        break;
    }

    int currentIndex = lastIndex;

    while (currentIndex > -1 && currentIndex < 24) {
      currentIndex += interval;
      if (_grid.sprayDirection == SprayDirection.right) {
        List<int> disqualifiers = [6, 12, 18];
        if (disqualifiers.contains(currentIndex)) {
          break;
        }
      }
      if (_grid.sprayDirection == SprayDirection.left) {
        List<int> disqualifiers = [5, 11, 17];
        if (disqualifiers.contains(currentIndex)) {
          break;
        }
      }
      indexesToSpray.add(currentIndex);
    }

    return indexesToSpray;
  }
}
