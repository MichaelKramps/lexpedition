// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:provider/provider.dart';

import '../ads/ads_controller.dart';
import '../ads/banner_ad_widget.dart';
import '../in_app_purchase/in_app_purchase.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';

class WinGameScreen extends StatelessWidget {
  final String continueRoute;

  const WinGameScreen({
    super.key,
    required this.continueRoute,
  });

  @override
  Widget build(BuildContext context) {
    final adsControllerAvailable = context.watch<AdsController?>() != null;
    final adsRemoved =
        context.watch<InAppPurchaseController?>()?.adRemoval.active ?? false;
    final palette = context.watch<Palette>();

    const gap = SizedBox(height: 10);

    return Consumer<GameState>(builder: (context, gameState, child) {
      return Scaffold(
        backgroundColor: palette.backgroundPlaySession,
        body: ResponsiveScreen(
          squarishMainArea: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (adsControllerAvailable && !adsRemoved) ...[
                const Expanded(
                  child: Center(
                    child: BannerAdWidget(),
                  ),
                ),
              ],
              gap,
              Center(
                child: Text(
                  'You won!',
                  style:
                      TextStyle(fontSize: Constants.bigFont),
                ),
              ),
              gap,
              Center(
                child: Text(
                  'Average Score: ${gameState.level.averageGuesses.round()}\n'
                  'Best Score: ${gameState.level.bestAttempt}\n'
                  'My Score: ${gameState.guessList.length}',
                  style: TextStyle(fontSize: Constants.smallFont),
                ),
              ),
            ],
          ),
          rectangularMenuArea: ElevatedButton(
            onPressed: () {
              GoRouter.of(context).push(continueRoute);
            },
            child: const Text('Continue'),
          ),
        ),
      );
    });
  }
}
