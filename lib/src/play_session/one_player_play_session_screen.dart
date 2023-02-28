// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/game_data/game_column.dart';
import 'package:lexpedition/src/game_widgets/game_instance_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../ads/ads_controller.dart';
import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../games_services/score.dart';
import '../in_app_purchase/in_app_purchase.dart';
import '../game_data/levels.dart';
import '../player_progress/player_progress.dart';
import '../style/confetti.dart';
import '../style/palette.dart';

class OnePlayerPlaySessionScreen extends StatefulWidget {
  final GameLevel level;
  final String winRoute;

  const OnePlayerPlaySessionScreen(this.level, this.winRoute, {super.key});

  @override
  State<OnePlayerPlaySessionScreen> createState() =>
      _OnePlayerPlaySessionScreenState();
}

class _OnePlayerPlaySessionScreenState
    extends State<OnePlayerPlaySessionScreen> {
  bool _duringCelebration = false;

  late DateTime _startOfPlay;

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return IgnorePointer(
      ignoring: _duringCelebration,
      child: Scaffold(
        backgroundColor: palette.backgroundPlaySession,
        body: Stack(
          children: [
            GameInstanceWidget(
              letterGrid: new LetterGrid(
                  widget.level.gridCode, widget.level.difficulty),
              playerWon: _playerWon,
              leftColumn: GameColumn.blankColumn,
              rightColumn: GameColumn.onePlayerRightColumn,
            ),
            SizedBox.expand(
              child: Visibility(
                visible: _duringCelebration,
                child: IgnorePointer(
                  child: Confetti(
                    isStopped: !_duringCelebration,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _startOfPlay = DateTime.now();

    // Preload ad for the win screen.
    final adsRemoved =
        context.read<InAppPurchaseController?>()?.adRemoval.active ?? false;
    if (!adsRemoved) {
      final adsController = context.read<AdsController?>();
      adsController?.preloadAd();
    }
  }

  Future<void> _playerWon(int guesses, int par) async {
    final score = Score(
      guesses,
      widget.level.difficulty,
      DateTime.now().difference(_startOfPlay),
    );

    final playerProgress = context.read<PlayerProgress>();
    playerProgress.setLevelReached(widget.level.number);

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

    GoRouter.of(context).go(widget.winRoute, extra: {'score': score});
  }
}