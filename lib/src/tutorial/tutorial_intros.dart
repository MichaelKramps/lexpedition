// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/game_level.dart';
import 'package:lexpedition/src/tutorial/tutorial_levels.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../ads/ads_controller.dart';
import '../ads/banner_ad_widget.dart';
import '../in_app_purchase/in_app_purchase.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';

class TutorialIntroWidget extends StatelessWidget {
  final int levelNumber;

  const TutorialIntroWidget({super.key, required this.levelNumber});

  @override
  Widget build(BuildContext context) {
    final adsControllerAvailable = context.watch<AdsController?>() != null;
    final adsRemoved =
        context.watch<InAppPurchaseController?>()?.adRemoval.active ?? false;
    final palette = context.watch<Palette>();

    const gap = SizedBox(height: 10);

    GameLevel level = tutorialLevels[levelNumber - 1];

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
                style: TextStyle(fontFamily: 'Permanent Marker', fontSize: 50),
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
                .push('/tutorial/session/' + levelNumber.toString());
          },
          child: const Text('Play'),
        ),
      ),
    );
  }

  Widget determineTutorialInfo(int levelNumber) {
    String text = 'Oops!';

    TextStyle textStyle = const TextStyle(fontSize: 20);

    if (levelNumber == 1) {
      text =
          'Use touching letter tiles to make words. Words must be at least 3 letters long. Charge all the letter tiles to beat the level!';
    } else if (levelNumber == 2) {
      text =
          'To charge a letter tile, it may need to be used multiple times! The dots on the tile indicate the required number of uses!';
    } else if (levelNumber == 3) {
      text =
          'To charge Green triangle tiles, use them at the beginning of a word!';
    } else if (levelNumber == 4) {
      text = 'To charge Red pentagon tiles, use them at the end of a word!';
    } else if (levelNumber == 5) {
      text = 'Now try a level using all three types of tiles!';
    } else if (levelNumber == 6) {
      // need more complicated widget
      return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Text(
            'When you make a word of 5+ letters, a magic blast will fire from the last letter tile in the word. The magic blast can charge letter tiles!',
            style: textStyle),
        Image.asset('assets/images/staveup.png'),
        Text('Click on the stave to change the direction of the magic blast!',
            style: textStyle)
      ]);
    } else if (levelNumber == 7) {
      text = 'Clear obstacles from tiles using the magic blast!';
    }

    return Text(
      text,
      style: textStyle,
    );
  }
}
