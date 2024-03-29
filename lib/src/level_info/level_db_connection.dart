import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:lexpedition/src/game_data/game_level.dart';

class LevelDatabaseConnection {
  static Future<GameLevel?> getOnePlayerPuzzle() async {
    GameLevel? possibleGameLevel = null;

    int puzzleType = new Random().nextInt(4);
    try {
      switch (puzzleType) {
        case 0:
          possibleGameLevel =
              await LevelDatabaseConnection.getNewOnePlayerPuzzle();
          break;
        case 1:
          possibleGameLevel =
              await LevelDatabaseConnection.getOnePlayerPuzzleInGuessRange(
                  0, 7);
          break;
        case 2:
          possibleGameLevel =
              await LevelDatabaseConnection.getOnePlayerPuzzleInGuessRange(
                  5, 10);
          break;
        case 3:
          possibleGameLevel =
              await LevelDatabaseConnection.getOnePlayerPuzzleInGuessRange(
                  10, 1000);
          break;
        default:
          possibleGameLevel =
              await LevelDatabaseConnection.getNewOnePlayerPuzzle();
          break;
      }

      if (possibleGameLevel != null) {
        return possibleGameLevel;
      } else {
        return LevelDatabaseConnection.getOnePlayerPuzzle();
      }
    } catch (error) {
      return possibleGameLevel;
    }
  }

  static Future<GameLevel?> getTwoPlayerPuzzle() async {
    GameLevel? possibleGameLevel = null;

    int puzzleType = new Random().nextInt(4);
    try {
      switch (puzzleType) {
        case 0:
          possibleGameLevel =
              await LevelDatabaseConnection.getNewTwoPlayerPuzzle();
          break;
        case 1:
          possibleGameLevel =
              await LevelDatabaseConnection.getTwoPlayerPuzzleInGuessRange(
                  0, 10);
          break;
        case 2:
          possibleGameLevel =
              await LevelDatabaseConnection.getTwoPlayerPuzzleInGuessRange(
                  8, 15);
          break;
        case 3:
          possibleGameLevel =
              await LevelDatabaseConnection.getTwoPlayerPuzzleInGuessRange(
                  15, 1000);
          break;
        default:
          possibleGameLevel =
              await LevelDatabaseConnection.getNewTwoPlayerPuzzle();
          break;
      }

      if (possibleGameLevel != null) {
        return possibleGameLevel;
      } else {
        return LevelDatabaseConnection.getTwoPlayerPuzzle();
      }
    } catch (error) {
      return possibleGameLevel;
    }
  }

  static Future<GameLevel?> getOnePlayerLexpedition() async {
    GameLevel? possibleGameLevel = null;

    int puzzleType = new Random().nextInt(4);
    try {
      switch (puzzleType) {
        case 0:
          possibleGameLevel =
              await LevelDatabaseConnection.getNewOnePlayerLexpedition();
          break;
        case 1:
          possibleGameLevel =
              await LevelDatabaseConnection.getOnePlayerLexpeditionInGuessRange(
                  0, 7);
          break;
        case 2:
          possibleGameLevel =
              await LevelDatabaseConnection.getOnePlayerLexpeditionInGuessRange(
                  5, 10);
          break;
        case 3:
          possibleGameLevel =
              await LevelDatabaseConnection.getOnePlayerLexpeditionInGuessRange(
                  10, 1000);
          break;
        default:
          possibleGameLevel =
              await LevelDatabaseConnection.getNewOnePlayerLexpedition();
          break;
      }

      if (possibleGameLevel != null) {
        return possibleGameLevel;
      } else {
        return LevelDatabaseConnection.getOnePlayerLexpedition();
      }
    } catch (error) {
      return possibleGameLevel;
    }
  }

