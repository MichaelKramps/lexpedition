import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/audio/audio_controller.dart';
import 'package:lexpedition/src/audio/sounds.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/game_data/levels.dart';
import 'package:lexpedition/src/games_services/score.dart';
import 'package:lexpedition/src/level_info/level_db_connection.dart';
import 'package:lexpedition/src/party/party_db_connection.dart';
import 'package:lexpedition/src/play_session/two_player_play_session_screen.dart';
import 'package:provider/provider.dart';

class TwoPlayerPuzzleLoader extends StatefulWidget {
  const TwoPlayerPuzzleLoader({super.key});

  @override
  State<TwoPlayerPuzzleLoader> createState() => _TwoPlayerPuzzleLoaderState();
}

class _TwoPlayerPuzzleLoaderState extends State<TwoPlayerPuzzleLoader> {
  GameLevel _gameLevel = GameLevel.blankLevel();
  bool _initialLoad = true;
  bool _playerHasWon = false;
  PartyDatabaseConnection _partyDatabaseConnection = PartyDatabaseConnection();

  late DateTime _startOfPlay;

  @override
  void initState() {
    _startOfPlay = DateTime.now();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_initialLoad) {
      loadLevel();
    }
    TwoPlayerPlaySessionScreen twoPlayerScreen = new TwoPlayerPlaySessionScreen(
      gameLevel: _gameLevel,
      playerWon: _playerWon,
    );

    return Scaffold(body: twoPlayerScreen);
  }

  Future<void> loadLevel() async {
    setState(() {
      _playerHasWon = false;
      _initialLoad = false;
      _gameLevel = GameLevel.blankLevel();
    });
    if (_partyDatabaseConnection.isPartyLeader) {
      GameLevel level = await LevelDatabaseConnection.getTwoPlayerPuzzle();

      _partyDatabaseConnection.loadPuzzleForPlayers(level: level);

      setState(() {
        _gameLevel = level;
      });
    }

    _partyDatabaseConnection.listenForPuzzle(updateLevel);
  }

  void updateLevel(
      {LetterGrid? myLetterGrid,
      required LetterGrid theirLetterGrid,
      num? blastIndex,
      num? difficulty}) {
    if (myLetterGrid != null) {
      //should always mean player is getting a new puzzle
      setState(() {
        _gameLevel.setMyLetterGrid(myLetterGrid);
      });
    } else if (blastIndex != null && _gameLevel.getMyLetterGrid() != null) {
      //need to blast my puzzle based on partner's blast index
      setState(() {
        int blastIntIndex = blastIndex.toInt();
        _gameLevel.getMyLetterGrid()?.blastFromIndex(blastIntIndex);
      });
      Future<void>.delayed(Constants.blastDuration, () {
        setState(() {
          _gameLevel.getMyLetterGrid()?.unblast();
        });
        _partyDatabaseConnection.updateMyPuzzle(
            letterGrid: _gameLevel.getMyLetterGrid() as LetterGrid);
      });
    }
    if (difficulty != null) {
      setState(() {
        _gameLevel.difficulty = difficulty.toInt();
        _gameLevel.setTheirLetterGrid(theirLetterGrid);
      });
    } else {
      setState(() {
        _gameLevel.setTheirLetterGrid(theirLetterGrid);
      });
    }

    if (!_playerHasWon) {
      checkForWinAtCorrectTime();
    }
  }

  void checkForWinAtCorrectTime() {
    if (!_initialLoad) {
      if (checkForWin() && !_gameLevel.isBlankLevel()) {
        setState(() {
          _playerHasWon = true;
        });
        _playerWon(99);
      }
    } else {
      setState(() {
        _initialLoad = false;
      });
    }
  }

  bool checkForWin() {
    return _gameLevel.levelFullyCharged();
  }

  Future<void> _playerWon(int guesses) async {
    // to prevent completed levels from being reloaded
    Future<void>.delayed(Constants.clearPuzzlesDuration, () {
      _partyDatabaseConnection.clearLevels();
    });

    int numberGuesses = _gameLevel.letterGrid.guesses.length;
    if (_gameLevel.letterGridB != null) {
      LetterGrid gridB = _gameLevel.letterGridB as LetterGrid;
      numberGuesses += gridB.guesses.length;
    }
    final score = Score(
      numberGuesses,
      _gameLevel.difficulty,
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
    if (!mounted) return;
    await Future<void>.delayed(Constants.celebrationDuration, () {
      if (_partyDatabaseConnection.isPartyLeader) {
        GoRouter.of(context).go('/freeplaywon/leader', extra: {'score': score});
      } else {
        GoRouter.of(context).go('/freeplaywon/joiner', extra: {'score': score});
      }
    });
  }
}
