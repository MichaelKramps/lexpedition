import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_state.dart';

class TutorialWindow {
  TutorialWindowType windowType;
  int tileIndex;
  String? text;
  TutorialTextPosition? position;
  bool ignorePointer;
  bool preventTapAction;
  Constants constants = Constants();

  TutorialWindow(
      {required this.windowType,
      this.tileIndex = -1,
      this.text,
      this.position,
      this.preventTapAction = false,
      this.ignorePointer = true});

  double getTopAlignment() {
    switch (windowType) {
      case TutorialWindowType.text:
        return getTextTopAlignment();
      case TutorialWindowType.tile:
      case TutorialWindowType.tileHighlight:
        return constants.gridYStart() +
            ((constants.tileSize() + constants.tileMargin() * 2) * getRow());
      case TutorialWindowType.letterGrid:
        return constants.gridYStart();
      case TutorialWindowType.submit:
      case TutorialWindowType.clear:
      case TutorialWindowType.answerBox:
        return 10;
      default:
        return 0;
    }
  }

  double getTextTopAlignment() {
    switch (position) {
      case TutorialTextPosition.topLeft:
      case TutorialTextPosition.topMiddle:
      case TutorialTextPosition.topRight:
        return 20;
      case TutorialTextPosition.middleLeft:
      case TutorialTextPosition.middle:
      case TutorialTextPosition.middleRight:
        return constants.gridYStart() + constants.tileSize();
      case TutorialTextPosition.bottomLeft:
      case TutorialTextPosition.bottomMiddle:
      case TutorialTextPosition.bottomRight:
        return constants.gridYStart() +
            constants.tileSize() * 3 +
            constants.tileMargin() * 3;
      default:
        return 10;
    }
  }

  double getLeftAlignment() {
    switch (windowType) {
      case TutorialWindowType.text:
        return getTextLeftAlignment();
      case TutorialWindowType.tile:
      case TutorialWindowType.tileHighlight:
        return leftAlignmentAtColumn(getColumn());
      case TutorialWindowType.submit:
        return leftAlignmentAtColumn(4);
      case TutorialWindowType.clear:
        return leftAlignmentAtColumn(5);
      case TutorialWindowType.blastDirection:
        return leftAlignmentAtColumn(0);
      case TutorialWindowType.answerBox:
        return leftAlignmentAtColumn(1);
      case TutorialWindowType.gameBoard:
      case TutorialWindowType.infoPanel:
      case TutorialWindowType.letterGrid:
        return constants.gridXStart();
      default:
        return 0;
    }
  }

  double getTextLeftAlignment() {
    switch (position) {
      case TutorialTextPosition.topLeft:
      case TutorialTextPosition.middleLeft:
      case TutorialTextPosition.bottomLeft:
        return 30;
      case TutorialTextPosition.topMiddle:
      case TutorialTextPosition.middle:
      case TutorialTextPosition.bottomMiddle:
        return constants.gridXStart();
      case TutorialTextPosition.topRight:
      case TutorialTextPosition.middleRight:
      case TutorialTextPosition.bottomRight:
        return constants.gridXStart() * 2;
      default:
        return 10;
    }
  }

  double leftAlignmentAtColumn(int row) {
    return constants.gridXStart() +
        constants.tileMargin() +
        (constants.tileSize() * row) +
        (constants.tileMargin() * row * 2);
  }

  double getHeight() {
    switch (windowType) {
      case TutorialWindowType.tile:
      case TutorialWindowType.tileHighlight:
      case TutorialWindowType.blastDirection:
        return constants.tileSize();
      case TutorialWindowType.submit:
      case TutorialWindowType.clear:
      case TutorialWindowType.answerBox:
        return constants.tileSize() - 20;
      case TutorialWindowType.gameBoard:
        return constants.screenHeight;
      case TutorialWindowType.infoPanel:
        return constants.tileSize() + (constants.tileMargin() * 2);
      case TutorialWindowType.letterGrid:
        return constants.gridHeight();
      default:
        return 10;
    }
  }

  double getWidth() {
    switch (windowType) {
      case TutorialWindowType.text:
        return constants.tileSize() * 6;
      case TutorialWindowType.tile:
      case TutorialWindowType.tileHighlight:
      case TutorialWindowType.blastDirection:
        return constants.tileSize();
      case TutorialWindowType.submit:
      case TutorialWindowType.clear:
        return constants.tileSize() + constants.tileMargin() * 2;
      case TutorialWindowType.answerBox:
        return constants.tileSize() * 3 + constants.tileMargin() * 6;
      case TutorialWindowType.gameBoard:
      case TutorialWindowType.infoPanel:
      case TutorialWindowType.letterGrid:
        return constants.gridWidth();
      default:
        return 10;
    }
  }

  String getText() {
    if (text != null) {
      return text!;
    } else {
      return 'no text is set';
    }
  }

  int getRow() {
    if (tileIndex > -1) {
      return (tileIndex / 6).floor();
    }
    return 0;
  }

  int getColumn() {
    if (tileIndex > -1) {
      return tileIndex % 6;
    }
    return 0;
  }

  void handleTap(GameState gameState) {
    if (preventTapAction) {
      return;
    }

    switch (windowType) {
      case TutorialWindowType.tile:
      case TutorialWindowType.tileHighlight:
        gameState.clickTileAtIndex(tileIndex, false);
        break;
      case TutorialWindowType.blastDirection:
        gameState.changeBlastDirectionAndNotify();
        break;
      case TutorialWindowType.clear:
        gameState.clearGuessAndNotify();
        break;
      case TutorialWindowType.submit:
        gameState.submitGuess();
        break;
      default:
      //do nothing
    }
    gameState.incrementTutorialStep();
  }
}

enum TutorialWindowType {
  tile,
  submit,
  clear,
  blastDirection,
  answerBox,
  text,
  tileHighlight,
  gameBoard,
  infoPanel,
  letterGrid
}

enum TutorialTextPosition {
  topLeft,
  topMiddle,
  topRight,
  middleLeft,
  middle,
  middleRight,
  bottomLeft,
  bottomMiddle,
  bottomRight
}