  static Future<GameLevel?> getTwoPlayerLexpedition() async {
    GameLevel? possibleGameLevel = null;

    int puzzleType = new Random().nextInt(4);
    try {
      switch (puzzleType) {
        case 0:
          possibleGameLevel =
              await LevelDatabaseConnection.getNewTwoPlayerLexpedition();
          break;
        case 1:
          possibleGameLevel =
              await LevelDatabaseConnection.getTwoPlayerLexpeditionInGuessRange(
                  0, 10);
          break;
        case 2:
          possibleGameLevel =
              await LevelDatabaseConnection.getTwoPlayerLexpeditionInGuessRange(
                  8, 15);
          break;
        case 3:
          possibleGameLevel =
              await LevelDatabaseConnection.getTwoPlayerLexpeditionInGuessRange(
                  15, 1000);
          break;
        default:
          possibleGameLevel =
              await LevelDatabaseConnection.getNewTwoPlayerLexpedition();
          break;
      }

      if (possibleGameLevel != null) {
        return possibleGameLevel;
      } else {
        return LevelDatabaseConnection.getTwoPlayerLexpedition();
      }
    } catch (error) {
      return possibleGameLevel;
    }
  }

  static Future<GameLevel?> getNewOnePlayerPuzzle() async {
    GameLevel? gameLevel = null;
    int numberToFetch = 10;

    await FirebaseDatabase.instance
        .ref('onePlayerPuzzles')
        .orderByChild('attempts')
        .startAt(0)
        .limitToFirst(numberToFetch)
        .once(DatabaseEventType.value)
        .then((value) {
      if (value.snapshot.children.length > 0) {
        DataSnapshot puzzleEntry = value.snapshot.children
            .elementAt(new Random().nextInt(value.snapshot.children.length));
        String gridString = puzzleEntry.child('gridCode').value as String;
        num par = puzzleEntry.child('averageGuesses').value as num;
        int best = puzzleEntry.child('bestAttempt').value as int;
        String puzzleIdString = puzzleEntry.key as String;
        gameLevel = GameLevel(
            averageGuesses: par.toDouble(),
            gridCode: gridString.split(','),
            puzzleId: int.parse(puzzleIdString),
            gameLevelCode: '1' + int.parse(puzzleIdString).toString(),
            bestAttempt: best);
      }
    });
    return gameLevel;
  }

  static Future<GameLevel?> getNewTwoPlayerPuzzle() async {
    GameLevel? gameLevel = null;
    int numberToFetch = 10;

    await FirebaseDatabase.instance
        .ref('twoPlayerPuzzles')
        .orderByChild('attempts')
        .startAt(0)
        .limitToFirst(numberToFetch)
        .once(DatabaseEventType.value)
        .then((value) {
      if (value.snapshot.children.length > 0) {
        DataSnapshot puzzleEntry = value.snapshot.children
            .elementAt(new Random().nextInt(value.snapshot.children.length));
        String gridStringA = puzzleEntry.child('gridCodeA').value as String;
        String gridStringB = puzzleEntry.child('gridCodeB').value as String;
        num par = puzzleEntry.child('averageGuesses').value as num;
        int best = puzzleEntry.child('bestAttempt').value as int;
        String puzzleIdString = puzzleEntry.key as String;
        gameLevel = GameLevel(
            averageGuesses: par.toDouble(),
            gridCode: gridStringA.split(','),
            gridCodeB: gridStringB.split(','),
            puzzleId: int.parse(puzzleIdString),
            gameLevelCode: '2' + int.parse(puzzleIdString).toString(),
            bestAttempt: best);
      }
    });
    return gameLevel;
  }

  static Future<GameLevel?> getNewOnePlayerLexpedition() async {
    GameLevel? gameLevel = null;
    int numberToFetch = 10;

    await FirebaseDatabase.instance
        .ref('onePlayerLexpeditions')
        .orderByChild('attempts')
        .startAt(0)
        .limitToFirst(numberToFetch)
        .once(DatabaseEventType.value)
        .then((value) {
      if (value.snapshot.children.length > 0) {
        DataSnapshot puzzleEntry = value.snapshot.children
            .elementAt(new Random().nextInt(value.snapshot.children.length));
        String gridString = puzzleEntry.child('gridCode').value as String;
        num par = puzzleEntry.child('averageGuesses').value as num;
        int best = puzzleEntry.child('bestAttempt').value as int;
        String puzzleIdString = puzzleEntry.key as String;
        gameLevel = GameLevel(
            averageGuesses: par.toDouble(),
            gridCode: gridString.split(','),
            puzzleId: int.parse(puzzleIdString),
            gameLevelCode: '3' + int.parse(puzzleIdString).toString(),
            bestAttempt: best);
      }
    });
    return gameLevel;
  }

