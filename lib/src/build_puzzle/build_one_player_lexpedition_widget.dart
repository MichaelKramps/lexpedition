import 'package:flutter/material.dart';
import 'package:lexpedition/src/build_puzzle/blank_grid.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/game_data/letter_tile.dart';
import 'package:lexpedition/src/game_widgets/letter_tile_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/level_info/level_db_connection.dart';

class BuildOnePlayerLexpeditionWidget extends StatefulWidget {
  const BuildOnePlayerLexpeditionWidget({super.key});

  @override
  State<BuildOnePlayerLexpeditionWidget> createState() =>
      _BuildOnePlayerLexpeditionWidgetState();
}

class _BuildOnePlayerLexpeditionWidgetState
    extends State<BuildOnePlayerLexpeditionWidget> {
  LetterGrid _grid = new LetterGrid.forLexpeditionBuilder();
  int _selectedIndex = -1;
  int _step = 0;

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
                    child: Text('(|)')),
                ElevatedButton(
                    onPressed: () => {
                          setState(() => {_grid.addColumn()})
                        },
                    child: Text('+|')),
              ]),
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
                  child: Column(children: [
                    buildObstacleButton(true),
                    buildObstacleButton(false),
                    buildClearTileButton(),
                  ]),
                )
              ])
            ])),
        SizedBox(
            height: Constants().gridHeight(),
            width: Constants().gridWidth() + Constants().tileMargin(),
            child: ListView(
                padding: EdgeInsets.all(0),
                scrollDirection: Axis.horizontal,
                children: [
                  for (var column in _grid.columns) ...[
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (LetterTile letterTile in column) ...[
                            Listener(
                                onPointerDown: (event) {
                                  selectTile(letterTile.index);
                                },
                                child: LetterTileWidget(
                                    letterTile: letterTile,
                                    gameState: new GameState.emptyState(),
                                    blastDirection: _grid.blastDirection))
                          ]
                        ])
                  ]
                ])),
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
              LevelDatabaseConnection.createOnePlayerLexpeditionLevel(
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

  void selectTile(int index) {
    setState(() {
      _grid.unselectAll();
      _selectedIndex = index;
      _grid.letterTiles[index].select();
    });
  }

  bool showOptionOnStep(int step) {
    return step == _step;
  }

  Widget buildTileTypeButton(String path, TileType type) {
    return ElevatedButton(
        onPressed: () => {setLetterTile(tileType: type)},
        child: Text(type.toString()));
  }

  Widget buildLetterButton(String letter) {
    return ElevatedButton(
        style:
            TextButton.styleFrom(fixedSize: Size.square(Constants.smallFont)),
        onPressed: () => {setLetterTile(letter: letter)},
        child: Text(letter.toUpperCase(),
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
      {TileType? tileType, String? letter, int? requiredObstacleCharges}) {
    setState(() {
      LetterTile letterTile = _grid.letterTiles[_selectedIndex];

      TileType backupType = letterTile.tileType == TileType.empty
          ? TileType.basic
          : letterTile.tileType;
      String backupLetter = letterTile.letter == '' ? 'a' : letterTile.letter;
      int backupObstacleCharges = letterTile.requiredObstacleCharges == 0
          ? 0
          : letterTile.requiredObstacleCharges;

      letterTile.tileType = tileType == null ? backupType : tileType;
      letterTile.letter = letter == null ? backupLetter : letter;
      letterTile.requiredCharges = 1;
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
