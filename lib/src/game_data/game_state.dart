import 'package:flutter/material.dart';
import 'package:lexpedition/src/build_puzzle/blank_grid.dart';
import 'package:lexpedition/src/game_data/accepted_guess.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/error_definitions.dart';
import 'package:lexpedition/src/game_data/game_level.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/game_data/letter_tile.dart';
import 'package:lexpedition/src/game_data/word_helper.dart';
import 'package:lexpedition/src/level_info/level_db_connection.dart';
import 'package:lexpedition/src/party/party_db_connection.dart';
import 'package:lexpedition/src/party/real_time_communication.dart';
import 'package:lexpedition/src/tutorial/tutorial_levels.dart';
import 'package:logging/logging.dart';

class GameState extends ChangeNotifier {
  GameLevel level = GameLevel(gridCode: blankGrid);
  LetterGrid primaryLetterGrid = LetterGrid.blankGrid();
  LetterGrid? secondaryLetterGrid;
  RealTimeCommunication realTimeCommunication = RealTimeCommunication();
  List<LetterTile> currentGuess = [];
  List<AcceptedGuess> guessList = [];
  bool levelCompleted = false;
  bool showBadGuess = false;
  bool viewingMyScreen = true;
  bool blasting = false;
  ErrorDefinition errorDefinition = ErrorDefinition.noError;
  Logger _logger = new Logger('game state');

  //toString() method and GameState.fromString() constructor maybe??

  GameState({required this.level}) {
    primaryLetterGrid = level.letterGrid;

    if (level.letterGridB != null) {
      secondaryLetterGrid = level.letterGridB as LetterGrid;
    }
  }

  GameState.emptyState() {
    this.realTimeCommunication.setGameStateFunctions(
        notifyListeners: notifyListeners,
        loadPuzzleFromPeerUpdate: loadPuzzleFromPeerUpdate,
        updatePuzzleFromPeerUpdate: updatePuzzleFromPeerUpdate,
        blastPuzzleFromPeerUpdate: blastPuzzleFromPeerUpdate);
  }

  Future<void> loadOnePlayerPuzzle(
      {int? tutorialNumber, int? databaseId}) async {
    _logger.info('loading a new puzzle');
    resetPuzzle();
    if (tutorialNumber != null) {
      GameLevel tutorialLevel = GameLevel.copy(tutorialLevels[tutorialNumber]);
      level = tutorialLevel;
      primaryLetterGrid = tutorialLevel.letterGrid;
    } else if (databaseId != null) {
      //get the specific level in the database
    } else {
      GameLevel? newLevel = await LevelDatabaseConnection.getOnePlayerPuzzle();
      if (newLevel != null) {
        level = newLevel;
        primaryLetterGrid = newLevel.letterGrid;
      } else {
        errorDefinition = ErrorDefinition.levelFetchError;
      }
    }
    loadPuzzleAndNotify();
  }

  Future<void> loadTwoPlayerPuzzle(
      {int? tutorialNumber, int? databaseId}) async {
    _logger.info('loading a new two player puzzle');
    resetPuzzle();
    if (tutorialNumber != null) {
      GameLevel tutorialLevel = GameLevel.copy(tutorialLevels[tutorialNumber]);
      level = tutorialLevel;
      primaryLetterGrid = tutorialLevel.letterGrid;
    } else if (databaseId != null) {
      //get the specific level in the database
    } else {
      GameLevel? newLevel = await LevelDatabaseConnection.getTwoPlayerPuzzle();
      if (newLevel != null) {
        level = newLevel;
        primaryLetterGrid = newLevel.letterGrid;
        secondaryLetterGrid = newLevel.letterGridB;
      } else {
        errorDefinition = ErrorDefinition.levelFetchError;
      }
    }
    loadPuzzleAndNotify();
  }

  void loadPuzzleAndNotify() {
    realTimeCommunication.sendPuzzleToPeer(level);
    notifyListeners();
  }

  void resetError() {
    errorDefinition = ErrorDefinition.noError;
    notifyListeners();
  }

