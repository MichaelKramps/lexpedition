import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_state.dart';

class TutorialWindow {
  TutorialWindowType windowType;
  int tileIndex;
  String? text;
  TutorialTextPosition? position;
  Constants constants = Constants();

  TutorialWindow(
      {required this.windowType,
      this.tileIndex = -1,
      this.text,
      this.position});

  double getTopAlignment() {
    if (windowType == TutorialWindowType.text) {
      return getTextTopAlignment();
    } else if (windowType == TutorialWindowType.tile) {
      return constants.gridYStart() +
          ((constants.tileSize() + constants.tileMargin() * 2) * getRow());
    } else if (windowType == TutorialWindowType.submit ||
        windowType == TutorialWindowType.clear ||
        windowType == TutorialWindowType.answerBox) {
      return 10;
    }
    return 0;
  }

  double getTextTopAlignment() {
    switch (position) {
      case TutorialTextPosition.topLeft:
      case TutorialTextPosition.topMiddle:
      case TutorialTextPosition.topRight:
        return 10;
      case TutorialTextPosition.middleLeft:
      case TutorialTextPosition.middle:
      case TutorialTextPosition.middleRight:
        return constants.gridYStart() + constants.tileSize();
      case TutorialTextPosition.bottomLeft:
      case TutorialTextPosition.bottomMiddle:
      case TutorialTextPosition.bottomRight:
        return constants.gridYStart() + constants.tileSize() * 3;
      default:
        return 10;
    }
  }

  double getLeftAlignment() {
    if (windowType == TutorialWindowType.text) {
      return getTextLeftAlignment();
    } else if (windowType == TutorialWindowType.tile) {
      return leftAlignmentAtColumn(getColumn());
    } else if (windowType == TutorialWindowType.submit) {
      return leftAlignmentAtColumn(4);
    } else if (windowType == TutorialWindowType.clear) {
      return leftAlignmentAtColumn(5);
    } else if (windowType == TutorialWindowType.blastDirection) {
      return leftAlignmentAtColumn(0);
    } else if (windowType == TutorialWindowType.answerBox) {
      return leftAlignmentAtColumn(1);
    }
    return 0;
  }

  double getTextLeftAlignment() {
    switch (position) {
      case TutorialTextPosition.topLeft:
      case TutorialTextPosition.middle:
      case TutorialTextPosition.bottomLeft:
        return 10;
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
    if (windowType == TutorialWindowType.tile ||
        windowType == TutorialWindowType.blastDirection) {
      return Constants().tileSize();
    } else if (windowType == TutorialWindowType.submit ||
        windowType == TutorialWindowType.clear ||
        windowType == TutorialWindowType.answerBox) {
      return constants.tileSize() - 20;
    }
    return 10;
  }

  double getWidth() {
    if (windowType == TutorialWindowType.tile ||
        windowType == TutorialWindowType.blastDirection) {
      return Constants().tileSize();
    } else if (windowType == TutorialWindowType.submit ||
        windowType == TutorialWindowType.clear) {
      return constants.tileSize() + constants.tileMargin() * 2;
    } else if (windowType == TutorialWindowType.answerBox) {
      return constants.tileSize() * 3 + constants.tileMargin() * 6;
    }
    return 10;
  }

  String getText() {
    if (text != null) {
      return text!;
    } else {
      return 'no text set';
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
    gameState.incrementTutorialStep();
  }
}

enum TutorialWindowType { tile, submit, clear, blastDirection, answerBox, text }

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
