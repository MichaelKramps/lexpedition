import 'package:flutter/material.dart';
import 'package:lexpedition/src/build_puzzle/blank_grid.dart';
import 'package:lexpedition/src/game_data/accepted_guess.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_level.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/game_data/letter_tile.dart';
import 'package:lexpedition/src/game_data/word_helper.dart';
import 'package:lexpedition/src/level_info/level_db_connection.dart';
import 'package:lexpedition/src/party/party_db_connection.dart';
import 'package:lexpedition/src/tutorial/tutorial_levels.dart';
import 'package:logging/logging.dart';

class GameState extends ChangeNotifier {
  GameLevel level = GameLevel(gridCode: blankGrid);
  LetterGrid primaryLetterGrid = LetterGrid.blankGrid();
  LetterGrid? secondaryLetterGrid;
  List<LetterTile> currentGuess = [];
  List<AcceptedGuess> guessList = [];
  bool levelCompleted = false;
  bool showBadGuess = false;
  bool viewingMyScreen = true;
  Logger _logger = new Logger('game state');

  GameState({required this.level}) {
    primaryLetterGrid = level.letterGrid;

    if (level.letterGridB != null) {
      secondaryLetterGrid = level.letterGridB as LetterGrid;
    }
  }

  GameState.emptyState() {}

  void loadOnePlayerPuzzle({int? tutorialNumber, int? databaseId}) async {
    _logger.info('loading a new puzzle');
    resetPuzzle();
    if (tutorialNumber != null) {
      GameLevel level = tutorialLevels[tutorialNumber];
      primaryLetterGrid = level.letterGrid;
    } else if (databaseId != null) {
      //get the specific level in the database
    } else {
      GameLevel? level = await LevelDatabaseConnection.getNewOnePlayerPuzzle();
      if (level != null) {
        primaryLetterGrid = level.letterGrid;
      }
    }
    notifyAllPlayers();
  }

  void notifyAllPlayers() {
    _logger.info('notifyAllPlayers()');
    _logger.info(getCurrentGuess());
    PartyDatabaseConnection().updateMyPuzzle(letterGrid: getMyGrid());
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

  void levelComplete() {
    levelCompleted = false;
    notifyAllPlayers();
  }

  void resetPuzzle() {
    primaryLetterGrid = level.letterGrid;

    if (level.letterGridB != null) {
      secondaryLetterGrid = level.letterGridB as LetterGrid;
    }

    currentGuess = [];
    guessList = [];
    levelCompleted = false;
    showBadGuess = false;
  }

  LetterGrid getMyGrid() {
    PartyDatabaseConnection partyDatabaseConnection = PartyDatabaseConnection();
    if (partyDatabaseConnection.isPartyLeader) {
      return primaryLetterGrid;
    } else {
      return secondaryLetterGrid as LetterGrid;
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

  void clearGuess() {
    currentGuess = [];
    for (LetterTile tile in getMyGrid().letterTiles) {
      tile.unselect();
      tile.unprimeForBlast();
    }
    notifyAllPlayers();
  }

  void updateGuess(LetterTile letterTile, bool isSlideEvent) {
    //verify we are allowed to select this tile
    if (letterTile.clearOfObstacles() &&
        (currentGuess.length == 0 ||
            currentGuess.last.allowedToSelect(letterTile))) {
      //select this tile and update the current guess
      letterTile.select();
      currentGuess.add(letterTile);
    } else if (!isSlideEvent && letterTile == currentGuess.last) {
      // unselect tile
      letterTile.unselect();
      currentGuess.removeLast();
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

  void handleAcceptedGuess() {
    guessList.add(AcceptedGuess(guess: getCurrentGuess()));
    chargeTilesFromGuess();
    // check for win condition
    if (isLevelWon()) {
      levelCompleted = true;
    } else if (currentGuess.length >= Constants.guessLengthToActivateBlast) {
      //clearGuess() at end of this method will fire notifyAllPlayers
      //before blastTiles() unblasts the tiles
      blastTiles();
    }
    //notifyAllPlayers() is called here
    clearGuess();
  }

  void blastTiles() async {
    getMyGrid().blastFromIndex(currentGuess.last.index);
    if (isLevelWon()) {
      levelCompleted = true;
    }

    //before this future returns,
    //notifyAllPlayers() should call from somewhere else
    await Future<void>.delayed(Constants.blastDuration);
    getMyGrid().unblast();

    // notify again after unblasting
    notifyAllPlayers();
  }

  void flipBadGuess() async {
    showBadGuess = true;

    //notifyAllPlayers should be called elsewhere
    //before this future completes
    await Future<void>.delayed(Constants.showBadGuessDuration);

    showBadGuess = false;
    notifyAllPlayers();
  }

  void submitGuess() {
    if (currentGuess.length < 3 || !currentGuessIsValid()) {
      flipBadGuess();
      //notifyAllPlayers is called inside clearGuess()
      clearGuess();
    } else {
      handleAcceptedGuess();
    }
  }

  void clickTileAtIndex(int clickedTileIndex, bool isSlideEvent) {
    _logger.info('clickTileAtIndex(' + clickedTileIndex.toString() + ')');
    LetterTile clickedTile = getMyGrid().letterTiles[clickedTileIndex];
    if (clickedTile.tileType != TileType.empty) {
      updateGuess(clickedTile, isSlideEvent);
    }
  }

  void changeBlastDirection() {
    getMyGrid().changeBlastDirection();
    notifyAllPlayers();
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