  // void listenForPuzzleUpdatesFromPartner() {
  //   _logger.info('listening');
  //   PartyDatabaseConnection()
  //       .listenForPuzzle(updateMyGameStateFromPartnerUpdate);
  // }

  void loadPuzzleFromPeerUpdate(GameLevel level) {
    this.level = level;
    this.primaryLetterGrid = LetterGrid(level.gridCode);
    this.secondaryLetterGrid =
        level.gridCodeB == null ? null : LetterGrid(level.gridCodeB!);
    notifyListeners();
  }

  void updatePuzzleFromPeerUpdate(LetterGrid theirLetterGrid) {
    setTheirGrid(theirLetterGrid);
    setMyGridFromTheirs(theirLetterGrid);
    notifyListeners();
  }

  void blastPuzzleFromPeerUpdate(int blastIndex) {
    if (getMyGrid() != null) {
      blastTilesAndDontNotify(blastIndex);
      notifyListeners();
    }
  }

  // void updateMyGameStateFromPartnerUpdate(
  //     {double? averageGuesses,
  //     int? bestAttempt,
  //     int? blastIndex,
  //     String? gameLevelCode,
  //     required LetterGrid theirLetterGrid}) async {
  //   _logger.info('updating puzzle');
  //   if (gameLevelCode != null) {
  //     //should always mean player is getting a new puzzle
  //     resetPuzzle();
  //     GameLevel? loadedLevel =
  //         await LevelDatabaseConnection.lookUpLevelFromCode(gameLevelCode);
  //     if (loadedLevel != null) {
  //       level = loadedLevel;
  //       if (gameLevelCode[0] == 2) {
  //         // two player level was loaded
  //         setMyGrid(loadedLevel.letterGridB as LetterGrid);
  //       } else {
  //         //it will be loaded by later code
  //       }
  //     }
  //   } else if (blastIndex != null && getMyGrid() != null) {
  //     //need to blast my puzzle based on partner's blast index
  //     blastTilesAndDontNotify(blastIndex);
  //   }

  //   if (averageGuesses != null && bestAttempt != null) {
  //     level.averageGuesses = averageGuesses;
  //     level.bestAttempt = bestAttempt;
  //     setTheirGrid(theirLetterGrid);
  //   } else {
  //     setTheirGrid(theirLetterGrid);
  //     setMyGridFromTheirs(theirLetterGrid);
  //   }

  //   addNewGuessesFromPartner(theirLetterGrid);

  //   if (isLevelWon()) {
  //     levelCompleted = true;
  //   }

  //   notifyAllPlayers();
  // }

  void notifyAllPlayers() {
    _logger.info('notifyAllPlayers()');
    if (getMyGrid() != null) {
      realTimeCommunication
          .sendUpdatedGameDataToPeer(getMyGrid()!.encodedGridToString());
    }
    notifyListeners();
  }

  bool isBlankGame() {
    for (LetterTile tile in primaryLetterGrid.letterTiles) {
      if (tile.tileType != TileType.empty) {
        return false;
      }
    }
    return true;
  }

  bool isLevelWon() {
    // level is not won if it is blank
    if (isBlankGame()) {
      return false;
    }

    if (secondaryLetterGrid != null) {
      LetterGrid secondaryGrid = secondaryLetterGrid as LetterGrid;
      return primaryLetterGrid.isFullyCharged() &&
          secondaryGrid.isFullyCharged();
    } else {
      return primaryLetterGrid.isFullyCharged();
    }
  }

  void completeLevel() async {
    levelCompleted = false;
    notifyAllPlayers();

    await Future<void>.delayed(Constants.waitForWinScreenDuration);
    primaryLetterGrid = LetterGrid.blankGrid();
    secondaryLetterGrid = null;
    notifyAllPlayers();
  }

  void resetPuzzle() {
    primaryLetterGrid = level.letterGrid;
    primaryLetterGrid.resetGrid();

    if (level.letterGridB != null) {
      secondaryLetterGrid = level.letterGridB as LetterGrid;
      secondaryLetterGrid?.resetGrid();
    }

    currentGuess = [];
    guessList = [];
    levelCompleted = false;
    showBadGuess = false;
  }

