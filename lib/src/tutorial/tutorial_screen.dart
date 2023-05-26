// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_level.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:lexpedition/src/tutorial/quick_tutorial_levels.dart';
import 'package:lexpedition/src/user_interface/basic_user_interface_button.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../player_progress/player_progress.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';
import 'package:lexpedition/src/tutorial/full_tutorial_levels.dart';

class TutorialScreen extends StatelessWidget {
  final String tutorialPath;

  TutorialScreen({super.key, required this.tutorialPath});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final playerProgress = context.watch<PlayerProgress>();

    return Consumer<GameState>(builder: (context, gameState, child) {
      List<GameLevel> chosenTutorialList =
          tutorialPath == 'full' ? fullTutorialLevels : quickTutorialLevels;

      return Scaffold(
        backgroundColor: palette.backgroundLevelSelection,
        body: ResponsiveScreen(
          squarishMainArea: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'Tutorial Levels',
                    style: TextStyle(fontSize: Constants.smallFont),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Expanded(
                child: ListView(
                  children: [
                    for (final level in chosenTutorialList)
                      ListTile(
                        enabled: shouldEnableLevel(
                            level.tutorialKey, playerProgress),
                        onTap: () {
                          final audioController =
                              context.read<AudioController>();
                          audioController.playSfx(SfxType.tapButton);

                          gameState.loadOnePlayerPuzzle(
                              tutorialKey: level.tutorialKey);

                          GoRouter.of(context).push(level.tutorialKey < 200
                              ? '/tutorial/quick/intro/${level.tutorialKey}'
                              : '/tutorial/full/intro/${level.tutorialKey}');
                        },
                        leading: Text(level.tutorialKey < 200
                            ? (level.tutorialKey - 100).toString()
                            : (level.tutorialKey - 200).toString()),
                        title: Text('${level.name}'),
                      )
                  ],
                ),
              ),
            ],
          ),
          rectangularMenuArea: BasicUserInterfaceButton(
            onPressed: () {
              GoRouter.of(context).push('/');
            },
            buttonText: 'Back',
          ),
        ),
      );
    });
  }

  bool shouldEnableLevel(int tutorialKey, PlayerProgress playerProgress) {
    if (tutorialKey == 101 || tutorialKey == 201) {
      return true;
    } else {
      return playerProgress.highestLevelReached >= tutorialKey - 1;
    }
  }
}
