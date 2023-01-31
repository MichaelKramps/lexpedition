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

  final Function(int, int) playerWon;

  const LetterGridWidget(
      {super.key, required this.letterGrid, required this.playerWon});

  @override
  State<LetterGridWidget> createState() => _LetterGridWidgetState();
}

class _LetterGridWidgetState extends State<LetterGridWidget> {
  late LetterGrid _grid = widget.letterGrid;
  String _guess = '';
  List<LetterTile> _guessTiles = [];
  bool _showBadGuess = false;

  GlobalKey gridKey = GlobalKey();
  late RenderBox renderBox =
      gridKey.currentContext?.findRenderObject() as RenderBox;
  late Offset gridPosition = renderBox.localToGlobal(Offset.zero);
  late double _gridx = gridPosition.dx;
  late double _gridy = gridPosition.dy;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = TextButton.styleFrom(
        backgroundColor: Colors.amber.withOpacity(0.75),
        side: BorderSide(width: 0, color: Colors.transparent));

    return Stack(children: [
      Container(
          decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/g4.bmp'), fit: BoxFit.cover),
      )),
      Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          SprayDirectionWidget(
              sprayDirection: _grid.sprayDirection,
              changeDirection: updateSprayDirection),
          Container(
              width: 280,
              margin: EdgeInsets.all(4),
              child: Text(_guess.toUpperCase(),
                  style: TextStyle(
                      fontSize: 32,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      color: _showBadGuess ? Colors.red : Colors.black))),
          Container(
              margin: EdgeInsets.all(4),
              child: ElevatedButton(
                  style: buttonStyle,
                  onPressed: submitGuess,
                  child: Text('Submit'))),
          ElevatedButton(
              style: buttonStyle, onPressed: clearGuess, child: Text('Clear')),
        ]),
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
          Expanded(
              flex: 1,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text(_grid.guesses.length.toString(),
                    style: TextStyle(fontSize: 45, color: Colors.black)),
                InkResponse(
                  onTap: () => GoRouter.of(context).push('/settings'),
                  child: Image.asset(
                    'assets/images/settings.png',
                    semanticLabel: 'Settings',
                  ),
                ),
                ElevatedButton(
                  onPressed: () => resetPuzzle(),
                  child: const Text('Reset'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => GoRouter.of(context).go('/'),
                  child: const Text('Back'),
                )
              ]))
        ])
      ])
    ]);
  }

  void updateGuess(int index) {
    LetterTile letterTile = _grid.letterTiles[index];
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
      for (LetterTile tile in _grid.letterTiles) {
        tile.selected = false;
      }
    });
  }

  void submitGuess() async {
    if (_guess.length < 3) {
      await showBadGuess();
    } else if (_grid.isNewGuess(_guess) && WordHelper.isValidWord(_guess)) {
      _grid.guesses.add(_guess);
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
        widget.playerWon(_grid.guesses.length, _grid.par);
      } else {
        if (_guess.length >= 5 || numberFullyCharged >= 3) {
          await fireSpray(_guessTiles.last);
          if (_grid.isFullyCharged()) {
            widget.playerWon(_grid.guesses.length, _grid.par);
          }
          await Future<void>.delayed(const Duration(milliseconds: 200));
        }
      }
    } else {
      await showBadGuess();
    }
    clearGuess();
  }

  Future<void> showBadGuess() async {
    setState(() {
      _showBadGuess = true;
    });
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    setState(() {
      _showBadGuess = false;
    });
  }

  void resetPuzzle() {
    setState(() {
      _grid.resetGrid();
      _guess = '';
      _guessTiles = [];
    });
  }

  void handleMouseEvent(
      double pointerx, double pointery, int shrinkClickableSpace) {
    int selectedIndex =
        determineTileIndex(pointerx, pointery, shrinkClickableSpace);

    if (selectedIndex > -1) {
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

    return (row * 6) + (column);
  }

  void updateSprayDirection() {
    setState(() {
      _grid.changeSprayDirection();
    });
  }

  Future<void> fireSpray(LetterTile lastTile) async {
    List<int> indexesToSpray = findSprayedIndexes(lastTile.index);

    log(indexesToSpray.toString());

    for (int index in indexesToSpray) {
      LetterTile thisTile = _grid.letterTiles[index];
      setState(() {
        thisTile.spray();
      });
      Future<void>.delayed(const Duration(milliseconds: 350), (() {
        setState(() {
          thisTile.unspray();
        });
      }));
    }

    log('finished firing spray');
  }

  List<int> findSprayedIndexes(int lastIndex) {
    List<int> indexesToSpray = [];

    int upInterval;
    int downInterval;

    switch (_grid.sprayDirection) {
      case (SprayDirection.horizontal):
        upInterval = 1;
        downInterval = -1;
        break;
      default:
        upInterval = 6;
        downInterval = -6;
    }

    int upIndex = lastIndex;
    while (upIndex > -1 && upIndex < 24) {
      indexesToSpray.add(upIndex);
      upIndex += upInterval;
      if (_grid.sprayDirection == SprayDirection.horizontal) {
        List<int> disqualifiers = [6, 12, 18];
        if (disqualifiers.contains(upIndex)) {
          break;
        }
      }
    }

    int downIndex = lastIndex + downInterval;
    while (downIndex > -1 && downIndex < 24) {
      indexesToSpray.add(downIndex);
      downIndex += downInterval;
      if (_grid.sprayDirection == SprayDirection.horizontal) {
        List<int> disqualifiers = [5, 11, 17];
        if (disqualifiers.contains(downIndex)) {
          break;
        }
      }
    }

    return indexesToSpray;
  }
}
