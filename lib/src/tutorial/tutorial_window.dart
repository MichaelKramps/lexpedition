import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_state.dart';

class TutorialWindow {
  TutorialWindowType windowType;
  int tileIndex; //when this window is clicked we should progress to a new tutorial step

  TutorialWindow({required this.windowType, this.tileIndex = -1});

  double getTopAlignment() {
    return (tileIndex / 6).floor() * 100 + 80;
  }

  double getLeftAlignment() {
    return (tileIndex % 6) * 100 + 80;
  }

  double getHeight() {
    return Constants().tileSize();
  }

  double getWidth() {
    return Constants().tileSize();
  }

  void handleTap(GameState gameState) {
    gameState.incrementTutorialStep();
  }
}

enum TutorialWindowType { tile, submit, clear, blastDirection }
