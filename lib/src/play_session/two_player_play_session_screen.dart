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
import 'package:lexpedition/src/player_progress/player_progress.dart';
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
  late DateTime _startOfPlay;

  @override
  void initState() {
    _startOfPlay = DateTime.now();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(ignoring: _duringCelebration, child: determineStack());
  }

  Widget determineStack() {
    if (!_duringCelebration) {
      return determineVisibleGrid();
    } else {
      return Stack(
        children: [
          determineVisibleGrid(),
          SizedBox.expand(
            child: IgnorePointer(
              child: Confetti(),
            ),
          ),
        ],
      );
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
    } else {
      return ObserverGameInstanceWidget(
          letterGrid: widget.theirLetterGrid as LetterGrid,
          twoPlayerPlaySessionStateManager: TwoPlayerPlaySessionStateManager(
              twoPlayerState: this, theirLetterGrid: widget.theirLetterGrid),
          leftColumn: GameColumn.blankColumn,
          rightColumn: GameColumn.twoPlayerRightColumn);
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
    await Future<void>.delayed(Constants.celebrationDuration);
    if (!mounted) return;

    GoRouter.of(context).go('/freeplay/twoplayer', extra: {'score': score});
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