  LetterGrid? getMyGrid() {
    if (PartyDatabaseConnection().isPartyLeader) {
      return primaryLetterGrid;
    } else {
      return secondaryLetterGrid;
    }
  }

  bool aGridExists() {
    if (getMyGrid() != null) {
      LetterGrid myGrid = getMyGrid() as LetterGrid;
      return !myGrid.isBlank();
    } else {
      if (getTheirGrid() != null) {
        LetterGrid theirGrid = getTheirGrid() as LetterGrid;
        return !theirGrid.isBlank();
      }
    }
    return false;
  }

  void setMyGrid(LetterGrid newGrid) {
    if (PartyDatabaseConnection().isPartyLeader) {
      primaryLetterGrid = newGrid;
    } else {
      secondaryLetterGrid = newGrid;
    }
  }

  void setMyGridFromTheirs(LetterGrid theirGrid) {
    if (getMyGrid() != null && getTheirGrid() != null) {
      LetterGrid myGrid = getMyGrid() as LetterGrid;
      for (int index = 0;
          index < primaryLetterGrid.letterTiles.length;
          index++) {
        LetterTile myTile = myGrid.letterTiles[index];
        LetterTile theirTile = theirGrid.letterTiles[index];
        if (theirTile.primedForBlast) {
          myTile.primeForBlastFromPartner();
        } else {
          myTile.unprimeForBlastFromPartner();
        }
      }
    }
  }

  void addNewGuessesFromPartner(LetterGrid theirGrid) {
    for (AcceptedGuess theirGuess in theirGrid.guesses) {
      bool foundString = false;
      for (AcceptedGuess currentGuess in guessList) {
        if (currentGuess.matchesGuess(theirGuess)) {
          foundString = true;
        }
      }
      if (!foundString) {
        guessList.add(theirGuess);
      }
    }
  }

  void setTheirGrid(LetterGrid newGrid) {
    if (PartyDatabaseConnection().isPartyLeader) {
      secondaryLetterGrid = newGrid;
    } else {
      primaryLetterGrid = newGrid;
    }
  }

  LetterGrid? getTheirGrid() {
    PartyDatabaseConnection partyDatabaseConnection = PartyDatabaseConnection();
    if (partyDatabaseConnection.isPartyLeader) {
      return secondaryLetterGrid;
    } else {
      return primaryLetterGrid;
    }
  }

  String getCurrentGuess() {
    String currentGuessString = '';
    for (LetterTile tile in currentGuess) {
      currentGuessString += tile.letter.toUpperCase();
    }
    return currentGuessString;
  }

  void clearGuessAndNotify() {
    currentGuess = [];
    if (getMyGrid() != null) {
      LetterGrid myGrid = getMyGrid() as LetterGrid;
      for (LetterTile tile in myGrid.letterTiles) {
        tile.unselect();
        tile.unprimeForBlast();
      }
    }
    notifyAllPlayers();
  }

  void updateGuessAndNotify(LetterTile letterTile, bool isSlideEvent) {
    //verify we are allowed to select this tile
    if (letterTile.clearOfObstacles() &&
        (currentGuess.length == 0 ||
            currentGuess.last.allowedToSelect(letterTile))) {
      //select this tile and add to current guess
      letterTile.select();
      currentGuess.add(letterTile);
      //if this tile could fire a magic blast, prime for blast
      if (currentGuess.length >= Constants.guessLengthToActivateBlast) {
        letterTile.primeForBlast();
      }
      //if tile another tile was primed for blast, unprime it
      if (currentGuess.length >= Constants.guessLengthToActivateBlast + 1) {
        currentGuess[currentGuess.length - 2].unprimeForBlast();
      }
    } else if (!isSlideEvent && letterTile == currentGuess.last) {
      // unselect tile, unprime it and remove from current guess
      letterTile.unselect();
      letterTile.unprimeForBlast();
      currentGuess.removeLast();
      //if another tile should be primed for blast, prime it
      if (currentGuess.length >= 5) {
        currentGuess[currentGuess.length - 1].primeForBlast();
      }
    }
    notifyAllPlayers();
  }

