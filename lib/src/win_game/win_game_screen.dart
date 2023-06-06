// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/error_definitions.dart';
import 'package:lexpedition/src/game_data/game_mode.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:lexpedition/src/user_interface/basic_user_interface_button.dart';
import 'package:lexpedition/src/user_interface/featured_user_interface_button.dart';
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
        backgroundColor: palette.backgroundMain,
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
                  style: TextStyle(fontSize: Constants.bigFont),
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
          rectangularMenuArea: Row(
            children: [
              FeaturedUserInterfaceButton(
                onPressed: () async {
                  if (gameState.realTimeCommunication.isPartyLeader) {
                    switch (gameState.gameMode) {
                      case GameMode.OnePlayerFreePlay:
                        await gameState.loadOnePlayerPuzzle();
                        if (gameState.errorDefinition ==
                            ErrorDefinition.noError) {
                          GoRouter.of(context).push('/freeplay/oneplayer');
                        }
                        break;
                      case GameMode.TwoPlayerFreePlay:
                        await gameState.loadTwoPlayerPuzzle();
                        if (gameState.errorDefinition ==
                            ErrorDefinition.noError) {
                          GoRouter.of(context).push('/freeplay/twoplayer');
                        }
                        break;
                      case GameMode.OnePlayerLexpedition:
                        await gameState.loadOnePlayerLexpedition();
                        if (gameState.errorDefinition ==
                            ErrorDefinition.noError) {
                          GoRouter.of(context).push('/lexpedition/oneplayer');
                        }
                        break;
                      default:
                        GoRouter.of(context).push(continueRoute);
                    }
                  } else {
                    GoRouter.of(context).push(continueRoute);
                  }
                },
                buttonText: 'Continue',
              ),
              SizedBox(width: 8),
              BasicUserInterfaceButton(
                onPressed: () {
                  GoRouter.of(context).push('/');
                },
                buttonText: 'Quit',
              ),
            ],
          ),
        ),
      );
    });
  }
}
