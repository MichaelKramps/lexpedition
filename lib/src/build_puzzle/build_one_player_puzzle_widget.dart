import 'package:flutter/material.dart';
import 'package:lexpedition/src/build_puzzle/blank_grid.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/game_data/letter_tile.dart';
import 'package:lexpedition/src/game_widgets/letter_tile_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/level_info/level_db_connection.dart';

class BuildOnePlayerPuzzleWidget extends StatefulWidget {
  const BuildOnePlayerPuzzleWidget({super.key});

  @override
  State<BuildOnePlayerPuzzleWidget> createState() =>
      _BuildOnePlayerPuzzleWidgetState();
}

class _BuildOnePlayerPuzzleWidgetState
    extends State<BuildOnePlayerPuzzleWidget> {
  LetterGrid _grid = new LetterGrid(blankGrid);
  int _selectedIndex = -1;
  int _step = 0;

  GlobalKey gridKey = GlobalKey();
  late RenderBox renderBox =
      gridKey.currentContext?.findRenderObject() as RenderBox;
  late Offset gridPosition = renderBox.localToGlobal(Offset.zero);
  late double _gridx = gridPosition.dx;
  late double _gridy = gridPosition.dy;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
          decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(Constants.backgroundImagePath),
            fit: BoxFit.cover),
      )),
      Row(children: [
        Expanded(
            flex: 1,
            child: Column(children: [
              Row(children: [
                ElevatedButton(
                    onPressed: () => {
                          setState(() => {_step = 1})
                        },
                    child: Text('@')),
                ElevatedButton(
                    onPressed: () => {
                          setState(() => {_step = 2})
                        },
                    child: Text('A')),
                ElevatedButton(
                    onPressed: () => {
                          setState(() => {_step = 3})
                        },
                    child: Text('.')),
                ElevatedButton(
                    onPressed: () => {
                          setState(() => {_step = 4})
                        },
                    child: Text('(|)')),
              ]),
              SizedBox(height: 20),
              Stack(children: [
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
                    buildObstacleButton(false),
                    buildClearTileButton(),
                  ]),
                )
              ])
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
                          blastDirection: _grid.blastDirection)
                    ]
                  ])
                ]
              ]))
        ]),
        Column(children: [
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => {},
            child: Text('Test'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _grid.unselectAll();
              });
              LevelDatabaseConnection.createOnePlayerLevel(
                  _grid.encodedGridToString(), 'michael@kinship.games');
            },
            child: Text('Save'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => {
              setState(() => {_grid = new LetterGrid(blankGrid)})
            },
            child: Text('Clear'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => GoRouter.of(context).push('/'),
            child: Text('Home'),
          )
        ])
      ])
    ]);
  }

  void selectTile(event) {
    double pointerx = event.position.dx;
    double pointery = event.position.dy;

    int xDistance = (pointerx - _gridx).round();
    int yDistance = (pointery - _gridy).round();

    int row = -1;
    int column = -1;

    Constants constants = Constants();
    if (yDistance > constants.tileOneStart() &&
        yDistance < constants.tileOneEnd()) {
      row = 0;
    } else if (yDistance > constants.tileTwoStart() &&
        yDistance < constants.tileTwoEnd()) {
      row = 1;
    } else if (yDistance > constants.tileThreeStart() &&
        yDistance < constants.tileThreeEnd()) {
      row = 2;
    } else if (yDistance > constants.tileFourStart() &&
        yDistance < constants.tileFourEnd()) {
      row = 3;
    }

    if (xDistance > constants.tileOneStart() &&
        xDistance < constants.tileOneEnd()) {
      column = 0;
    } else if (xDistance > constants.tileTwoStart() &&
        xDistance < constants.tileTwoEnd()) {
      column = 1;
    } else if (xDistance > constants.tileThreeStart() &&
        xDistance < constants.tileThreeEnd()) {
      column = 2;
    } else if (xDistance > constants.tileFourStart() &&
        xDistance < constants.tileFourEnd()) {
      column = 3;
    } else if (xDistance > constants.tileFiveStart() &&
        xDistance < constants.tileFiveEnd()) {
      column = 4;
    } else if (xDistance > constants.tileSixStart() &&
        xDistance < constants.tileSixEnd()) {
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
    return step == _step;
  }

  Widget buildTileTypeButton(String path, TileType type) {
    return ElevatedButton(
        onPressed: () => {setLetterTile(tileType: type)},
        child: Image.asset('assets/images/' + path + '.png',
            width: Constants().tileSize(), height: Constants().tileSize()));
  }

  Widget buildLetterButton(String letter) {
    return ElevatedButton(
        style:
            TextButton.styleFrom(fixedSize: Size.square(Constants.smallFont)),
        onPressed: () => {setLetterTile(letter: letter)},
        child: Text(letter.toUpperCase(),
            style: TextStyle(fontSize: Constants.smallFont)));
  }

  Widget buildChargesButton(int numberCharges) {
    return ElevatedButton(
        style:
            TextButton.styleFrom(fixedSize: Size.square(Constants.smallFont)),
        onPressed: () => {setLetterTile(requiredCharges: numberCharges)},
        child: Text(numberCharges.toString(),
            style: TextStyle(fontSize: Constants.smallFont)));
  }

  Widget buildObstacleButton(bool add) {
    return ElevatedButton(
        onPressed: () => {setLetterTile(requiredObstacleCharges: add ? 1 : 0)},
        child: Text(add ? 'Add Obstacle' : 'Remove Obstacle',
            style: TextStyle(fontSize: Constants.verySmallFont)));
  }

  Widget buildClearTileButton() {
    return ElevatedButton(
        onPressed: clearSelectedTile,
        child: Text('Clear Tile',
            style: TextStyle(fontSize: Constants.verySmallFont)));
  }

  void setLetterTile(
      {TileType? tileType,
      String? letter,
      int? requiredCharges,
      int? requiredObstacleCharges}) {
    setState(() {
      LetterTile letterTile = _grid.letterTiles[_selectedIndex];

      TileType backupType = letterTile.tileType == TileType.empty
          ? TileType.basic
          : letterTile.tileType;
      String backupLetter = letterTile.letter == '' ? 'a' : letterTile.letter;
      int backupCharges =
          letterTile.requiredCharges == 0 ? 2 : letterTile.requiredCharges;
      int backupObstacleCharges = letterTile.requiredObstacleCharges == 0
          ? 0
          : letterTile.requiredObstacleCharges;

      letterTile.tileType = tileType == null ? backupType : tileType;
      letterTile.letter = letter == null ? backupLetter : letter;
      letterTile.requiredCharges =
          requiredCharges == null ? backupCharges : requiredCharges;
      letterTile.requiredObstacleCharges = requiredObstacleCharges == null
          ? backupObstacleCharges
          : requiredObstacleCharges;
    });
  }

  void clearSelectedTile() {
    setState(() {
      LetterTile letterTile = _grid.letterTiles[_selectedIndex];

      letterTile.letter = '';
      letterTile.tileType = TileType.empty;
      letterTile.requiredCharges = 0;
      letterTile.requiredObstacleCharges = 0;
    });
  }
}