  static Future<GameLevel?> getNewTwoPlayerLexpedition() async {
    GameLevel? gameLevel = null;
    int numberToFetch = 10;

    await FirebaseDatabase.instance
        .ref('twoPlayerLexpeditions')
        .orderByChild('attempts')
        .startAt(0)
        .limitToFirst(numberToFetch)
        .once(DatabaseEventType.value)
        .then((value) {
      if (value.snapshot.children.length > 0) {
        DataSnapshot puzzleEntry = value.snapshot.children
            .elementAt(new Random().nextInt(value.snapshot.children.length));
        String gridStringA = puzzleEntry.child('gridCodeA').value as String;
        String gridStringB = puzzleEntry.child('gridCodeB').value as String;
        num par = puzzleEntry.child('averageGuesses').value as num;
        int best = puzzleEntry.child('bestAttempt').value as int;
        String puzzleIdString = puzzleEntry.key as String;
        gameLevel = GameLevel(
            averageGuesses: par.toDouble(),
            gridCode: gridStringA.split(','),
            gridCodeB: gridStringB.split(','),
            puzzleId: int.parse(puzzleIdString),
            gameLevelCode: '4' + int.parse(puzzleIdString).toString(),
            bestAttempt: best);
      }
    });
    return gameLevel;
  }

  static Future<GameLevel?> getOnePlayerPuzzleInGuessRange(
      int bottomRange, int topRange) async {
    GameLevel? gameLevel = null;
    int numberToFetch = 10;

    await FirebaseDatabase.instance
        .ref('onePlayerPuzzles')
        .orderByChild('averageGuesses')
        .startAt(bottomRange)
        .endAt(topRange)
        .limitToFirst(numberToFetch)
        .once(DatabaseEventType.value)
        .then((value) {
      if (value.snapshot.children.length > 0) {
        DataSnapshot puzzleEntry = value.snapshot.children
            .elementAt(new Random().nextInt(value.snapshot.children.length));
        String gridString = puzzleEntry.child('gridCode').value as String;
        num par = puzzleEntry.child('averageGuesses').value as num;
        int best = puzzleEntry.child('bestAttempt').value as int;
        String puzzleIdString = puzzleEntry.key as String;
        gameLevel = GameLevel(
            averageGuesses: par.toDouble(),
            gridCode: gridString.split(','),
            puzzleId: int.parse(puzzleIdString),
            gameLevelCode: '1' + int.parse(puzzleIdString).toString(),
            bestAttempt: best);
      }
    });
    return gameLevel;
  }

  static Future<GameLevel?> getTwoPlayerPuzzleInGuessRange(
      int bottomRange, int topRange) async {
    GameLevel? gameLevel = null;
    int numberToFetch = 10;

    await FirebaseDatabase.instance
        .ref('twoPlayerPuzzles')
        .orderByChild('averageGuesses')
        .startAt(bottomRange)
        .endAt(topRange)
        .limitToFirst(numberToFetch)
        .once(DatabaseEventType.value)
        .then((value) {
      if (value.snapshot.children.length > 0) {
        DataSnapshot puzzleEntry = value.snapshot.children
            .elementAt(new Random().nextInt(value.snapshot.children.length));
        String gridStringA = puzzleEntry.child('gridCodeA').value as String;
        String gridStringB = puzzleEntry.child('gridCodeB').value as String;
        num par = puzzleEntry.child('averageGuesses').value as num;
        int best = puzzleEntry.child('bestAttempt').value as int;
        String puzzleIdString = puzzleEntry.key as String;
        gameLevel = GameLevel(
            averageGuesses: par.toDouble(),
            gridCode: gridStringA.split(','),
            gridCodeB: gridStringB.split(','),
            puzzleId: int.parse(puzzleIdString),
            gameLevelCode: '2' + int.parse(puzzleIdString).toString(),
            bestAttempt: best);
      }
    });
    return gameLevel;
  }

