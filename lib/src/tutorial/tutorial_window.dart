import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_state.dart';

class TutorialWindow {
  TutorialWindowType windowType;
  int tileIndex; //when this window is clicked we should progress to a new tutorial step
  Constants constants = Constants();

  TutorialWindow({required this.windowType, this.tileIndex = -1});

  double getTopAlignment() {
    return constants.gridYStart() + ((constants.tileSize() + constants.tileMargin()) * getRow());
  }

  double getLeftAlignment() {
    return constants.gridXStart() + ((constants.tileSize() + constants.tileMargin()) * getColumn());
  }

  double getHeight() {
    return Constants().tileSize();
  }

  double getWidth() {
    return Constants().tileSize();
  }

  int getRow() {
    return (tileIndex / 6).floor();
  }

  int getColumn() {
    return tileIndex % 6;
  }

  void handleTap(GameState gameState) {
    gameState.incrementTutorialStep();
  }
}

enum TutorialWindowType { tile, submit, clear, blastDirection }
