import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/game_data/letter_tile.dart';
import 'package:lexpedition/src/game_data/word_helper.dart';
import 'package:lexpedition/src/game_widgets/letter_tile_widget.dart';
import 'package:lexpedition/src/game_widgets/spray_direction_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/party/party_db_connection.dart';
import 'package:logging/logging.dart';

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
  List<LetterTile> _guessTiles = [];
  bool _showBadGuess = false;
  PartyDatabaseConnection partyDatabaseConnection = PartyDatabaseConnection();

  GlobalKey gridKey = GlobalKey();
  late RenderBox renderBox =
      gridKey.currentContext?.findRenderObject() as RenderBox;
  late Offset gridPosition = renderBox.localToGlobal(Offset.zero);
  late double _gridx = gridPosition.dx;
  late double _gridy = gridPosition.dy;

  @override
  void initState() {
    super.initState();
    partyDatabaseConnection.updateMyPuzzle(_grid);
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = TextButton.styleFrom(
        backgroundColor: Colors.amber.withOpacity(0.75),
        side: BorderSide(width: 0, color: Colors.transparent));

    return Stack(children: [
      Container(
          decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(Constants.backgroundImagePath),
            fit: BoxFit.cover),
      )),
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          SprayDirectionWidget(
              sprayDirection: _grid.sprayDirection,
              changeDirection: updateSprayDirection),
          Container(
              width: Constants.tileSize * 3.5,
              margin: EdgeInsets.all(Constants.tileMargin * 2),
              child: Text(getGuess(),
                  style: TextStyle(
                      fontSize: Constants.tileSize * 0.4,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      color: _showBadGuess ? Colors.red : Colors.black))),
          Container(
              margin: EdgeInsets.all(Constants.tileMargin * 2),
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
              onPointerDown: (event) => {
                    handleMouseEvent(event.position.dx, event.position.dy, true)
                  },
              onPointerMove: (event) => {
                    handleMouseEvent(
                        event.position.dx, event.position.dy, false)
                  },
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
                  child: const Text('Restart'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => GoRouter.of(context).go('/'),
                  child: const Text('Home'),
                )
              ]))
        ])
      ])
    ]);
  }

  void updateGuess(LetterTile letterTile, bool clickEvent) {
    //verify we are allowed to select this tile
    if (letterTile.clearOfObstacles() &&
        (_guessTiles.length == 0 ||
            _guessTiles.last.allowedToSelect(letterTile))) {
      new Logger('me').info('running here');
      setState(() {
        letterTile.select();
        _guessTiles.add(letterTile);
      });
    } else if (clickEvent && letterTile == _guessTiles.last) {
      setState(() {
        letterTile.unselect();
        _guessTiles.removeLast();
      });
    }
  }

  String getGuess() {
    String guess = '';
    for (LetterTile tile in _guessTiles) {
      guess += tile.letter;
    }

    return guess.toUpperCase();
  }

  void clearGuess() {
    setState(() {
      _guessTiles = [];
      for (LetterTile tile in _grid.letterTiles) {
        tile.unselect();
      }
    });
  }

  void submitGuess() async {
    if (_guessTiles.length < 3) {
      await showBadGuess();
    } else if (_grid.isNewGuess(getGuess()) &&
        WordHelper.isValidWord(getGuess())) {
      _grid.guesses.add(getGuess());
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
        if (_guessTiles.length >= 5 || numberFullyCharged >= 3) {
          await fireSpray(_guessTiles.last);
          if (_grid.isFullyCharged()) {
            widget.playerWon(_grid.guesses.length, _grid.par);
          }
          await Future<void>.delayed(const Duration(milliseconds: 200));
        }
      }

      partyDatabaseConnection.updateMyPuzzle(_grid);
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
      _guessTiles = [];
    });
  }

  void handleMouseEvent(double pointerx, double pointery, bool clickEvent) {
    int shrinkClickableSpace = clickEvent ? 0 : 10;
    int selectedIndex =
        determineTileIndex(pointerx, pointery, shrinkClickableSpace);

    if (selectedIndex > -1) {
      LetterTile selectedTile = _grid.letterTiles[selectedIndex];
      if (selectedTile.tileType != TileType.empty) {
        updateGuess(selectedTile, clickEvent);
      }
    }
  }

  int determineTileIndex(double pointerx, double pointery, int shrink) {
    int xDistance = (pointerx - _gridx).round();
    int yDistance = (pointery - _gridy).round();

    int row = -1;
    int column = -1;

    if (yDistance > (Constants.tileOneStart + shrink) &&
        yDistance < (Constants.tileOneEnd - shrink)) {
      row = 0;
    } else if (yDistance > (Constants.tileTwoStart + shrink) &&
        yDistance < (Constants.tileTwoEnd - shrink)) {
      row = 1;
    } else if (yDistance > (Constants.tileThreeStart + shrink) &&
        yDistance < (Constants.tileThreeEnd - shrink)) {
      row = 2;
    } else if (yDistance > (Constants.tileFourStart + shrink) &&
        yDistance < (Constants.tileFourEnd - shrink)) {
      row = 3;
    }

    if (xDistance > (Constants.tileOneStart + shrink) &&
        xDistance < (Constants.tileOneEnd - shrink)) {
      column = 0;
    } else if (xDistance > (Constants.tileTwoStart + shrink) &&
        xDistance < (Constants.tileTwoEnd - shrink)) {
      column = 1;
    } else if (xDistance > (Constants.tileThreeStart + shrink) &&
        xDistance < (Constants.tileThreeEnd - shrink)) {
      column = 2;
    } else if (xDistance > (Constants.tileFourStart + shrink) &&
        xDistance < (Constants.tileFourEnd - shrink)) {
      column = 3;
    } else if (xDistance > (Constants.tileFiveStart + shrink) &&
        xDistance < (Constants.tileFiveEnd - shrink)) {
      column = 4;
    } else if (xDistance > (Constants.tileSixStart + shrink) &&
        xDistance < (Constants.tileSixEnd - shrink)) {
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
  }

  List<int> findSprayedIndexes(int lastIndex) {
    List<List<int>> rows = [
      [0, 1, 2, 3, 4, 5],
      [6, 7, 8, 9, 10, 11],
      [12, 13, 14, 15, 16, 17],
      [18, 19, 20, 21, 22, 23]
    ];
    List<List<int>> columns = [
      [0, 6, 12, 18],
      [1, 7, 13, 19],
      [2, 8, 14, 20],
      [3, 9, 15, 21],
      [4, 10, 16, 22],
      [5, 11, 17, 23]
    ];

    if (_grid.sprayDirection == SprayDirection.horizontal) {
      int whichRow = (lastIndex / 6).floor();
      return rows[whichRow];
    } else {
      int whichColumn = lastIndex % 6;
      return columns[whichColumn];
    }
  }
}