  static Future<GameLevel?> getOnePlayerLexpeditionInGuessRange(
      int bottomRange, int topRange) async {
    GameLevel? gameLevel = null;
    int numberToFetch = 10;

    await FirebaseDatabase.instance
        .ref('onePlayerLexpeditions')
        .orderByChild('averageGuesses')
        .startAt(bottomRange)
        .endAt(topRange)
        .limitToFirst(numberToFetch)
        .once(DatabaseEventType.value)
        .then((value) {
      if (value.snapshot.children.length > 0) {
        DataSnapshot puzzleEntry = value.snapshot.children
            .elementAt(new Random().nextInt(value.snapshot.children.length));
        String gridString = puzzleEntry.child('gridCode').value as String;
        num par = puzzleEntry.child('averageGuesses').value as num;
        int best = puzzleEntry.child('bestAttempt').value as int;
        String puzzleIdString = puzzleEntry.key as String;
        gameLevel = GameLevel(
            averageGuesses: par.toDouble(),
            gridCode: gridString.split(','),
            puzzleId: int.parse(puzzleIdString),
            gameLevelCode: '3' + int.parse(puzzleIdString).toString(),
            bestAttempt: best);
      }
    });
    return gameLevel;
  }

  static Future<GameLevel?> getTwoPlayerLexpeditionInGuessRange(
      int bottomRange, int topRange) async {
    GameLevel? gameLevel = null;
    int numberToFetch = 10;

    await FirebaseDatabase.instance
        .ref('twoPlayerLexpeditions')
        .orderByChild('averageGuesses')
        .startAt(bottomRange)
        .endAt(topRange)
        .limitToFirst(numberToFetch)
        .once(DatabaseEventType.value)
        .then((value) {
      if (value.snapshot.children.length > 0) {
        DataSnapshot puzzleEntry = value.snapshot.children
            .elementAt(new Random().nextInt(value.snapshot.children.length));
        String gridStringA = puzzleEntry.child('gridCodeA').value as String;
        String gridStringB = puzzleEntry.child('gridCodeB').value as String;
        num par = puzzleEntry.child('averageGuesses').value as num;
        int best = puzzleEntry.child('bestAttempt').value as int;
        String puzzleIdString = puzzleEntry.key as String;
        gameLevel = GameLevel(
            averageGuesses: par.toDouble(),
            gridCode: gridStringA.split(','),
            gridCodeB: gridStringB.split(','),
            puzzleId: int.parse(puzzleIdString),
            gameLevelCode: '4' + int.parse(puzzleIdString).toString(),
            bestAttempt: best);
      }
    });
    return gameLevel;
  }

  static Future<void> logOnePlayerFinishedPuzzleResults(
      int puzzleId, int guesses) async {
    GameLevel? level =
        await LevelDatabaseConnection.getOnePlayerLevelFromId(puzzleId);

    bool levelCanBeUpdated = level != null;
    if (levelCanBeUpdated) {
      int newBestAttempt =
          guesses < level.bestAttempt ? guesses : level.bestAttempt;

      int newAttempts = level.attempts + 1;
      int newAttemptsFinished = level.attemptsFinished + 1;
      double newAverageGuesses =
          ((level.attemptsFinished * level.averageGuesses) + guesses) /
              newAttemptsFinished;

      GameLevel updatedGameLevel = GameLevel(
          gridCode: level.gridCode,
          attempts: newAttempts,
          attemptsFinished: newAttemptsFinished,
          averageGuesses: newAverageGuesses,
          bestAttempt: newBestAttempt);

      LevelDatabaseConnection.setOnePlayerLevelFromId(
          puzzleId, updatedGameLevel);
    }
  }

