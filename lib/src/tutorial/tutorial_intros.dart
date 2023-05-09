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
            'Use touching letters to make words. Words must be at least 3 letters long. Charge all the letters to beat the level!';
        break;
      case 102:
        text =
            'To charge a letter, it may need to be used multiple times! The dots on the tile indicate the required number of uses!';
        break;
      case 103:
        text =
            'To charge a start letter, use them at the beginning of a word!';
        break;
      case 104:
        text = 'To charge end letters, use them at the end of a word!';
        break;
      case 105:
        text = 'Now try a level using all three types of letters!';
        break;
      case 106:
        // need more complicated widget
        return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text(
              'When you make a word of 5+ letters, a blast will fire from the last letter in the word. The blast charges letter tiles!',
              style: textStyle),
          RotatedBox(
            quarterTurns: 1, 
            child: Image.asset(Constants.blastImage, height: Constants().tileSize(), width: Constants().tileSize(),)),
          Text('Click on the blast direction indicator to change the direction of the blast!',
              style: textStyle)
        ]);
      case 107:
        text = 'Blocked letters can be cleared with the magic blast!';
        break;
      case 201:
        text =
            'Let\'s learn the basics of the board and how to select letters and submit answers.';
        break;
      case 202:
        text =
            'Now let\'s learn how to clear a guess if you select the wrong letters.';
        break;
      case 203:
        text =
            'Now we will see which letters can be selected during a guess.';
        break;
      case 204:
        text =
            'Sometimes letters CAN be selected when it may look like they cannot be selected.';
        break;
      case 205:
        text =
            'Now complete a puzzle on your own.';
        break;
      case 206:
        text =
            'Letters may need to be used more than once to complete a puzzle.';
        break;
      case 207:
        text =
            'Some letters are intended to be used at the beginning of a word.';
        break;
      case 208:
        text =
            'Other letters are intended to be used at the end of a word.';
        break;
      case 209:
        text =
            'More than one type of letter can be used in the same puzzle.';
        break;
      case 210:
        text =
            'Now complete a puzzle on your own that has all types of letters.';
        break;
      case 211:
        text =
            'Long words will grant you an extra benefit.';
        break;
      case 212:
        text =
            'The blast can be made to go vertically or horizontally.';
        break;
      case 213:
        text =
            'Letters can be blocked. They can\'t be used until they are unblocked.';
        break;
      case 214:
        text =
            'Now complete a puzzle that uses everything you have learned.';
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
