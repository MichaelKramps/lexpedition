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
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class TwoPlayerPuzzleLoader extends StatefulWidget {
  const TwoPlayerPuzzleLoader({super.key});

  @override
  State<TwoPlayerPuzzleLoader> createState() => _TwoPlayerPuzzleLoaderState();
}

class _TwoPlayerPuzzleLoaderState extends State<TwoPlayerPuzzleLoader> {
  late GameLevel _gameLevel = GameLevel.blankLevel();
  bool _initialLoad = true;

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
    PartyDatabaseConnection partyDatabaseConnection = PartyDatabaseConnection();
    if (partyDatabaseConnection.isPartyLeader) {
      GameLevel level = await LevelDatabaseConnection.getTwoPlayerPuzzle();

      partyDatabaseConnection.loadPuzzleForPlayers(
          gridCodeListA: level.gridCode, gridCodeListB: level.gridCodeB);

      setState(() {
        _gameLevel = level;
      });
    }

    partyDatabaseConnection.listenForPuzzle(updateLevel);
  }

  void updateLevel(
      {LetterGrid? myLetterGrid,
      required LetterGrid theirLetterGrid,
      int? blastIndex}) {
    new Logger('name').info('updating');
    if (myLetterGrid != null) {
      //should always mean player is getting a new puzzle
      setState(() {
        _gameLevel.setMyLetterGrid(myLetterGrid);
      });
    } else if (blastIndex != null) {
      //need to blast my puzzle based on partner's blast index
      setState(() {
        _gameLevel.getMyLetterGrid()?.blastFromIndex(blastIndex);
      });
      Future<void>.delayed(Constants.blastDuration, () {
        setState(() {
          _gameLevel.getMyLetterGrid()?.unblast();
        });
      });
    }
    setState(() {
      _gameLevel.setTheirLetterGrid(theirLetterGrid);
    });

    checkForWinAtCorrectTime();
  }

  void checkForWinAtCorrectTime() {
    // this check is necessary to allow the observing player to
    // click through the win screen before the party leader
    if (!_initialLoad) {
      if (checkForWin()) {
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
