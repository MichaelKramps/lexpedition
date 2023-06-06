// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_column.dart';
import 'package:lexpedition/src/game_data/game_mode.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:lexpedition/src/game_widgets/game_instance_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/level_info/level_db_connection.dart';
import 'package:provider/provider.dart';

import '../ads/ads_controller.dart';
import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../in_app_purchase/in_app_purchase.dart';
import '../player_progress/player_progress.dart';
import '../style/palette.dart';

class OnePlayerPlaySessionScreen extends StatefulWidget {
  final String winRoute;

  const OnePlayerPlaySessionScreen({required this.winRoute, super.key});

  @override
  State<OnePlayerPlaySessionScreen> createState() =>
      _OnePlayerPlaySessionScreenState();
}

class _OnePlayerPlaySessionScreenState
    extends State<OnePlayerPlaySessionScreen> {
  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return Consumer<GameState>(builder: (context, gameState, child) {
      if (gameState.levelCompleted && !gameState.celebrating) {
        _playerWon(gameState);
      }
      return IgnorePointer(
          ignoring: gameState.celebrating,
          child: Scaffold(
              backgroundColor: palette.backgroundMain,
              body: determineAnimatedGameBoard(gameState)));
    });
  }

  Widget determineAnimatedGameBoard(GameState gameState) {
    if (gameState.celebrating) {
      return getBaseGameBoard(gameState).animate().color(
          end: Colors.green, duration: Constants.celebrationAnimationDuration);
    } else {
      return getBaseGameBoard(gameState);
    }
  }

  Widget getBaseGameBoard(GameState gameState) {
    return GameInstanceWidget(
      gameState: gameState,
      leftColumn: GameColumn.onePlayerLeftColumn,
      rightColumn: GameColumn.onePlayerRightColumn,
    );
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Preload ad for the win screen.
    final adsRemoved =
        context.read<InAppPurchaseController?>()?.adRemoval.active ?? false;
    if (!adsRemoved) {
      final adsController = context.read<AdsController?>();
      adsController?.preloadAd();
    }
  }

  Future<void> _playerWon(GameState gameState) async {
    await Future<void>.delayed(Constants.preCelebrationDuration);
    gameState.completeLevel();
    gameState.celebrating = true;

    if (gameState.level.puzzleId != null) {
      if (gameState.gameMode == GameMode.OnePlayerFreePlay) {
        LevelDatabaseConnection.logOnePlayerFinishedPuzzleResults(
            gameState.level.puzzleId as int, gameState.guessList.length);
      } else if (gameState.gameMode == GameMode.OnePlayerLexpedition) {
        LevelDatabaseConnection.logOnePlayerFinishedLexpeditionResults(
            gameState.level.puzzleId as int, gameState.guessList.length);
      }
    }

    final playerProgress = context.read<PlayerProgress>();
    playerProgress.setLevelReached(gameState.level.tutorialKey);

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
    await Future<void>.delayed(Constants.celebrationDuration);
    if (!mounted) return;

    GoRouter.of(context).push(widget.winRoute);
  }
}
