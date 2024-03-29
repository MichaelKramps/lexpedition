import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:lexpedition/src/game_data/word_helper.dart';
import 'package:lexpedition/src/game_data/game_column.dart';
import 'package:lexpedition/src/game_widgets/letter_grid_actions_widget.dart';
import 'package:lexpedition/src/game_widgets/letter_grid_widget.dart';
import 'package:lexpedition/src/game_widgets/one_player_left_column_widget.dart';
import 'package:lexpedition/src/game_widgets/one_player_right_column_widget.dart';
import 'package:lexpedition/src/game_widgets/two_player_left_column_widget.dart';
import 'package:lexpedition/src/game_widgets/two_player_right_column_widget.dart';
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
  Random _random = new Random();

  @override
  void initState() {
    super.initState();
    WordHelper.isValidWord('preload');
    Wakelock.enable();
    // following code is causing an error
    // WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
    //   if (!Constants().setFromGameBoard && Constants().gridXStart() != _gridx) {
    //     Constants().setGridXStartFromGameBoard(_gridx);
    //   }
    // });
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Constants.defaultBackground,
      determineAnimationForGameBoard()
    ]);
  }

  Widget determineAnimationForGameBoard() {
    // if (widget.gameState.blasting) {
    //   return getBaseGameBoard()
    //       .animate()
    //       .shake(rotation: 0, offset: determineOffset(), hz: determineHz());
    // } else {
      return getBaseGameBoard();
    //}
  }

  Offset determineOffset() {
    double dx = (_random.nextDouble() * 4) - 2; //between -2 and 2
    double dy = (_random.nextDouble() * 4) - 2; //between -2 and 2
    return Offset(dx, dy);
  }

  double determineHz() {
    return 5 + (_random.nextDouble() * 3); //between 5 and 8
  }

  Widget getBaseGameBoard() {
    return Row(children: [
      Expanded(child: determineColumn(widget.leftColumn)),
      Column(children: [
        LetterGridActionsWidget(gameState: widget.gameState),
        Listener(
            key: gridKey,
            onPointerDown: (event) =>
                {handleMouseEvent(event.position.dx, event.position.dy, false)},
            onPointerMove: (event) =>
                {handleMouseEvent(event.position.dx, event.position.dy, true)},
            child: LetterGridWidget(
                gameState: widget.gameState,
                letterGrid: widget.gameState.getMyGrid()!))
      ]),
      Expanded(child: determineColumn(widget.rightColumn))
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

  void handleMouseEvent(double pointerx, double pointery, bool isSlideEvent) {
    int shrinkClickableSpace = isSlideEvent ? 10 : 0;
    int selectedIndex =
        determineTileIndex(pointerx, pointery, shrinkClickableSpace);

    if (selectedIndex > -1) {
      widget.gameState.clickTileAtIndex(clickedTileIndex: selectedIndex, context: context);
    }
  }

  int determineTileIndex(double pointerx, double pointery, int shrink) {
    if (!Constants().setFromGameBoard) {
      Constants().setGridXStartFromGameBoard(_gridx);
    }
    int xDistance = (pointerx - _gridx).round();
    int yDistance = (pointery - _gridy).round();

    int row = -1;
    int column = -1;

    Constants constants = Constants();
    if (yDistance > (constants.tileOneStart() + shrink) &&
        yDistance < (constants.tileOneEnd() - shrink)) {
      row = 0;
    } else if (yDistance > (constants.tileTwoStart() + shrink) &&
        yDistance < (constants.tileTwoEnd() - shrink)) {
      row = 1;
    } else if (yDistance > (constants.tileThreeStart() + shrink) &&
        yDistance < (constants.tileThreeEnd() - shrink)) {
      row = 2;
    } else if (yDistance > (constants.tileFourStart() + shrink) &&
        yDistance < (constants.tileFourEnd() - shrink)) {
      row = 3;
    }

    if (xDistance > (constants.tileOneStart() + shrink) &&
        xDistance < (constants.tileOneEnd() - shrink)) {
      column = 0;
    } else if (xDistance > (constants.tileTwoStart() + shrink) &&
        xDistance < (constants.tileTwoEnd() - shrink)) {
      column = 1;
    } else if (xDistance > (constants.tileThreeStart() + shrink) &&
        xDistance < (constants.tileThreeEnd() - shrink)) {
      column = 2;
    } else if (xDistance > (constants.tileFourStart() + shrink) &&
        xDistance < (constants.tileFourEnd() - shrink)) {
      column = 3;
    } else if (xDistance > (constants.tileFiveStart() + shrink) &&
        xDistance < (constants.tileFiveEnd() - shrink)) {
      column = 4;
    } else if (xDistance > (constants.tileSixStart() + shrink) &&
        xDistance < (constants.tileSixEnd() - shrink)) {
      column = 5;
    }

    if (row < 0 || column < 0) {
      return -1;
    }

    return (column * 4) + (row);
  }
}