  static Future<void> logOnePlayerFinishedLexpeditionResults(
      int puzzleId, int guesses) async {
    GameLevel? level =
        await LevelDatabaseConnection.getOnePlayerLexpeditionFromId(puzzleId);

    bool levelCanBeUpdated = level != null;
    if (levelCanBeUpdated) {
      int newBestAttempt =
          guesses < level.bestAttempt ? guesses : level.bestAttempt;

      int newAttempts = level.attempts + 1;
      int newAttemptsFinished = level.attemptsFinished + 1;
      double newAverageGuesses =
          ((level.attemptsFinished * level.averageGuesses) + guesses) /
              newAttemptsFinished;

      GameLevel updatedGameLevel = GameLevel(
          gridCode: level.gridCode,
          attempts: newAttempts,
          attemptsFinished: newAttemptsFinished,
          averageGuesses: newAverageGuesses,
          bestAttempt: newBestAttempt);

      LevelDatabaseConnection.setOnePlayerLexpeditionFromId(
          puzzleId, updatedGameLevel);
    }
  }

  static Future<void> logTwoPlayerFinishedPuzzleResults(
      int puzzleId, int guesses) async {
    GameLevel? level =
        await LevelDatabaseConnection.getTwoPlayerLevelFromId(puzzleId);

    bool levelCanBeUpdated = level != null;
    if (levelCanBeUpdated) {
      int newBestAttempt =
          guesses < level.bestAttempt ? guesses : level.bestAttempt;

      int newAttempts = level.attempts + 1;
      int newAttemptsFinished = level.attemptsFinished + 1;
      double newAverageGuesses =
          ((level.attemptsFinished * level.averageGuesses) + guesses) /
              newAttemptsFinished;

      GameLevel updatedGameLevel = GameLevel(
          gridCode: level.gridCode,
          attempts: newAttempts,
          attemptsFinished: newAttemptsFinished,
          averageGuesses: newAverageGuesses,
          bestAttempt: newBestAttempt);

      LevelDatabaseConnection.setTwoPlayerLevelFromId(
          puzzleId, updatedGameLevel);
    }
  }

  static Future<void> logTwoPlayerFinishedLexpeditionResults(
      int puzzleId, int guesses) async {
    GameLevel? level =
        await LevelDatabaseConnection.getTwoPlayerLexpeditionFromId(puzzleId);

    bool levelCanBeUpdated = level != null;
    if (levelCanBeUpdated) {
      int newBestAttempt =
          guesses < level.bestAttempt ? guesses : level.bestAttempt;

      int newAttempts = level.attempts + 1;
      int newAttemptsFinished = level.attemptsFinished + 1;
      double newAverageGuesses =
          ((level.attemptsFinished * level.averageGuesses) + guesses) /
              newAttemptsFinished;

      GameLevel updatedGameLevel = GameLevel(
          gridCode: level.gridCode,
          attempts: newAttempts,
          attemptsFinished: newAttemptsFinished,
          averageGuesses: newAverageGuesses,
          bestAttempt: newBestAttempt);

      LevelDatabaseConnection.setTwoPlayerLexpeditionFromId(
          puzzleId, updatedGameLevel);
    }
  }

  static Future<void> logOnePlayerUnfinishedPuzzleResults(int puzzleId) async {
    GameLevel? level =
        await LevelDatabaseConnection.getOnePlayerLevelFromId(puzzleId);

    bool levelCanBeUpdated = level != null;
    if (levelCanBeUpdated) {
      int newAttempts = level.attempts + 1;

      GameLevel updatedGameLevel =
          GameLevel(gridCode: level.gridCode, attempts: newAttempts);

      LevelDatabaseConnection.setOnePlayerLevelFromId(
          puzzleId, updatedGameLevel);
    }
  }

  static Future<void> logOnePlayerUnfinishedLexpeditionResults(
      int puzzleId) async {
    GameLevel? level =
        await LevelDatabaseConnection.getOnePlayerLexpeditionFromId(puzzleId);

    bool levelCanBeUpdated = level != null;
    if (levelCanBeUpdated) {
      int newAttempts = level.attempts + 1;

      GameLevel updatedGameLevel =
          GameLevel(gridCode: level.gridCode, attempts: newAttempts);

      LevelDatabaseConnection.setOnePlayerLexpeditionFromId(
          puzzleId, updatedGameLevel);
    }
  }

