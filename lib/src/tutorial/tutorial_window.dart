import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:logging/logging.dart';

class TutorialWindow {
  TutorialWindowType windowType;
  int tileIndex;
  Constants constants = Constants();

  TutorialWindow({required this.windowType, this.tileIndex = -1});

  double getTopAlignment() {
    if (windowType == TutorialWindowType.tile) {
      return constants.gridYStart() +
          ((constants.tileSize() + constants.tileMargin() * 2) * getRow());
    } else if (windowType == TutorialWindowType.submit ||
        windowType == TutorialWindowType.clear) {
      return 10;
    }
    return 0;
  }

  double getLeftAlignment() {
    if (windowType == TutorialWindowType.tile) {
      return leftAlignmentAtColumn(getColumn());
    } else if (windowType == TutorialWindowType.submit) {
      return leftAlignmentAtColumn(4);
    } else if (windowType == TutorialWindowType.clear) {
      return leftAlignmentAtColumn(5);
    } else if (windowType == TutorialWindowType.blastDirection) {
      return leftAlignmentAtColumn(0);
    }
    return 0;
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
        windowType == TutorialWindowType.clear) {
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
    }
    return 10;
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

enum TutorialWindowType { tile, submit, clear, blastDirection, text }
