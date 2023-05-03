// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_level.dart';
import 'package:lexpedition/src/tutorial/full_tutorial_levels.dart';
import 'package:lexpedition/src/tutorial/quick_tutorial_levels.dart';
import 'package:provider/provider.dart';

import '../ads/ads_controller.dart';
import '../ads/banner_ad_widget.dart';
import '../in_app_purchase/in_app_purchase.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';

class TutorialIntroWidget extends StatelessWidget {
  final int levelNumber;
  final String tutorialPath;

  const TutorialIntroWidget({super.key, required this.levelNumber, required this.tutorialPath});

  @override
  Widget build(BuildContext context) {
    final adsControllerAvailable = context.watch<AdsController?>() != null;
    final adsRemoved =
        context.watch<InAppPurchaseController?>()?.adRemoval.active ?? false;
    final palette = context.watch<Palette>();

    const gap = SizedBox(height: 10);

    GameLevel level = levelNumber < 200
        ? quickTutorialLevels[levelNumber - 101]
        : fullTutorialLevels[levelNumber - 201];

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
                level.getName(),
                style: TextStyle(fontSize: Constants.bigFont),
              ),
            ),
            gap,
            Center(
              child: determineTutorialInfo(levelNumber),
            ),
          ],
        ),
        rectangularMenuArea: ElevatedButton(
          onPressed: () {
            GoRouter.of(context)
                .push('/tutorial/' + tutorialPath + '/session/' + levelNumber.toString());
          },
          child: const Text('Play'),
        ),
      ),
    );
  }

  Widget determineTutorialInfo(int levelNumber) {
    String text;

    TextStyle textStyle = TextStyle(fontSize: Constants.smallFont);

    switch (levelNumber) {
      case 101:
        text =
            'Use touching letter tiles to make words. Words must be at least 3 letters long. Charge all the letter tiles to beat the level!';
        break;
      case 102:
        text =
            'To charge a letter tile, it may need to be used multiple times! The dots on the tile indicate the required number of uses!';
        break;
      case 103:
        text =
            'To charge Green triangle tiles, use them at the beginning of a word!';
        break;
      case 104:
        text = 'To charge Red pentagon tiles, use them at the end of a word!';
        break;
      case 105:
        text = 'Now try a level using all three types of tiles!';
        break;
      case 106:
        // need more complicated widget
        return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text(
              'When you make a word of 5+ letters, a magic blast will fire from the last letter tile in the word. The magic blast can charge letter tiles!',
              style: textStyle),
          Image.asset('assets/images/staveup.png'),
          Text('Click on the stave to change the direction of the magic blast!',
              style: textStyle)
        ]);
      case 107:
        text = 'Clear obstacles from tiles using the magic blast!';
        break;
      case 201:
        text =
            'Let\'s learn the basics of the board and how to select letters and submit answers.';
        break;
      default:
        text = 'No intro text has been set for this level yet';
    }

    return Text(
      text,
      style: textStyle,
    );
  }
}
