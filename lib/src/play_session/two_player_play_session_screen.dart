import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final GameState gameState;

  const TwoPlayerPlaySessionScreen({super.key, required this.gameState});

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
    if (widget.gameState.levelCompleted && !widget.gameState.celebrating) {
      widget.gameState.celebrating = true;
      _playerWon(widget.gameState);
    }
    return Scaffold(
        body: IgnorePointer(
            ignoring: widget.gameState.celebrating,
            child: determineVisibleGrid(widget.gameState)));
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
      return GameInstanceWidget(
          gameState: gameState,
          leftColumn: GameColumn.twoPlayerLeftColumn,
          rightColumn: GameColumn.twoPlayerRightColumn);
    } else {
      return ObserverGameInstanceWidget(
          gameState: gameState,
          leftColumn: GameColumn.twoPlayerLeftColumn,
          rightColumn: GameColumn.twoPlayerRightColumn);
    }
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
      if (gameState.realTimeCommunication.isPartyLeader) {
        GoRouter.of(context).push('/freeplaywon/leader');
      } else {
        GoRouter.of(context).push('/freeplaywon/joiner');
      }
    });
  }
}