  bool currentGuessIsValid() {
    //return false if word has already been guessed
    for (AcceptedGuess previousGuess in guessList) {
      if (previousGuess.guess.toUpperCase() == getCurrentGuess()) {
        return false;
      }
    }

    //return true only if guess is a valid word
    return WordHelper.isValidWord(getCurrentGuess());
  }

  chargeTilesFromGuess() {
    for (int index = 0; index < currentGuess.length; index++) {
      LetterTile thisTile = currentGuess[index];
      if (index == 0) {
        thisTile.addPositionalCharge(TileType.start);
      } else if (index == currentGuess.length - 1) {
        thisTile.addPositionalCharge(TileType.end);
      } else {
        thisTile.addPositionalCharge(TileType.basic);
      }
    }
  }

  void handleAcceptedGuess() async {
    guessList.add(AcceptedGuess(guess: getCurrentGuess()));
    getMyGrid()?.addGuess(getCurrentGuess());
    chargeTilesFromGuess();
    // check for win condition
    if (isLevelWon()) {
      levelCompleted = true;
    } else if (currentGuess.length >= Constants.guessLengthToActivateBlast) {
      //clearGuess() at end of this method will fire notifyAllPlayers
      //before blastTiles() unblasts the tiles
      await blastTilesAndNotify(currentGuess.last.index);
    }
    //notifyAllPlayers() is called here
    clearGuessAndNotify();
  }

  Future<void> blastTilesAndNotify(int index) async {
    if (getMyGrid() != null) {
      _logger.info('blasting my grid from ' + index.toString());
      LetterGrid myGrid = getMyGrid() as LetterGrid;

      myGrid.blastFromIndex(index);
      //PartyDatabaseConnection().updateMyPuzzle(letterGrid: myGrid, blastIndex: index);
      realTimeCommunication.sendBlastIndexDataToPeer(index);
      notifyListeners();
      if (isLevelWon()) {
        levelCompleted = true;
        notifyListeners();
      }

      await Future<void>.delayed(Constants.blastDuration);
      myGrid.unblast();
    }
  }

  void blastTilesAndDontNotify(int index) async {
    if (getMyGrid() != null && !blasting) {
      blasting = true;
      _logger.info('blasting from ' + index.toString());
      LetterGrid myGrid = getMyGrid() as LetterGrid;

      myGrid.blastFromIndex(index);
      if (isLevelWon()) {
        levelCompleted = true;
      }

      //before this future returns,
      //notifyAllPlayers() should call from somewhere else
      await Future<void>.delayed(Constants.blastDuration);
      myGrid.unblast();
      blasting = false;
      notifyListeners();
    }
  }

  void flipBadGuess() async {
    showBadGuess = true;
    notifyAllPlayers();

    //notifyAllPlayers should be called elsewhere
    //before this future completes
    await Future<void>.delayed(Constants.showBadGuessDuration);

    showBadGuess = false;
    clearGuessAndNotify();
  }

  void submitGuess() {
    if (currentGuess.length < 3 || !currentGuessIsValid()) {
      flipBadGuess();
    } else {
      handleAcceptedGuess();
    }
  }

  void clickTileAtIndex(int clickedTileIndex, bool isSlideEvent) {
    if (getMyGrid() != null) {
      LetterGrid myGrid = getMyGrid() as LetterGrid;
      LetterTile clickedTile = myGrid.letterTiles[clickedTileIndex];
      if (clickedTile.tileType != TileType.empty) {
        updateGuessAndNotify(clickedTile, isSlideEvent);
      }
    }
  }

  void changeBlastDirectionAndNotify() {
    if (getMyGrid() != null) {
      LetterGrid myGrid = getMyGrid() as LetterGrid;
      myGrid.changeBlastDirection();
      notifyAllPlayers();
    }
  }

  List<AcceptedGuess> getAllGuessesInOrder() {
    guessList.sort((a, b) => b.timeSubmitted.compareTo(a.timeSubmitted));
    return guessList;
  }

  void toggleVisibleScreen() {
    viewingMyScreen = !viewingMyScreen;
    notifyAllPlayers();
  }
}
