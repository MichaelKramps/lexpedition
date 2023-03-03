import 'package:lexpedition/src/build_puzzle/blank_grid.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/party/party_db_connection.dart';

class GameLevel {
  final int difficulty;
  final int? puzzleId;
  final List<String?> gridCode;
  final List<String?>? gridCodeB;
  late LetterGrid letterGrid;
  late LetterGrid? letterGridB;
  final int? attempts;
  final int? attemptsFinished;
  final double? averageGuesses;
  final PartyDatabaseConnection partyDatabaseConnection =
      PartyDatabaseConnection();

  GameLevel(
      {required this.difficulty,
      required this.gridCode,
      this.gridCodeB,
      this.puzzleId,
      this.attempts,
      this.attemptsFinished,
      this.averageGuesses}) {
    this.letterGrid = new LetterGrid(gridCode, difficulty);
    if (gridCodeB != null) {
      this.letterGridB = new LetterGrid(gridCodeB as List<String?>, difficulty);
    }
  }

  factory GameLevel.blankLevel() {
    return GameLevel(difficulty: 0, gridCode: blankGrid);
  }

  int get number {
    return 10;
  }

  LetterGrid? getMyLetterGrid() {
    if (partyDatabaseConnection.isPartyLeader) {
      return letterGrid;
    } else {
      return letterGridB;
    }
  }

  LetterGrid? getTheirLetterGrid() {
    if (partyDatabaseConnection.isPartyLeader) {
      return letterGridB;
    } else {
      return letterGrid;
    }
  }

  void setMyLetterGrid(LetterGrid newLetterGrid) {
    if (partyDatabaseConnection.isPartyLeader) {
      letterGrid = newLetterGrid;
    } else {
      letterGridB = newLetterGrid;
    }
  }

  void setTheirLetterGrid(LetterGrid newLetterGrid) {
    if (partyDatabaseConnection.isPartyLeader) {
      letterGridB = newLetterGrid;
    } else {
      letterGrid = newLetterGrid;
    }
  }

  bool isBlankLevel() {
    for (String? tileCode in gridCode) {
      if (tileCode != null) {
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
}

class TutorialLevel extends GameLevel {
  String name;

  int number;

  late int difficulty;
  late int? puzzleId;
  late List<String?> gridCode;

  /// The achievement to unlock when the level is finished, if any.
  //final String? achievementIdIOS;

  //final String? achievementIdAndroid;

  //bool get awardsAchievement => achievementIdAndroid != null;

  TutorialLevel(
      {required this.name,
      required this.number,
      required this.difficulty,
      required this.gridCode,
      this.puzzleId})
      : super(difficulty: difficulty, gridCode: gridCode, puzzleId: puzzleId);
}
