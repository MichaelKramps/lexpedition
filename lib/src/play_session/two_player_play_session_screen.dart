import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/audio/audio_controller.dart';
import 'package:lexpedition/src/audio/sounds.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:lexpedition/src/game_data/game_column.dart';
import 'package:lexpedition/src/game_widgets/game_instance_widget.dart';
import 'package:lexpedition/src/game_widgets/observer_game_instance_widget.dart';
import 'package:lexpedition/src/level_info/level_db_connection.dart';
import 'package:provider/provider.dart';

class TwoPlayerPlaySessionScreen extends StatefulWidget {
  const TwoPlayerPlaySessionScreen({super.key});

  @override
  State<TwoPlayerPlaySessionScreen> createState() =>
      _TwoPlayerPlaySessionScreenState();
}

class _TwoPlayerPlaySessionScreenState
    extends State<TwoPlayerPlaySessionScreen> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(builder: (context, gameState, child) {
      if (gameState.levelCompleted && !gameState.celebrating) {
        gameState.celebrating = true;
        _playerWon(gameState);
      }
      return Scaffold(
          body: IgnorePointer(
              ignoring: gameState.celebrating,
              child: determineVisibleGrid(gameState)));
    });
  }

  Widget determineVisibleGrid(GameState gameState) {
    if (!gameState.aGridExists()) {
      String waitingText = gameState.realTimeCommunication.isPartyLeader
          ? 'Loading puzzle...'
          : 'Waiting for your partner to start a game...';
      return SizedBox.expand(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Text(waitingText)],
      ));
    } else if (gameState.getMyGrid() != null && gameState.viewingMyScreen) {
      return determineMyAnimatedGameBoard(gameState, true);
    } else {
      return determineMyAnimatedGameBoard(gameState, false);
    }
  }

  Widget determineMyAnimatedGameBoard(GameState gameState, bool myBoard) {
    Widget boardToAnimate = myBoard
        ? getBaseGameBoard(gameState)
        : getObservingBaseGameBoard(gameState);
    if (gameState.celebrating) {
      return boardToAnimate.animate().color(
          end: Colors.green, duration: Constants.celebrationAnimationDuration);
    } else {
      return boardToAnimate;
    }
  }

  Widget getBaseGameBoard(GameState gameState) {
    return GameInstanceWidget(
        gameState: gameState,
        leftColumn: GameColumn.twoPlayerLeftColumn,
        rightColumn: GameColumn.twoPlayerRightColumn);
  }

  Widget getObservingBaseGameBoard(GameState gameState) {
    return ObserverGameInstanceWidget(
        gameState: gameState,
        leftColumn: GameColumn.twoPlayerLeftColumn,
        rightColumn: GameColumn.twoPlayerRightColumn);
  }

  Future<void> _playerWon(GameState gameState) async {
    gameState.completeLevel();

    if (gameState.level.puzzleId != null) {
      LevelDatabaseConnection.logTwoPlayerFinishedPuzzleResults(
          gameState.level.puzzleId as int, gameState.guessList.length);
    }

    // Let the player see the game just after winning for a bit.
    await Future<void>.delayed(Constants.preCelebrationDuration);
    if (!mounted) return;

    final audioController = context.read<AudioController>();
    await audioController.playSfx(SfxType.wonLevel);

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
      if (gameState.realTimeCommunication.isPartyLeader) {
        GoRouter.of(context).push('/freeplaywon/leader');
      } else {
        GoRouter.of(context).push('/freeplaywon/joiner');
      }
    });
  }
}
