import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:game_template/src/build_puzzle/blank_grid.dart';
import 'package:game_template/src/game_data/constants.dart';
import 'package:game_template/src/game_data/letter_grid.dart';
import 'package:game_template/src/game_data/letter_tile.dart';
import 'package:game_template/src/game_widgets/letter_tile_widget.dart';
import 'package:go_router/go_router.dart';

class BuildOnePlayerPuzzleWidget extends StatefulWidget {
  const BuildOnePlayerPuzzleWidget({super.key});

  @override
  State<BuildOnePlayerPuzzleWidget> createState() =>
      _BuildOnePlayerPuzzleWidgetState();
}

class _BuildOnePlayerPuzzleWidgetState
    extends State<BuildOnePlayerPuzzleWidget> {
  LetterGrid _grid = new LetterGrid(blankGrid, 1);
  int _selectedIndex = -1;

  GlobalKey gridKey = GlobalKey();
  late RenderBox renderBox =
      gridKey.currentContext?.findRenderObject() as RenderBox;
  late Offset gridPosition = renderBox.localToGlobal(Offset.zero);
  late double _gridx = gridPosition.dx;
  late double _gridy = gridPosition.dy;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          flex: 1,
          child: Stack(children: [
            Visibility(
                visible: showOptionOnStep(1),
                child: Column(children: [
                  buildTileTypeButton('blue-basic', TileType.basic),
                  buildTileTypeButton('green-start', TileType.start),
                  buildTileTypeButton('red-end', TileType.end),
                ])),
            Visibility(
                visible: showOptionOnStep(2),
                child: Column(
                  children: [
                    Row(children: [
                      buildLetterButton('a'),
                      buildLetterButton('b'),
                      buildLetterButton('c'),
                      buildLetterButton('d')
                    ]),
                    Row(children: [
                      buildLetterButton('e'),
                      buildLetterButton('f'),
                      buildLetterButton('g'),
                      buildLetterButton('h')
                    ]),
                    Row(children: [
                      buildLetterButton('i'),
                      buildLetterButton('j'),
                      buildLetterButton('k'),
                      buildLetterButton('l')
                    ]),
                    Row(children: [
                      buildLetterButton('m'),
                      buildLetterButton('n'),
                      buildLetterButton('o'),
                      buildLetterButton('p')
                    ]),
                    Row(children: [
                      buildLetterButton('q'),
                      buildLetterButton('r'),
                      buildLetterButton('s'),
                      buildLetterButton('t')
                    ]),
                    Row(children: [
                      buildLetterButton('u'),
                      buildLetterButton('v'),
                      buildLetterButton('w'),
                      buildLetterButton('x')
                    ]),
                    Row(children: [
                      buildLetterButton('y'),
                      buildLetterButton('z')
                    ]),
                  ],
                )),
            Visibility(
                visible: showOptionOnStep(3),
                child: Column(
                  children: [
                    buildChargesButton(1),
                    buildChargesButton(2),
                    buildChargesButton(3),
                    buildChargesButton(4)
                  ],
                )),
            Visibility(
              visible: showOptionOnStep(4),
              child: Column(children: [
                buildObstacleButton(true),
                buildObstacleButton(false)
              ]),
            )
          ])),
      Column(children: [
        Listener(
            key: gridKey,
            onPointerDown: selectTile,
            child: Column(children: [
              for (var row in _grid.rows) ...[
                Row(children: [
                  for (var letterTile in row) ...[
                    LetterTileWidget(
                        letterTile: letterTile,
                        sprayDirection: _grid.sprayDirection)
                  ]
                ])
              ]
            ]))
      ]),
      ElevatedButton(
        onPressed: () => GoRouter.of(context).push('/'),
        child: Text('Home'),
      )
    ]);
  }

  void selectTile(event) {
    double pointerx = event.position.dx;
    double pointery = event.position.dy;

    int xDistance = (pointerx - _gridx).round();
    int yDistance = (pointery - _gridy).round();

    int row = -1;
    int column = -1;

    if (yDistance > Constants.tileOneStart &&
        yDistance < Constants.tileOneEnd) {
      row = 0;
    } else if (yDistance > Constants.tileTwoStart &&
        yDistance < Constants.tileTwoEnd) {
      row = 1;
    } else if (yDistance > Constants.tileThreeStart &&
        yDistance < Constants.tileThreeEnd) {
      row = 2;
    } else if (yDistance > Constants.tileFourStart &&
        yDistance < Constants.tileFourEnd) {
      row = 3;
    }

    if (xDistance > Constants.tileOneStart &&
        xDistance < Constants.tileOneEnd) {
      column = 0;
    } else if (xDistance > Constants.tileTwoStart &&
        xDistance < Constants.tileTwoEnd) {
      column = 1;
    } else if (xDistance > Constants.tileThreeStart &&
        xDistance < Constants.tileThreeEnd) {
      column = 2;
    } else if (xDistance > Constants.tileFourStart &&
        xDistance < Constants.tileFourEnd) {
      column = 3;
    } else if (xDistance > Constants.tileFiveStart &&
        xDistance < Constants.tileFiveEnd) {
      column = 4;
    } else if (xDistance > Constants.tileSixStart &&
        xDistance < Constants.tileSixEnd) {
      column = 5;
    }

    int selectedIndex;

    if (row < 0 || column < 0) {
      selectedIndex = -1;
    } else {
      selectedIndex = (row * 6) + (column);
    }

    if (selectedIndex == _selectedIndex) {
      // something else
    } else {
      setState(() {
        if (_selectedIndex > -1) {
          _grid.letterTiles[_selectedIndex].unselect();
        }
        _selectedIndex = selectedIndex;
        _grid.letterTiles[selectedIndex].select();
      });
    }
  }

  bool showOptionOnStep(int step) {
    if (_selectedIndex < 0) {
      return false;
    }

    LetterTile selectedTile = _grid.letterTiles[_selectedIndex];

    bool typeSelected = selectedTile.tileType != TileType.empty;
    bool letterSelected = selectedTile.letter != '';
    bool chargesSelected = selectedTile.requiredCharges > 0;

    int currentStep = 1;
    if (chargesSelected) {
      currentStep = 4;
    } else if (letterSelected) {
      currentStep = 3;
    } else if (typeSelected) {
      currentStep = 2;
    }

    return step == currentStep;
  }

  Widget buildTileTypeButton(String path, TileType type) {
    return ElevatedButton(
        onPressed: () => {
              setState(() {
                _grid.letterTiles[_selectedIndex].tileType = type;
              })
            },
        child: Image.asset('assets/images/' + path + '.png',
            width: Constants.tileSize, height: Constants.tileSize));
  }

  Widget buildLetterButton(String letter) {
    return ElevatedButton(
        style:
            TextButton.styleFrom(fixedSize: Size.square(Constants.smallFont)),
        onPressed: () => {
              setState(() {
                _grid.letterTiles[_selectedIndex].letter = letter;
              })
            },
        child: Text(letter.toUpperCase(),
            style: TextStyle(fontSize: Constants.smallFont)));
  }

  Widget buildChargesButton(int numberCharges) {
    return ElevatedButton(
        style:
            TextButton.styleFrom(fixedSize: Size.square(Constants.smallFont)),
        onPressed: () => {
              setState(() {
                _grid.letterTiles[_selectedIndex].requiredCharges =
                    numberCharges;
              })
            },
        child: Text(numberCharges.toString(),
            style: TextStyle(fontSize: Constants.smallFont)));
  }

  Widget buildObstacleButton(bool add) {
    return ElevatedButton(
        onPressed: () => {
              setState(() {
                _grid.letterTiles[_selectedIndex].requiredObstacleCharges =
                    add ? 1 : 0;
              })
            },
        child: Text(add ? 'Add Obstacle' : 'Remove Obstacle',
            style: TextStyle(fontSize: Constants.verySmallFont)));
  }
}
