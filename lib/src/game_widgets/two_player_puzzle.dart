import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/audio/audio_controller.dart';
import 'package:lexpedition/src/audio/sounds.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/game_data/levels.dart';
import 'package:lexpedition/src/games_services/score.dart';
import 'package:lexpedition/src/level_info/free_play_levels.dart';
import 'package:lexpedition/src/party/party_db_connection.dart';
import 'package:lexpedition/src/play_session/two_player_play_session_screen.dart';
import 'package:provider/provider.dart';

class TwoPlayerPuzzle extends StatefulWidget {
  const TwoPlayerPuzzle({super.key});

  @override
  State<TwoPlayerPuzzle> createState() => _TwoPlayerPuzzleState();
}

class _TwoPlayerPuzzleState extends State<TwoPlayerPuzzle> {
  LetterGrid? _theirUpdatedLetterGrid = null;
  LetterGrid? _myUpdatedLetterGrid = null;
  bool _initialLoad = true;

  late DateTime _startOfPlay;

  @override
  void initState() {
    PartyDatabaseConnection partyDatabaseConnection = PartyDatabaseConnection();

    if (partyDatabaseConnection.isPartyLeader) {
      GameLevel levelA =
          freePlayLevels.elementAt(Random().nextInt(freePlayLevels.length));
      GameLevel levelB =
          freePlayLevels.elementAt(Random().nextInt(freePlayLevels.length));

      partyDatabaseConnection.loadPuzzleForPlayers(
          gridCodeListA: levelA.gridCode, gridCodeListB: levelB.gridCode);

      updateGrids(
          theirLetterGrid: LetterGrid.fromLiveDatabase(levelB.gridCode, []),
          myLetterGrid: LetterGrid.fromLiveDatabase(levelA.gridCode, []));
    }

    partyDatabaseConnection.listenForPuzzle(updateGrids);

    _startOfPlay = DateTime.now();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TwoPlayerPlaySessionScreen twoPlayerScreen = new TwoPlayerPlaySessionScreen(
      myLetterGrid: _myUpdatedLetterGrid,
      theirLetterGrid: _theirUpdatedLetterGrid,
      playerWon: _playerWon,
    );

    return Scaffold(body: twoPlayerScreen);
  }

  void updateGrids(
      {LetterGrid? myLetterGrid, required LetterGrid theirLetterGrid}) {
    setState(() {
      if (myLetterGrid != null) {
        _myUpdatedLetterGrid = myLetterGrid;
      }
      _theirUpdatedLetterGrid = theirLetterGrid;
    });
    checkForWinAtCorrectTime();
  }

  void checkForWinAtCorrectTime() {
    // this check is necessary to allow the observing player to
    // click through the win screen before the party leader
    if (!_initialLoad) {
      if (checkForWin()) {
        _playerWon(1, 1);
      }
    } else {
      if (checkForWin()) {
        // means we're still getting the completed grids 
        // from the previous puzzle
        setState(() {
          _myUpdatedLetterGrid = null;
          _theirUpdatedLetterGrid = null;
          _initialLoad = false;
        });
      } else {
        setState(() {
          _initialLoad = false;
        });
      }
    }
  }

  bool checkForWin() {
    if (_myUpdatedLetterGrid != null && _theirUpdatedLetterGrid != null) {
      //two player game
      LetterGrid myGrid = _myUpdatedLetterGrid as LetterGrid;
      LetterGrid theirGrid = _theirUpdatedLetterGrid as LetterGrid;
      if (myGrid.isFullyCharged() && theirGrid.isFullyCharged()) {
        return true;
      }
    } else {
      //one player game with observer
      if (_myUpdatedLetterGrid != null) {
        LetterGrid myGrid = _myUpdatedLetterGrid as LetterGrid;
        if (myGrid.isFullyCharged()) {
          return true;
        }
      } else if (_theirUpdatedLetterGrid != null) {
        LetterGrid theirGrid = _theirUpdatedLetterGrid as LetterGrid;
        if (theirGrid.isFullyCharged()) {
          return true;
        }
      }
    }
    return false;
  }

  Future<void> _playerWon(int guesses, int par) async {
    final score = Score(
      guesses,
      10,
      DateTime.now().difference(_startOfPlay),
    );

    // Let the player see the game just after winning for a bit.
    await Future<void>.delayed(Constants.preCelebrationDuration);
    if (!mounted) return;

    final audioController = context.read<AudioController>();
    audioController.playSfx(SfxType.congrats);

    //final gamesServicesController = context.read<GamesServicesController?>();
    //if (gamesServicesController != null) {
    // Award achievement.
    //if (widget.level.awardsAchievement) {
    //  await gamesServicesController.awardAchievement(
    //    android: widget.level.achievementIdAndroid!,
    //    iOS: widget.level.achievementIdIOS!,
    //  );
    //}

    // Send score to leaderboard.
    //await gamesServicesController.submitLeaderboardScore(score);
    //}

    /// Give the player some time to see the celebration animation.
    await Future<void>.delayed(Constants.celebrationDuration, () {
      if (PartyDatabaseConnection().isPartyLeader) {
        GoRouter.of(context).go('/freeplaywon/leader', extra: {'score': score});
      } else {
        GoRouter.of(context).go('/freeplaywon/joiner', extra: {'score': score});
      }
    });
    if (!mounted) return;
  }
}
