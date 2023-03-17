import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/game_data/word_helper.dart';
import 'package:lexpedition/src/game_data/game_column.dart';
import 'package:lexpedition/src/game_widgets/letter_grid_actions_widget.dart';
import 'package:lexpedition/src/game_widgets/letter_grid_widget.dart';
import 'package:lexpedition/src/game_widgets/one_player_left_column_widget.dart';
import 'package:lexpedition/src/game_widgets/one_player_right_column_widget.dart';
import 'package:lexpedition/src/game_widgets/two_player_left_column_widget.dart';
import 'package:lexpedition/src/game_widgets/two_player_right_column_widget.dart';
import 'package:logging/logging.dart';
import 'package:wakelock/wakelock.dart';

class GameInstanceWidget extends StatefulWidget {
  final GameState gameState;
  final GameColumn leftColumn;
  final GameColumn rightColumn;

  GameInstanceWidget(
      {super.key,
      required this.gameState,
      required this.leftColumn,
      required this.rightColumn});

  @override
  State<GameInstanceWidget> createState() => _GameInstanceWidgetState();
}

class _GameInstanceWidgetState extends State<GameInstanceWidget> {
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
    return Stack(children: [
      Container(
          decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(Constants.backgroundImagePath),
            fit: BoxFit.cover),
      )),
      Row(children: [
        Expanded(child: determineColumn(widget.leftColumn)),
        Column(children: [
          LetterGridActionsWidget(gameState: widget.gameState),
          Listener(
              key: gridKey,
              onPointerDown: (event) => {
                    handleMouseEvent(
                        event.position.dx, event.position.dy, false)
                  },
              onPointerMove: (event) => {
                    handleMouseEvent(event.position.dx, event.position.dy, true)
                  },
              child: LetterGridWidget(letterGrid: widget.gameState.getMyGrid() as LetterGrid))
        ]),
        Expanded(child: determineColumn(widget.rightColumn))
      ])
    ]);
  }

  Widget determineColumn(GameColumn gameColumn) {
    switch (gameColumn) {
      case GameColumn.onePlayerRightColumn:
        return OnePlayerRightColumnWidget(gameState: widget.gameState);
      case GameColumn.onePlayerLeftColumn:
        return OnePlayerLeftColumnWidget(gameState: widget.gameState);
      case GameColumn.twoPlayerRightColumn:
        return TwoPlayerRightColumnWidget(gameState: widget.gameState);
      case GameColumn.twoPlayerLeftColumn:
        return TwoPlayerLeftColumnWidget(gameState: widget.gameState);
      default:
        return Container();
    }
  }

  bool isLevelWon(
      LetterGrid primaryLetterGrid, LetterGrid? secondaryLetterGrid) {
    if (secondaryLetterGrid == null) {
      return primaryLetterGrid.isFullyCharged();
    } else {
      return primaryLetterGrid.isFullyCharged() &&
          secondaryLetterGrid.isFullyCharged();
    }
  }

  void handleMouseEvent(double pointerx, double pointery, bool isSlideEvent) {
    new Logger('game instance widget').info('handling mouse event');
    int shrinkClickableSpace = isSlideEvent ? 10 : 0;
    int selectedIndex =
        determineTileIndex(pointerx, pointery, shrinkClickableSpace);

    if (selectedIndex > -1) {
      widget.gameState.clickTileAtIndex(selectedIndex, isSlideEvent);
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
}