  static Future<void> logTwoPlayerUnfinishedPuzzleResults(int puzzleId) async {
    GameLevel? level =
        await LevelDatabaseConnection.getTwoPlayerLevelFromId(puzzleId);

    bool levelCanBeUpdated = level != null;
    if (levelCanBeUpdated) {
      int newAttempts = level.attempts + 1;

      GameLevel updatedGameLevel =
          GameLevel(gridCode: level.gridCode, attempts: newAttempts);

      LevelDatabaseConnection.setTwoPlayerLevelFromId(
          puzzleId, updatedGameLevel);
    }
  }

  static Future<void> logTwoPlayerUnfinishedLexpeditionResults(
      int puzzleId) async {
    GameLevel? level =
        await LevelDatabaseConnection.getTwoPlayerLexpeditionFromId(puzzleId);

    bool levelCanBeUpdated = level != null;
    if (levelCanBeUpdated) {
      int newAttempts = level.attempts + 1;

      GameLevel updatedGameLevel =
          GameLevel(gridCode: level.gridCode, attempts: newAttempts);

      LevelDatabaseConnection.setTwoPlayerLexpeditionFromId(
          puzzleId, updatedGameLevel);
    }
  }

  static Future<GameLevel?> lookUpLevelFromCode(String lookupCode) async {
    if (lookupCode[0] == "1") {
      return await getOnePlayerLevelFromId(int.parse(lookupCode.substring(1)));
    } else {
      return await getTwoPlayerLevelFromId(int.parse(lookupCode.substring(1)));
    }
  }

  static Future<GameLevel?> getOnePlayerLevelFromId(int puzzleId) async {
    DataSnapshot snapshot = await FirebaseDatabase.instance
        .ref('onePlayerPuzzles/' + puzzleId.toString())
        .get();

    String gridString = snapshot.child('gridCode').value as String;
    int attempts = snapshot.child('attempts').value as int;
    int attemptsFinished = snapshot.child('attemptsFinished').value as int;
    int bestAttempt = snapshot.child('bestAttempt').value as int;
    num averageGuesses = snapshot.child('averageGuesses').value as num;

    GameLevel gameLevel = GameLevel(
        gridCode: gridString.split(','),
        puzzleId: puzzleId,
        gameLevelCode: '1' + puzzleId.toString(),
        attempts: attempts,
        bestAttempt: bestAttempt,
        attemptsFinished: attemptsFinished,
        averageGuesses: averageGuesses.toDouble());

    return gameLevel;
  }

  static Future<GameLevel?> getOnePlayerLexpeditionFromId(int puzzleId) async {
    DataSnapshot snapshot = await FirebaseDatabase.instance
        .ref('onePlayerLexpeditions/' + puzzleId.toString())
        .get();

    String gridString = snapshot.child('gridCode').value as String;
    int attempts = snapshot.child('attempts').value as int;
    int attemptsFinished = snapshot.child('attemptsFinished').value as int;
    int bestAttempt = snapshot.child('bestAttempt').value as int;
    num averageGuesses = snapshot.child('averageGuesses').value as num;

    GameLevel gameLevel = GameLevel(
        gridCode: gridString.split(','),
        puzzleId: puzzleId,
        gameLevelCode: '1' + puzzleId.toString(),
        attempts: attempts,
        bestAttempt: bestAttempt,
        attemptsFinished: attemptsFinished,
        averageGuesses: averageGuesses.toDouble());

    return gameLevel;
  }

  static Future<GameLevel?> getTwoPlayerLevelFromId(int puzzleId) async {
    DataSnapshot snapshot = await FirebaseDatabase.instance
        .ref('twoPlayerPuzzles/' + puzzleId.toString())
        .get();

    String gridStringA = snapshot.child('gridCodeA').value as String;
    String gridStringB = snapshot.child('gridCodeB').value as String;
    int attempts = snapshot.child('attempts').value as int;
    int attemptsFinished = snapshot.child('attemptsFinished').value as int;
    int bestAttempt = snapshot.child('bestAttempt').value as int;
    num averageGuesses = snapshot.child('averageGuesses').value as num;

    GameLevel gameLevel = GameLevel(
        gridCode: gridStringA.split(','),
        gridCodeB: gridStringB.split(','),
        puzzleId: puzzleId,
        gameLevelCode: '2' + puzzleId.toString(),
        attempts: attempts,
        attemptsFinished: attemptsFinished,
        bestAttempt: bestAttempt,
        averageGuesses: averageGuesses.toDouble());

    return gameLevel;
  }

