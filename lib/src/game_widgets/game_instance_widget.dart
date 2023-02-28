import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/blast_direction.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/game_data/letter_tile.dart';
import 'package:lexpedition/src/game_data/word_helper.dart';
import 'package:lexpedition/src/game_data/game_column.dart';
import 'package:lexpedition/src/game_widgets/letter_grid_actions_widget.dart';
import 'package:lexpedition/src/game_widgets/letter_grid_widget.dart';
import 'package:lexpedition/src/game_widgets/one_player_left_column_widget.dart';
import 'package:lexpedition/src/game_widgets/one_player_right_column_widget.dart';
import 'package:lexpedition/src/game_widgets/two_player_left_column_widget.dart';
import 'package:lexpedition/src/game_widgets/two_player_right_column_widget.dart';
import 'package:lexpedition/src/party/party_db_connection.dart';
import 'package:lexpedition/src/play_session/two_player_play_session_screen.dart';
import 'package:logging/logging.dart';
import 'package:wakelock/wakelock.dart';

class GameInstanceWidget extends StatefulWidget {
  final LetterGrid letterGrid;
  final GameColumn leftColumn;
  final GameColumn rightColumn;
  final Function(int, int) playerWon;
  final TwoPlayerPlaySessionStateManager? twoPlayerPlaySessionStateManager;

  GameInstanceWidget(
      {super.key,
      required this.letterGrid,
      required this.playerWon,
      required this.leftColumn,
      required this.rightColumn,
      this.twoPlayerPlaySessionStateManager});

  @override
  State<GameInstanceWidget> createState() => _GameInstanceWidgetState();
}

class _GameInstanceWidgetState extends State<GameInstanceWidget> {
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
    WordHelper.isValidWord('preload');
    Wakelock.enable();
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GameInstanceWidgetStateManager gameInstanceWidgetStateManager =
        GameInstanceWidgetStateManager(
            gameInstanceWidgetState: this, showBadGuess: _showBadGuess);

    return Row(children: [
      Expanded(child: determineColumn(widget.leftColumn)),
      Column(children: [
        LetterGridActionsWidget(
            gameInstanceWidgetStateManager: gameInstanceWidgetStateManager),
        Listener(
            key: gridKey,
            onPointerDown: (event) =>
                {handleMouseEvent(event.position.dx, event.position.dy, true)},
            onPointerMove: (event) =>
                {handleMouseEvent(event.position.dx, event.position.dy, false)},
            child: LetterGridWidget(letterGrid: _grid))
      ]),
      Expanded(child: determineColumn(widget.rightColumn))
    ]);
  }

  Widget determineColumn(GameColumn gameColumn) {
    GameInstanceWidgetStateManager gameInstanceWidgetStateManager =
        GameInstanceWidgetStateManager(
            gameInstanceWidgetState: this, showBadGuess: _showBadGuess);

    switch (gameColumn) {
      case GameColumn.onePlayerRightColumn:
        return OnePlayerRightColumnWidget(
            gameInstanceWidgetStateManager: gameInstanceWidgetStateManager);
      case GameColumn.onePlayerLeftColumn:
        return OnePlayerLeftColumnWidget(
            gameInstanceWidgetStateManager: gameInstanceWidgetStateManager);
      case GameColumn.twoPlayerRightColumn:
        return TwoPlayerRightColumnWidget(
            gameInstanceWidgetStateManager: gameInstanceWidgetStateManager,
            twoPlayerPlaySessionStateManager:
                widget.twoPlayerPlaySessionStateManager
                    as TwoPlayerPlaySessionStateManager);
      case GameColumn.twoPlayerLeftColumn:
        return TwoPlayerLeftColumnWidget(
            gameInstanceWidgetStateManager: gameInstanceWidgetStateManager,
            twoPlayerPlaySessionStateManager:
                widget.twoPlayerPlaySessionStateManager
                    as TwoPlayerPlaySessionStateManager);
      default:
        return Container();
    }
  }

  void updateGuess(LetterTile letterTile, bool clickEvent) {
    //verify we are allowed to select this tile
    if (letterTile.clearOfObstacles() &&
        (_guessTiles.length == 0 ||
            _guessTiles.last.allowedToSelect(letterTile))) {
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
    partyDatabaseConnection.updateMyPuzzle(_grid);
  }

  String getCurrentGuess() {
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
    } else if (_grid.isNewGuess(getCurrentGuess()) &&
        WordHelper.isValidWord(getCurrentGuess())) {
      _grid.guesses.add(getCurrentGuess());
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
          }
        }
      });
      // check for win condition
      if (isLevelWon(_grid,
          widget.twoPlayerPlaySessionStateManager?.getTheirLetterGrid())) {
        widget.playerWon(_grid.guesses.length, _grid.par);
      } else {
        if (_guessTiles.length >= 5) {
          await fireBlast(_guessTiles.last);
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

  bool isLevelWon(
      LetterGrid primaryLetterGrid, LetterGrid? secondaryLetterGrid) {
    Logger logger = new Logger('isLevelWon');
    if (secondaryLetterGrid == null) {
      logger.info('no secondary grid info');
      return primaryLetterGrid.isFullyCharged();
    } else {
      logger.info('secondary grid');
      logger.info(primaryLetterGrid.isFullyCharged());
      logger.info(secondaryLetterGrid.isFullyCharged());
      return primaryLetterGrid.isFullyCharged() &&
          secondaryLetterGrid.isFullyCharged();
    }
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

  void toggleBlastDirection() {
    setState(() {
      _grid.changeBlastDirection();
    });
  }

  Future<void> fireBlast(LetterTile lastTile) async {
    List<int> indexesToBlast = findBlastedIndexes(lastTile.index);

    for (int index in indexesToBlast) {
      LetterTile thisTile = _grid.letterTiles[index];
      setState(() {
        thisTile.blast();
      });
    }
    partyDatabaseConnection.updateMyPuzzle(_grid);

    Future<void>.delayed(const Duration(milliseconds: 350), () {
      for (int index in indexesToBlast) {
        LetterTile thisTile = _grid.letterTiles[index];
        setState(() {
          thisTile.unblast();
        });
      }
      partyDatabaseConnection.updateMyPuzzle(_grid);
    });
  }

  List<int> findBlastedIndexes(int lastIndex) {
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

    if (_grid.blastDirection == BlastDirection.horizontal) {
      int whichRow = (lastIndex / 6).floor();
      List<int> indexesToBlast = rows[whichRow];
      return indexesToBlast;
    } else {
      int whichColumn = lastIndex % 6;
      List<int> indexesToBlast = columns[whichColumn];
      return indexesToBlast;
    }
  }
}

class GameInstanceWidgetStateManager {
  _GameInstanceWidgetState gameInstanceWidgetState;
  bool showBadGuess;

  GameInstanceWidgetStateManager(
      {required this.gameInstanceWidgetState, required this.showBadGuess});

  LetterGrid getGrid() {
    return gameInstanceWidgetState._grid;
  }

  void toggleBlastDirection() {
    gameInstanceWidgetState.toggleBlastDirection();
  }

  String getCurrentGuess() {
    return gameInstanceWidgetState.getCurrentGuess();
  }

  void submitGuess() {
    gameInstanceWidgetState.submitGuess();
  }

  void clearGuess() {
    gameInstanceWidgetState.clearGuess();
  }

  void resetPuzzle() {
    gameInstanceWidgetState.resetPuzzle();
  }
}