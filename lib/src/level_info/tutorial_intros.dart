// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../ads/ads_controller.dart';
import '../ads/banner_ad_widget.dart';
import '../games_services/score.dart';
import '../in_app_purchase/in_app_purchase.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';

class TutorialIntroWidget extends StatelessWidget {
  final int level;
  final int par;

  const TutorialIntroWidget(
      {super.key, required this.level, required this.par});

  @override
  Widget build(BuildContext context) {
    final adsControllerAvailable = context.watch<AdsController?>() != null;
    final adsRemoved =
        context.watch<InAppPurchaseController?>()?.adRemoval.active ?? false;
    final palette = context.watch<Palette>();

    const gap = SizedBox(height: 10);

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
                'Level ' + level.toString() + ' -> Par ' + par.toString(),
                style: TextStyle(fontFamily: 'Permanent Marker', fontSize: 50),
              ),
            ),
            gap,
            Center(
              child: determineTutorialInfo(level),
            ),
          ],
        ),
        rectangularMenuArea: ElevatedButton(
          onPressed: () {
            GoRouter.of(context).go('/tutorial/session/' + level.toString());
          },
          child: const Text('Play'),
        ),
      ),
    );
  }

  Widget determineTutorialInfo(int level) {
    String text = 'Oops!';

    TextStyle textStyle = const TextStyle(fontSize: 20);

    if (level == 1) {
      text = 'Fully charge all the letter tiles to win the level!';
    } else if (level == 2) {
      text =
          'Green triangle tiles can only be charged if they are used at the beginning of a word!';
    } else if (level == 3) {
      text =
          'Red pentagon tiles can only be charged if they are used at the end of a word!';
    } else if (level == 4) {
      text = 'Now try a level using all three types of tiles!';
    } else if (level == 5) {
      // need more complicated widget
      return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Text(
            'When you make a word of 5+ letters, or fully charge 3+ tiles on the same word, a magic blast will fire from the last letter tile!',
            style: textStyle),
        Image.asset('assets/images/staveup.png'),
        Text('Click on the stave to change the direction of the magic blast!',
            style: textStyle),
        Text('Hint: "RUN", "URN", "PLATE", "PLATS" or "LATER"',
            style: textStyle)
      ]);
    } else if (level == 6) {
      text = 'Clear obstacles from tiles using the magic blast!';
    }

    return Text(
      text,
      style: textStyle,
    );
    ;
  }
}