  static Future<GameLevel?> getTwoPlayerLexpeditionFromId(int puzzleId) async {
    DataSnapshot snapshot = await FirebaseDatabase.instance
        .ref('twoPlayerLexpeditions/' + puzzleId.toString())
        .get();

    String gridStringA = snapshot.child('gridCodeA').value as String;
    String gridStringB = snapshot.child('gridCodeB').value as String;
    int attempts = snapshot.child('attempts').value as int;
    int attemptsFinished = snapshot.child('attemptsFinished').value as int;
    int bestAttempt = snapshot.child('bestAttempt').value as int;
    num averageGuesses = snapshot.child('averageGuesses').value as num;

    GameLevel gameLevel = GameLevel(
        gridCode: gridStringA.split(','),
        gridCodeB: gridStringB.split(','),
        puzzleId: puzzleId,
        gameLevelCode: '2' + puzzleId.toString(),
        attempts: attempts,
        attemptsFinished: attemptsFinished,
        bestAttempt: bestAttempt,
        averageGuesses: averageGuesses.toDouble());

    return gameLevel;
  }

  static Future<void> setOnePlayerLevelFromId(
      int puzzleId, GameLevel gameLevel) async {
    late var updateToMake;

    updateToMake = {
      "attempts": gameLevel.attempts,
      "attemptsFinished": gameLevel.attemptsFinished,
      "averageGuesses": gameLevel.averageGuesses,
      "bestAttempt": gameLevel.bestAttempt
    };

    FirebaseDatabase.instance
        .ref('onePlayerPuzzles/' + puzzleId.toString())
        .update(updateToMake);
  }

  static Future<void> setOnePlayerLexpeditionFromId(
      int puzzleId, GameLevel gameLevel) async {
    late var updateToMake;

    updateToMake = {
      "attempts": gameLevel.attempts,
      "attemptsFinished": gameLevel.attemptsFinished,
      "averageGuesses": gameLevel.averageGuesses,
      "bestAttempt": gameLevel.bestAttempt
    };

    FirebaseDatabase.instance
        .ref('onePlayerLexpeditions/' + puzzleId.toString())
        .update(updateToMake);
  }

  static Future<void> setTwoPlayerLevelFromId(
      int puzzleId, GameLevel gameLevel) async {
    late var updateToMake;

    updateToMake = {
      "attempts": gameLevel.attempts,
      "attemptsFinished": gameLevel.attemptsFinished,
      "averageGuesses": gameLevel.averageGuesses,
      "bestAttempt": gameLevel.bestAttempt
    };

    FirebaseDatabase.instance
        .ref('twoPlayerPuzzles/' + puzzleId.toString())
        .update(updateToMake);
  }

  static Future<void> setTwoPlayerLexpeditionFromId(
      int puzzleId, GameLevel gameLevel) async {
    late var updateToMake;

    updateToMake = {
      "attempts": gameLevel.attempts,
      "attemptsFinished": gameLevel.attemptsFinished,
      "averageGuesses": gameLevel.averageGuesses,
      "bestAttempt": gameLevel.bestAttempt
    };

    FirebaseDatabase.instance
        .ref('twoPlayerLexpeditions/' + puzzleId.toString())
        .update(updateToMake);
  }

  static Future<void> createOnePlayerLevel(
      String encodedGridString, String author) async {
    int nextLevelId = await getNextOnePlayerLevelId();

    if (nextLevelId > 0) {
      FirebaseDatabase.instance
          .ref('onePlayerPuzzles/' + nextLevelId.toString())
          .set({
        'attempts': 0,
        'attemptsFinished': 0,
        'author': author,
        'averageGuesses': 0,
        'bestAttempt': 100,
        'gridCode': encodedGridString
      });
    }
  }

