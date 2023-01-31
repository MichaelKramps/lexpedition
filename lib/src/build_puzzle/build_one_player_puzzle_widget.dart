import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:game_template/src/build_puzzle/blank_grid.dart';
import 'package:game_template/src/game_data/constants.dart';
import 'package:game_template/src/game_data/letter_grid.dart';
import 'package:game_template/src/game_widgets/letter_tile_widget.dart';

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
          child: Column(
            children: [
              Visibility(
                  visible: true,
                  child: Image.asset('assets/images/blue-basic.png')),
              Visibility(
                  visible: true,
                  child: Image.asset('assets/images/green-start.png')),
              Visibility(
                  visible: true,
                  child: Image.asset('assets/images/red-end.png')),
            ],
          )),
      Column(children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(_selectedIndex.toString())]),
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
            ])),
      ]),
      Expanded(
          flex: 1,
          child: ElevatedButton(
            onPressed: () => {},
            child: Text('hi'),
          ))
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

    setState(() {
      _selectedIndex = selectedIndex;
    });
  }
}
