import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_state.dart';

class TutorialDirective {
  TutorialDirectiveType windowType;
  int tileIndex;
  String? text;
  TutorialTextPosition? position;
  bool ignorePointer;
  bool preventTapAction;
  Constants constants = Constants();

  TutorialDirective(
      {required this.windowType,
      this.tileIndex = -1,
      this.text,
      this.position,
      this.preventTapAction = false,
      this.ignorePointer = true});

  double getTopAlignment() {
    switch (windowType) {
      case TutorialDirectiveType.text:
        return getTextTopAlignment();
      case TutorialDirectiveType.tile:
      case TutorialDirectiveType.tileHighlight:
        return constants.gridYStart() +
            ((constants.tileSize() + constants.tileMargin() * 2) * getRow());
      case TutorialDirectiveType.letterGrid:
        return constants.gridYStart();
      case TutorialDirectiveType.submit:
      case TutorialDirectiveType.clear:
      case TutorialDirectiveType.answerBox:
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
      case TutorialDirectiveType.text:
        return getTextLeftAlignment();
      case TutorialDirectiveType.tile:
      case TutorialDirectiveType.tileHighlight:
        return leftAlignmentAtColumn(getColumn());
      case TutorialDirectiveType.submit:
        return leftAlignmentAtColumn(4);
      case TutorialDirectiveType.clear:
        return leftAlignmentAtColumn(5);
      case TutorialDirectiveType.blastDirection:
        return leftAlignmentAtColumn(0);
      case TutorialDirectiveType.answerBox:
        return leftAlignmentAtColumn(1);
      case TutorialDirectiveType.gameBoard:
      case TutorialDirectiveType.infoPanel:
      case TutorialDirectiveType.letterGrid:
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
      case TutorialDirectiveType.tile:
      case TutorialDirectiveType.tileHighlight:
      case TutorialDirectiveType.blastDirection:
        return constants.tileSize();
      case TutorialDirectiveType.submit:
      case TutorialDirectiveType.clear:
      case TutorialDirectiveType.answerBox:
        return constants.tileSize() - 20;
      case TutorialDirectiveType.gameBoard:
        return constants.screenHeight;
      case TutorialDirectiveType.infoPanel:
        return constants.tileSize() + (constants.tileMargin() * 2);
      case TutorialDirectiveType.letterGrid:
        return constants.gridHeight();
      default:
        return 10;
    }
  }

  double getWidth() {
    switch (windowType) {
      case TutorialDirectiveType.text:
        return constants.tileSize() * 6;
      case TutorialDirectiveType.tile:
      case TutorialDirectiveType.tileHighlight:
      case TutorialDirectiveType.blastDirection:
        return constants.tileSize();
      case TutorialDirectiveType.submit:
      case TutorialDirectiveType.clear:
        return constants.tileSize() + constants.tileMargin() * 2;
      case TutorialDirectiveType.answerBox:
        return constants.tileSize() * 3 + constants.tileMargin() * 6;
      case TutorialDirectiveType.gameBoard:
      case TutorialDirectiveType.infoPanel:
      case TutorialDirectiveType.letterGrid:
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
      return tileIndex % 4;
    }
    return 0;
  }

  int getColumn() {
    if (tileIndex > -1) {
      return (tileIndex / 4).floor();
    }
    return 0;
  }

  void handleTap(GameState gameState) {
    if (preventTapAction) {
      return;
    }

    switch (windowType) {
      case TutorialDirectiveType.tile:
      case TutorialDirectiveType.tileHighlight:
        gameState.clickTileAtIndex(clickedTileIndex: tileIndex);
        break;
      case TutorialDirectiveType.blastDirection:
        gameState.changeBlastDirectionAndNotify(true);
        break;
      case TutorialDirectiveType.clear:
        gameState.clearGuessAndNotify(true);
        break;
      case TutorialDirectiveType.submit:
        gameState.submitGuess(null, true);
        break;
      default:
      //do nothing
    }
    gameState.incrementTutorialStep();
  }
}

enum TutorialDirectiveType {
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
