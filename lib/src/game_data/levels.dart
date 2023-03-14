import 'package:lexpedition/src/build_puzzle/blank_grid.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/game_data/letter_tile.dart';
import 'package:lexpedition/src/party/party_db_connection.dart';
import 'package:logging/logging.dart';

class GameLevel {
  late int difficulty;
  final int? puzzleId;
  final List<String?> gridCode;
  final List<String?>? gridCodeB;
  late LetterGrid letterGrid;
  late LetterGrid? letterGridB;
  final int attempts;
  final int attemptsFinished;
  final int bestAttempt;
  final double averageGuesses;
  final PartyDatabaseConnection partyDatabaseConnection =
      PartyDatabaseConnection();

  GameLevel(
      {required this.difficulty,
      required this.gridCode,
      this.gridCodeB,
      this.puzzleId,
      this.attempts = 0,
      this.attemptsFinished = 0,
      this.averageGuesses = 100,
      this.bestAttempt = 100}) {
    this.letterGrid = new LetterGrid(gridCode, difficulty);
    if (gridCodeB != null) {
      this.letterGridB = new LetterGrid(gridCodeB as List<String?>, difficulty);
    } else {
      this.letterGridB = null;
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
      if (letterGridB != null) {
        letterGridB?.encodedTiles = newLetterGrid.encodedTiles;
        letterGridB?.blastDirection = newLetterGrid.blastDirection;
        letterGridB?.letterTiles = newLetterGrid.letterTiles;
        letterGridB?.rows = newLetterGrid.rows;
        letterGridB?.currentGuess = newLetterGrid.currentGuess;
        letterGridB?.par = newLetterGrid.par;
        letterGridB?.updateGuessesFromLetterGrid(newLetterGrid);
      } else {
        letterGridB = newLetterGrid;
      }
    } else {
      letterGrid.encodedTiles = newLetterGrid.encodedTiles;
      letterGrid.blastDirection = newLetterGrid.blastDirection;
      letterGrid.letterTiles = newLetterGrid.letterTiles;
      letterGrid.rows = newLetterGrid.rows;
      letterGrid.currentGuess = newLetterGrid.currentGuess;
      letterGrid.par = newLetterGrid.par;
      letterGrid.updateGuessesFromLetterGrid(newLetterGrid);
    }
    syncTilesPrimedForBlast();
  }

  void syncTilesPrimedForBlast() {
    if (getTheirLetterGrid() != null && getMyLetterGrid() != null) {
      LetterGrid theirGrid = getTheirLetterGrid() as LetterGrid;
      getMyLetterGrid()?.clearPrimedForBlast();
      getMyLetterGrid()?.attemptToPrimeForBlast();
      for (int index = 0; index < gridCode.length; index++) {
        if (theirGrid.letterTiles[index].primedForBlast) {
          getMyLetterGrid()?.primeForBlastFromIndex(index);
        }
      }
    }
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
