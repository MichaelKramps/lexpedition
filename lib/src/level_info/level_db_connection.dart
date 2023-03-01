import 'package:firebase_database/firebase_database.dart';
import 'package:lexpedition/src/build_puzzle/blank_grid.dart';
import 'package:lexpedition/src/game_data/levels.dart';

class LevelDatabaseConnection {
  static Future<GameLevel> getOnePlayerPuzzle() async {
    GameLevel gameLevel = GameLevel(difficulty: 0, gridCode: blankGrid);

    await FirebaseDatabase.instance
        .ref('onePlayerPuzzles')
        .orderByChild('attempts')
        .startAt(0)
        .limitToFirst(1)
        .once(DatabaseEventType.value)
        .then((value) {
      DataSnapshot puzzleEntry = value.snapshot.children.first;
      String gridString = puzzleEntry.child('gridCode').value as String;
      num par = puzzleEntry.child('averageGuesses').value as num;
      String puzzleIdString = puzzleEntry.key as String;
      gameLevel = GameLevel(
          difficulty: par.toDouble().round(),
          gridCode: gridString.split(','),
          puzzleId: int.parse(puzzleIdString));
    });
    return gameLevel;
  }

  static Future<void> logOnePlayerFinishedPuzzleResults(
      int puzzleId, int guesses) async {
    GameLevel? level =
        await LevelDatabaseConnection.getOnePlayerLevelFromId(puzzleId);

    bool levelCanBeUpdated = level != null &&
        level.attempts != null &&
        level.attemptsFinished != null &&
        level.averageGuesses != null;
    if (levelCanBeUpdated) {
      int oldAttempts = level.attempts != null ? level.attempts as int : 0;
      int oldAttemptsFinished =
          level.attemptsFinished != null ? level.attemptsFinished as int : 0;
      double oldAverageGuesses =
          level.averageGuesses != null ? level.averageGuesses as double : 0;

      int newAttempts = oldAttempts + 1;
      int newAttemptsFinished = oldAttemptsFinished + 1;
      double newAverageGuesses =
          ((oldAttemptsFinished * oldAverageGuesses) + guesses) /
              newAttemptsFinished;

      GameLevel updatedGameLevel = GameLevel(
          difficulty: level.difficulty,
          gridCode: level.gridCode,
          attempts: newAttempts,
          attemptsFinished: newAttemptsFinished,
          averageGuesses: newAverageGuesses);

      LevelDatabaseConnection.setOnePlayerLevelFromId(
          puzzleId, updatedGameLevel);
    }
  }

  static Future<void> logOnePlayerUnfinishedPuzzleResults(
      int puzzleId) async {
    GameLevel? level =
        await LevelDatabaseConnection.getOnePlayerLevelFromId(puzzleId);

    bool levelCanBeUpdated = level != null && level.attempts != null;
    if (levelCanBeUpdated) {
      int oldAttempts = level.attempts != null ? level.attempts as int : 0;
      int newAttempts = oldAttempts + 1;

      GameLevel updatedGameLevel = GameLevel(
          difficulty: level.difficulty,
          gridCode: level.gridCode,
          attempts: newAttempts);

      LevelDatabaseConnection.setOnePlayerLevelFromId(
          puzzleId, updatedGameLevel);
    }
  }

  static Future<GameLevel?> getOnePlayerLevelFromId(int puzzleId) async {
    DataSnapshot snapshot = await FirebaseDatabase.instance
        .ref('onePlayerPuzzles/' + puzzleId.toString())
        .get();

    String gridString = snapshot.child('gridCode').value as String;
    num par = snapshot.child('averageGuesses').value as num;
    int attempts = snapshot.child('attempts').value as int;
    int attemptsFinished = snapshot.child('attemptsFinished').value as int;
    num averageGuesses = snapshot.child('averageGuesses').value as num;

    GameLevel gameLevel = GameLevel(
        difficulty: par.toDouble().round(),
        gridCode: gridString.split(','),
        puzzleId: puzzleId,
        attempts: attempts,
        attemptsFinished: attemptsFinished,
        averageGuesses: averageGuesses.toDouble());

    return gameLevel;
  }

  static Future<void> setOnePlayerLevelFromId(
      int puzzleId, GameLevel gameLevel) async {
    late var updateToMake;

    if (gameLevel.attemptsFinished != null &&
        gameLevel.averageGuesses != null) {
      updateToMake = {
        "attempts": gameLevel.attempts,
        "attemptsFinished": gameLevel.attemptsFinished,
        "averageGuesses": gameLevel.averageGuesses
      };
    } else {
      updateToMake = {"attempts": gameLevel.attempts};
    }

    FirebaseDatabase.instance
        .ref('onePlayerPuzzles/' + puzzleId.toString())
        .update(updateToMake);
  }
}
