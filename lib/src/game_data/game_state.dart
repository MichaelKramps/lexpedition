import 'package:flutter/material.dart';
import 'package:lexpedition/src/audio/audio_controller.dart';
import 'package:lexpedition/src/audio/sounds.dart';
import 'package:lexpedition/src/build_puzzle/blank_grid.dart';
import 'package:lexpedition/src/game_data/accepted_guess.dart';
import 'package:lexpedition/src/game_data/button_push.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/error_definitions.dart';
import 'package:lexpedition/src/game_data/game_level.dart';
import 'package:lexpedition/src/game_data/game_mode.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/game_data/letter_tile.dart';
import 'package:lexpedition/src/game_data/word_helper.dart';
import 'package:lexpedition/src/level_info/level_db_connection.dart';
import 'package:lexpedition/src/party/real_time_communication.dart';
import 'package:lexpedition/src/tutorial/full_tutorial_levels.dart';
import 'package:lexpedition/src/tutorial/quick_tutorial_levels.dart';
import 'package:lexpedition/src/tutorial/tutorial_step.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class GameState extends ChangeNotifier {
  GameLevel level = GameLevel(gridCode: blankGrid);
  LetterGrid primaryLetterGrid = LetterGrid.blankGrid();
  LetterGrid? secondaryLetterGrid;
  List<TutorialStep> tutorialSteps = [];
  int currentTutorialStep = 0;
  RealTimeCommunication realTimeCommunication = RealTimeCommunication();
  List<AcceptedGuess> guessList = [];
  bool levelCompleted = false;
  bool loadingLevel = true;
  bool celebrating = false;
  bool showBadGuess = false;
  bool viewingMyScreen = true;
  bool blasting = false;
  GameMode gameMode = GameMode.OnePlayerFreePlay;
  ErrorDefinition errorDefinition = ErrorDefinition.noError;
  Logger _logger = new Logger('game state');

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
        pushButtonFromPeerUpdate: pushButtonFromPeerUpdate);
  }

  Future<void> loadOnePlayerPuzzle({int? tutorialKey, int? databaseId}) async {
    resetPuzzle();
    loadingLevel = true;
    if (tutorialKey != null) {
      if (tutorialKey < 200) {
        // 102 denotes quick tutorial level 2
        GameLevel tutorialLevel =
            GameLevel.copy(quickTutorialLevels[tutorialKey - 101]);
        level = tutorialLevel;
      } else {
        // 204 denotes full tutorial level 4
        GameLevel tutorialLevel =
            GameLevel.copy(fullTutorialLevels[tutorialKey - 201]);
        level = tutorialLevel;
      }

      if (level.tutorialSteps != null) {
        this.tutorialSteps = level.tutorialSteps!;
      }
      primaryLetterGrid = level.letterGrid;
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

  Future<void> loadOnePlayerLexpedition({int? databaseId}) async {
    resetPuzzle();
    loadingLevel = true;
    if (databaseId != null) {
      //get the specific level in the database
    } else {
      GameLevel? newLevel =
          await LevelDatabaseConnection.getOnePlayerLexpedition();
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
    secondaryLetterGrid = null;
    resetPuzzle();
    loadingLevel = true;
    if (tutorialNumber != null) {
      GameLevel tutorialLevel =
          GameLevel.copy(fullTutorialLevels[tutorialNumber]);
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

  Future<void> loadTwoPlayerLexpedition({int? databaseId}) async {
    secondaryLetterGrid = null;
    resetPuzzle();
    loadingLevel = true;
    if (databaseId != null) {
      //get the specific level in the database
    } else {
      GameLevel? newLevel =
          await LevelDatabaseConnection.getTwoPlayerLexpedition();
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

  void doneLoading() {
    loadingLevel = false;
  }

  void updateGameMode(GameMode gameMode) {
    this.gameMode = gameMode;
  }

  void loadPuzzleAndNotify() {
    realTimeCommunication.sendPuzzleToPeer(level);
    notifyListeners();
  }

  void resetError() {
    errorDefinition = ErrorDefinition.noError;
    notifyListeners();
  }

  void setError(ErrorDefinition errorDefinition) {
    this.errorDefinition = errorDefinition;
    notifyListeners();
  }

  void loadPuzzleFromPeerUpdate(GameLevel level) {
    resetPuzzle();
    this.level = level;
    this.primaryLetterGrid = LetterGrid(level.gridCode);
    this.secondaryLetterGrid =
        level.gridCodeB == null ? null : LetterGrid(level.gridCodeB!);
    notifyListeners();
  }

  void pushButtonFromPeerUpdate(ButtonPush buttonPushed, int? tileIndex) async {
    //peer pushed a button on their grid
    if (getTheirGrid() != null) {
      switch (buttonPushed) {
        case ButtonPush.clearGuess:
          clearGuessAndNotify(false);
          notifyListeners();
          break;
        case ButtonPush.changeBlastDirection:
          changeBlastDirectionAndNotify(false);
          notifyListeners();
          break;
        case ButtonPush.submitGuess:
          submitGuess(null, false);
          break;
        case ButtonPush.selectLetterTile:
          assert(tileIndex != null);
          clickTileAtIndex(clickedTileIndex: tileIndex!, isMyGrid: false);
          break;
        default:
          //not a valid message
          break;
      }
    }
  }

  void updateGuessListFromPeerUpdate(String acceptedGuess) {
    this.guessList.add(AcceptedGuess(guess: acceptedGuess, fromMe: false));

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
      return primaryLetterGrid.isFullyCharged() &&
          secondaryLetterGrid!.isFullyCharged();
    } else {
      return primaryLetterGrid.isFullyCharged();
    }
  }

  void completeLevel() async {
    levelCompleted = false;
    notifyListeners();

    await Future<void>.delayed(Constants.waitForWinScreenDuration);
    primaryLetterGrid = LetterGrid.blankGrid();
    secondaryLetterGrid = null;
    notifyListeners();
  }

  void resetPuzzle({bool notify = false, bool loadNew = true}) {
    primaryLetterGrid = level.letterGrid;
    primaryLetterGrid.resetGrid();

    if (loadNew) {
      secondaryLetterGrid = null;
    } else if (secondaryLetterGrid != null) {
      secondaryLetterGrid = level.letterGridB;
      secondaryLetterGrid!.resetGrid();
    }

    guessList = [];
    levelCompleted = false;
    celebrating = false;
    showBadGuess = false;
    currentTutorialStep = 0;
    tutorialSteps = [];

    if (notify) {
      notifyListeners();
    }
  }

  bool currentTutorialStepExists() {
    return currentTutorialStep < tutorialSteps.length;
  }

  void incrementTutorialStep() {
    ++currentTutorialStep;
    notifyListeners();
  }

  TutorialStep getCurrentTutorialStep() {
    if (currentTutorialStepExists()) {
      return tutorialSteps[currentTutorialStep];
    } else {
      return TutorialStep();
    }
  }

  LetterGrid? getMyGrid() {
    if (realTimeCommunication.isPartyLeader) {
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

  LetterGrid? getTheirGrid() {
    if (realTimeCommunication.isPartyLeader) {
      return secondaryLetterGrid;
    } else {
      return primaryLetterGrid;
    }
  }

  String getCurrentGuessString(bool isMyGrid) {
    String currentGuessString = '';
    for (LetterTile tile in getCurrentGuess(isMyGrid)) {
      currentGuessString += tile.letter.toUpperCase();
    }
    return currentGuessString;
  }

  void clearGuessAndNotify(bool isMyGrid) {
    LetterGrid? gridToClear = isMyGrid ? getMyGrid() : getTheirGrid();
    if (gridToClear != null) {
      gridToClear.currentGuess = [];
      for (LetterTile tile in gridToClear.letterTiles) {
        tile.unselect();
        tile.unprimeForBlast();
        attemptToUnprimeOtherGrid(tile.index, isMyGrid);
      }
    }
    setQualifiesValuesForTiles();
    if (isMyGrid) {
      realTimeCommunication.sendButtonPushToPeer(
          buttonPushed: ButtonPush.clearGuess);
    }
    notifyListeners();
  }

  void updateGuessAndNotify(LetterTile letterTile, bool isMyGrid) {
    List<LetterTile> currentGuess;
    if (isMyGrid) {
      currentGuess = getMyGrid() != null ? getMyGrid()!.currentGuess : [];
    } else {
      currentGuess = getTheirGrid() != null ? getTheirGrid()!.currentGuess : [];
    }
    //verify we are allowed to select this tile
    if (letterTile.clearOfObstacles() &&
        (currentGuess.length == 0 ||
            currentGuess.last.allowedToSelect(letterTile))) {
      //select this tile and add to current guess
      currentGuess.add(letterTile);
      letterTile.select(); // must run after adding lettertile to current guess
      //if this tile could fire a magic blast, prime for blast
      if (currentGuess.length >= Constants.guessLengthToActivateBlast) {
        letterTile.primeForBlast();
        attemptToPrimeOtherGrid(letterTile.index, isMyGrid);
      }
      //if tile another tile was primed for blast, unprime it
      if (currentGuess.length >= Constants.guessLengthToActivateBlast + 1) {
        currentGuess[currentGuess.length - 2].unprimeForBlast();
        attemptToUnprimeOtherGrid(
            currentGuess[currentGuess.length - 2].index, isMyGrid);
      }
      setQualifiesValuesForTiles(); //sets qualifiesToBeCharged and qualifiesToBeBlasted
    }
    notifyListeners();
  }

  void attemptToPrimeOtherGrid(int absoluteIndex, bool isMyGrid) {
    LetterGrid? thisGrid = isMyGrid ? getMyGrid() : getTheirGrid();
    LetterGrid? otherGrid = isMyGrid ? getTheirGrid() : getMyGrid();

    if (otherGrid != null && thisGrid != null) {
      if (realTimeCommunication.isConnected) {
        int indexToPrime =
            otherGrid.getAbsoluteIndex(thisGrid.getVisualIndex(absoluteIndex));
        if (indexToPrime >= 0 && indexToPrime < otherGrid.letterTiles.length) {
          otherGrid.letterTiles[indexToPrime].primeForBlastFromPartner();
        }
      }
    }
  }

  void attemptToUnprimeOtherGrid(int absoluteIndex, isMyGrid) {
    LetterGrid? thisGrid = isMyGrid ? getMyGrid() : getTheirGrid();
    LetterGrid? otherGrid = isMyGrid ? getTheirGrid() : getMyGrid();

    if (otherGrid != null && thisGrid != null) {
      if (realTimeCommunication.isConnected) {
        int indexToPrime =
            otherGrid.getAbsoluteIndex(thisGrid.getVisualIndex(absoluteIndex));
        if (indexToPrime >= 0 && indexToPrime < otherGrid.letterTiles.length) {
          otherGrid.letterTiles[indexToPrime].unprimeForBlastFromPartner();
        }
      }
    }
  }

  void setQualifiesValuesForTiles() {
    if (getMyGrid() != null) {
      setGridQualifiesValuesForTiles(getMyGrid()!, getTheirGrid());
    }
    if (getTheirGrid() != null) {
      setGridQualifiesValuesForTiles(getTheirGrid()!, getMyGrid());
    }
  }

  void setGridQualifiesValuesForTiles(
      LetterGrid gridToSet, LetterGrid? otherGrid) {
    List<int> indexesPrimedForBlast = [];
    // notifyListeners is called elsewhere
    for (int tileIndex = 0;
        tileIndex < gridToSet.letterTiles.length;
        tileIndex++) {
      LetterTile thisTile = gridToSet.letterTiles[tileIndex];
      thisTile.qualifiesToBeBlasted = false;
      // set qualifiesToBeCharged
      if (gridToSet.currentGuess.contains(thisTile)) {
        switch (thisTile.tileType) {
          case TileType.basic:
            thisTile.qualifiesToBeCharged = true;
            break;
          case TileType.start:
            thisTile.qualifiesToBeCharged =
                thisTile.index == gridToSet.currentGuess.first.index;
            break;
          case TileType.end:
            thisTile.qualifiesToBeCharged =
                thisTile.index == gridToSet.currentGuess.last.index;
            break;
          default:
            thisTile.qualifiesToBeCharged = false;
        }
      } else {
        thisTile.qualifiesToBeCharged = false;
      }
      if (thisTile.primedForBlastFromPartner || thisTile.primedForBlast) {
        indexesPrimedForBlast.add(thisTile.index);
      }
    }
    // set qualifiesToBeBlasted
    List<int> indexesQualifiedToBeBlasted = [];
    for (int i = 0; i < indexesPrimedForBlast.length; i++) {
      indexesQualifiedToBeBlasted.addAll(LetterGrid.indexesToBlast(
          index: indexesPrimedForBlast[i],
          blastDirection: gridToSet.blastDirection,
          currentColumn: gridToSet.currentColumn));
    }
    for (int i = 0; i < indexesQualifiedToBeBlasted.length; i++) {
      int thisIndex = indexesQualifiedToBeBlasted[i];
      gridToSet.letterTiles[thisIndex].qualifiesToBeBlasted = true;
      // all tiles set to false earlier
    }
  }

  bool currentGuessIsValid(bool isMyGrid) {
    //return false if word has already been guessed
    for (AcceptedGuess previousGuess in guessList) {
      if (previousGuess.guess.toUpperCase() ==
          getCurrentGuessString(isMyGrid)) {
        return false;
      }
    }

    //return true only if guess is a valid word
    return WordHelper.isValidWord(getCurrentGuessString(isMyGrid));
  }

  chargeTilesFromGuess(bool isMyGrid) {
    List<LetterTile> currentGuess = getCurrentGuess(isMyGrid);
    if (isMyGrid) {}
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

  void handleAcceptedGuess(BuildContext? context, bool isMyGrid) async {
    guessList.add(AcceptedGuess(
        guess: getCurrentGuessString(isMyGrid), fromMe: isMyGrid));
    LetterGrid? gridWithGuess = isMyGrid ? getMyGrid() : getTheirGrid();
    gridWithGuess?.addGuess(getCurrentGuessString(isMyGrid));
    chargeTilesFromGuess(isMyGrid);
    bool activateBlast = getCurrentGuess(isMyGrid).length >=
        Constants.guessLengthToActivateBlast;
    if (context != null) {
      final AudioController audioController = context.read<AudioController>();
      if (activateBlast) {
        await audioController.playSfx(SfxType.blast);
      } else {
        await audioController.playSfx(SfxType.correctGuess);
      }
    }
    // check for win condition
    if (isLevelWon()) {
      levelCompleted = true;
      getMyGrid()?.resetCurrentColumn();
      getTheirGrid()?.resetCurrentColumn();
    } else if (activateBlast) {
      //clearGuess() at end of this method will fire notifyListeners
      //before blastTiles() unblasts the tiles
      await blastTilesAndNotify(getCurrentGuess(isMyGrid).last.index, isMyGrid);
    }
    // attempt to update current column for lexpedition puzzles
    getMyGrid()?.updateCurrentColumn();
    getTheirGrid()?.updateCurrentColumn();
    //notifyListeners() is called here
    clearGuessAndNotify(isMyGrid);
  }

  Future<void> blastTilesAndNotify(int absoluteIndex, bool isMyGrid) async {
    blasting = true;

    LetterGrid? thisGrid = isMyGrid ? getMyGrid() : getTheirGrid();
    LetterGrid? otherGrid = isMyGrid ? getTheirGrid() : getMyGrid();

    thisGrid?.blastFromIndex(absoluteIndex);
    if (thisGrid != null && otherGrid != null) {
      otherGrid.blastFromIndex(
          otherGrid.getAbsoluteIndex(thisGrid.getVisualIndex(absoluteIndex)));
    }

    notifyListeners();
    if (isLevelWon()) {
      levelCompleted = true;
      notifyListeners();
    }

    await Future<void>.delayed(Constants.blastDuration);
    getMyGrid()?.unblast();
    getTheirGrid()?.unblast();
    blasting = false;
  }

  void flipBadGuess(bool isMyGrid) async {
    showBadGuess = true;
    notifyListeners();

    //notifyListeners should be called elsewhere
    //before this future completes
    await Future<void>.delayed(Constants.showBadGuessDuration);

    showBadGuess = false;
    clearGuessAndNotify(isMyGrid);
  }

  void submitGuess(BuildContext? context, bool isMyGrid) {
    if (getCurrentGuess(isMyGrid).length < 3 ||
        !currentGuessIsValid(isMyGrid)) {
      if (context != null) {
        final AudioController audioController = context.read<AudioController>();
        audioController.playSfx(SfxType.incorrectGuess);
      }
      flipBadGuess(isMyGrid);
    } else {
      if (isMyGrid) {
        realTimeCommunication.sendButtonPushToPeer(
            buttonPushed: ButtonPush.submitGuess);
      }
      handleAcceptedGuess(context, isMyGrid);
    }
  }

  List<LetterTile> getCurrentGuess(bool isMyGrid) {
    List<LetterTile> currentGuess;
    if (isMyGrid) {
      currentGuess = getMyGrid() != null ? getMyGrid()!.currentGuess : [];
    } else {
      currentGuess = getTheirGrid() != null ? getTheirGrid()!.currentGuess : [];
    }
    return currentGuess;
  }

  void clickTileAtIndex(
      {required int clickedTileIndex,
      BuildContext? context,
      bool isMyGrid = true}) {
    LetterGrid? gridToClick = isMyGrid ? getMyGrid() : getTheirGrid();
    if (gridToClick != null) {
      int indexAdjustedForCurrentColumn =
          clickedTileIndex + gridToClick.currentColumn * 4;
      LetterTile clickedTile =
          gridToClick.letterTiles[indexAdjustedForCurrentColumn];
      if (clickedTile.tileType != TileType.empty) {
        if (context != null && !clickedTile.selected) {
          final AudioController audioController =
              context.read<AudioController>();
          audioController.playSfx(SfxType.tapLetter);
        }
        if (isMyGrid) {
          realTimeCommunication.sendButtonPushToPeer(
              buttonPushed: ButtonPush.selectLetterTile,
              tileIndex: clickedTileIndex);
        }
        updateGuessAndNotify(clickedTile, isMyGrid);
      }
    }
  }

  void changeBlastDirectionAndNotify(bool isMyGrid) {
    LetterGrid? clickedGrid = isMyGrid ? getMyGrid() : getTheirGrid();
    if (clickedGrid != null) {
      clickedGrid.changeBlastDirection();
      setQualifiesValuesForTiles();
      if (isMyGrid) {
        realTimeCommunication.sendButtonPushToPeer(
            buttonPushed: ButtonPush.changeBlastDirection);
      }
      notifyListeners();
    }
  }

  List<AcceptedGuess> getAllGuessesInOrder() {
    guessList.sort((a, b) => b.timeSubmitted.compareTo(a.timeSubmitted));
    return guessList;
  }

  void toggleVisibleScreen() {
    viewingMyScreen = !viewingMyScreen;
    notifyListeners();
  }
}
