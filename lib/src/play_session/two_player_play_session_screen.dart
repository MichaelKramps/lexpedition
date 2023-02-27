import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/audio/audio_controller.dart';
import 'package:lexpedition/src/audio/sounds.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/game_data/game_column.dart';
import 'package:lexpedition/src/game_widgets/game_instance_widget.dart';
import 'package:lexpedition/src/game_widgets/observer_game_instance_widget.dart';
import 'package:lexpedition/src/games_services/score.dart';
import 'package:lexpedition/src/party/party_db_connection.dart';
import 'package:lexpedition/src/style/confetti.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class TwoPlayerPlaySessionScreen extends StatefulWidget {
  final LetterGrid? myLetterGrid;
  final LetterGrid? theirLetterGrid;

  const TwoPlayerPlaySessionScreen(
      {super.key, required this.myLetterGrid, required this.theirLetterGrid});

  @override
  State<TwoPlayerPlaySessionScreen> createState() =>
      _TwoPlayerPlaySessionScreenState();
}

class _TwoPlayerPlaySessionScreenState
    extends State<TwoPlayerPlaySessionScreen> {
  bool _showingMyGrid = true;
  bool _duringCelebration = false;
  bool _playerHasWon = false;
  late DateTime _startOfPlay;

  @override
  void initState() {
    _startOfPlay = DateTime.now();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!_playerHasWon) {
      checkForWin();
    }
    return IgnorePointer(ignoring: _duringCelebration, child: determineStack());
  }

  Widget determineStack() {
    Logger logger = new Logger('tppss');
    logger.info('building TwoPlayerPlaySessionScreen');
    logger.info(widget.myLetterGrid);
    logger.info(widget.theirLetterGrid);
    if (!_duringCelebration) {
      return determineVisibleGrid();
    } else {
      return determineVisibleGrid();
    }
  }

  Widget determineVisibleGrid() {
    if (widget.myLetterGrid != null && _showingMyGrid) {
      return GameInstanceWidget(
          letterGrid: widget.myLetterGrid as LetterGrid,
          playerWon: _playerWon,
          leftColumn: GameColumn.blankColumn,
          rightColumn: GameColumn.twoPlayerRightColumn,
          twoPlayerPlaySessionStateManager: TwoPlayerPlaySessionStateManager(
              twoPlayerState: this, theirLetterGrid: widget.theirLetterGrid));
    } else if (widget.theirLetterGrid != null) {
      return ObserverGameInstanceWidget(
          twoPlayerPlaySessionStateManager: TwoPlayerPlaySessionStateManager(
              twoPlayerState: this, theirLetterGrid: widget.theirLetterGrid),
          leftColumn: GameColumn.blankColumn,
          rightColumn: GameColumn.twoPlayerRightColumn);
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Text('Waiting for your partner to start a game...')],
      );
    }
  }

  void checkForWin() {
    new Logger('checking for win').info('checking');
    if (widget.myLetterGrid != null && widget.theirLetterGrid != null) {
      //two player game
      LetterGrid myGrid = widget.myLetterGrid as LetterGrid;
      LetterGrid theirGrid = widget.theirLetterGrid as LetterGrid;
      if (myGrid.isFullyCharged() && theirGrid.isFullyCharged()) {
        int numberGuesses = myGrid.guesses.length + theirGrid.guesses.length;
        _playerWon(numberGuesses, 1);
      }
    } else {
      //one player game with observer
      if (widget.myLetterGrid != null) {
        LetterGrid myGrid = widget.myLetterGrid as LetterGrid;
        if (myGrid.isFullyCharged()) {
          _playerWon(myGrid.guesses.length, 1);
        }
      } else if (widget.theirLetterGrid != null) {
        LetterGrid theirGrid = widget.theirLetterGrid as LetterGrid;
        if (theirGrid.isFullyCharged()) {
          _playerWon(theirGrid.guesses.length, 1);
        }
      }
    }
  }

  void toggleScreen() {
    setState(() {
      _showingMyGrid = _showingMyGrid ? false : true;
    });
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

    setState(() {
      _playerHasWon = true;
      _duringCelebration = true;
    });

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
        GoRouter.of(context).go('/freeplay/twoplayer', extra: {'score': score});
      }
    });
    if (!mounted) return;
  }
}

class TwoPlayerPlaySessionStateManager {
  _TwoPlayerPlaySessionScreenState twoPlayerState;
  LetterGrid? theirLetterGrid;

  TwoPlayerPlaySessionStateManager(
      {required this.twoPlayerState, this.theirLetterGrid});

  void toggleScreen() {
    twoPlayerState.toggleScreen();
  }

  LetterGrid? getTheirLetterGrid() {
    return theirLetterGrid;
  }
}
