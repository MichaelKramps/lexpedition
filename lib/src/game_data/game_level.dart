import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/game_data/letter_tile.dart';
import 'package:lexpedition/src/tutorial/tutorial_step.dart';

class GameLevel {
  final String? name;
  final int? puzzleId;
  final String? gameLevelCode;
  final List<String?> gridCode;
  final List<String?>? gridCodeB;
  late LetterGrid letterGrid;
  LetterGrid? letterGridB;
  int tutorialKey = 0;
  List<TutorialStep>? tutorialSteps;
  int attempts = 0;
  int attemptsFinished = 0;
  int bestAttempt = 100;
  double averageGuesses = 100;

  GameLevel(
      {required this.gridCode,
      this.gridCodeB,
      this.name,
      this.puzzleId,
      this.gameLevelCode,
      this.tutorialKey = 0,
      this.tutorialSteps,
      this.attempts = 0,
      this.attemptsFinished = 0,
      this.averageGuesses = 100,
      this.bestAttempt = 100}) {
    this.letterGrid = new LetterGrid(gridCode);
    if (gridCodeB != null) {
      this.letterGridB = new LetterGrid(gridCodeB as List<String?>);
    } else {
      this.letterGridB = null;
    }
  }

  factory GameLevel.fromPeer(String levelText) {
    //decoding string from rtcEncode in this class
    List<String> splitLevelText =
        levelText.split(Constants.rtcLoadLevelDataSplitter);

    return GameLevel(
        gridCode: splitLevelText[0].split(','),
        gridCodeB:
            splitLevelText[1] == 'null' ? null : splitLevelText[1].split(','),
        averageGuesses: double.parse(splitLevelText[2]),
        bestAttempt: int.parse(splitLevelText[3]));
  }

  factory GameLevel.copy(GameLevel levelToCopy) {
    return GameLevel(
        gridCode: levelToCopy.gridCode,
        gridCodeB: levelToCopy.gridCodeB,
        name: levelToCopy.name,
        puzzleId: levelToCopy.puzzleId,
        tutorialKey: levelToCopy.tutorialKey,
        tutorialSteps: levelToCopy.tutorialSteps,
        attempts: levelToCopy.attempts,
        attemptsFinished: levelToCopy.attemptsFinished,
        averageGuesses: levelToCopy.averageGuesses,
        bestAttempt: levelToCopy.bestAttempt);
  }

  bool isBlankLevel() {
    for (LetterTile letterTile in letterGrid.letterTiles) {
      if (letterTile.tileType != TileType.empty) {
        return false;
      }
    }
    return true;
  }

  bool levelFullyCharged() {
    if (isBlankLevel()) {
      return false;
    } else if (letterGridB != null) {
      LetterGrid gridB = letterGridB as LetterGrid;
      return letterGrid.isFullyCharged() && gridB.isFullyCharged();
    } else {
      return letterGrid.isFullyCharged();
    }
  }

  String getName() {
    if (name == null) {
      return "Secret Level";
    } else {
      return name as String;
    }
  }

  String rtcEncode() {
    String encodedLevel = '';

    encodedLevel += gridCode.join(',');
    encodedLevel += Constants.rtcLoadLevelDataSplitter;
    encodedLevel += gridCodeB == null ? 'null' : gridCodeB!.join(',');
    encodedLevel += Constants.rtcLoadLevelDataSplitter;
    encodedLevel += averageGuesses.toString();
    encodedLevel += Constants.rtcLoadLevelDataSplitter;
    encodedLevel += bestAttempt.toString();

    return encodedLevel;
  }
}