  static Future<void> createOnePlayerLexpeditionLevel(
      String encodedGridString, String author) async {
    int nextLevelId = await getNextOnePlayerLexpeditionLevelId();

    if (nextLevelId > 0) {
      FirebaseDatabase.instance
          .ref('onePlayerLexpeditions/' + nextLevelId.toString())
          .set({
        'attempts': 0,
        'attemptsFinished': 0,
        'author': author,
        'averageGuesses': 0,
        'bestAttempt': 100,
        'gridCode': encodedGridString
      });
    }
  }

  static Future<void> createTwoPlayerLevel(String encodedGridStringA,
      String encodedGridStringB, String author) async {
    int nextLevelId = await getNextTwoPlayerLevelId();

    if (nextLevelId > 0) {
      FirebaseDatabase.instance
          .ref('twoPlayerPuzzles/' + nextLevelId.toString())
          .set({
        'attempts': 0,
        'attemptsFinished': 0,
        'author': author,
        'averageGuesses': 0,
        'bestAttempt': 100,
        'gridCodeA': encodedGridStringA,
        'gridCodeB': encodedGridStringB
      });
    }
  }

  static Future<void> createTwoPlayerLexpeditionLevel(String encodedGridStringA,
      String encodedGridStringB, String author) async {
    int nextLevelId = await getNextTwoPlayerLexpeditionId();

    if (nextLevelId > 0) {
      FirebaseDatabase.instance
          .ref('twoPlayerLexpeditions/' + nextLevelId.toString())
          .set({
        'attempts': 0,
        'attemptsFinished': 0,
        'author': author,
        'averageGuesses': 0,
        'bestAttempt': 100,
        'gridCodeA': encodedGridStringA,
        'gridCodeB': encodedGridStringB
      });
    }
  }

  static Future<int> getNextOnePlayerLevelId() async {
    String nextLevelId = '-1';

    await FirebaseDatabase.instance
        .ref('onePlayerPuzzles')
        .orderByKey()
        .limitToLast(1)
        .once(DatabaseEventType.value)
        .then((value) {
      if (value.snapshot.children.length > 0) {
        DataSnapshot puzzleEntry = value.snapshot.children.last;
        String puzzleIdString = puzzleEntry.key as String;
        nextLevelId = puzzleIdString;
      }
    });

    return int.parse(nextLevelId) + 1;
  }

  static Future<int> getNextOnePlayerLexpeditionLevelId() async {
    String nextLevelId = '-1';

    await FirebaseDatabase.instance
        .ref('onePlayerLexpeditions')
        .orderByKey()
        .limitToLast(1)
        .once(DatabaseEventType.value)
        .then((value) {
      if (value.snapshot.children.length > 0) {
        DataSnapshot puzzleEntry = value.snapshot.children.last;
        String puzzleIdString = puzzleEntry.key as String;
        nextLevelId = puzzleIdString;
      }
    });

    return int.parse(nextLevelId) + 1;
  }

  static Future<int> getNextTwoPlayerLevelId() async {
    String nextLevelId = '-1';

    await FirebaseDatabase.instance
        .ref('twoPlayerPuzzles')
        .orderByKey()
        .limitToLast(1)
        .once(DatabaseEventType.value)
        .then((value) {
      if (value.snapshot.children.length > 0) {
        DataSnapshot puzzleEntry = value.snapshot.children.last;
        String puzzleIdString = puzzleEntry.key as String;
        nextLevelId = puzzleIdString;
      }
    });

    return int.parse(nextLevelId) + 1;
  }

  static Future<int> getNextTwoPlayerLexpeditionId() async {
    String nextLevelId = '-1';

    await FirebaseDatabase.instance
        .ref('twoPlayerLexpeditions')
        .orderByKey()
        .limitToLast(1)
        .once(DatabaseEventType.value)
        .then((value) {
      if (value.snapshot.children.length > 0) {
        DataSnapshot puzzleEntry = value.snapshot.children.last;
        String puzzleIdString = puzzleEntry.key as String;
        nextLevelId = puzzleIdString;
      }
    });

    return int.parse(nextLevelId) + 1;
  }
}
