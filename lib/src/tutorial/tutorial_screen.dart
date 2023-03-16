// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../player_progress/player_progress.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';
import 'tutorial_levels.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final playerProgress = context.watch<PlayerProgress>();

    return Consumer<GameState>(builder: (context, gameState, child) {
      return Scaffold(
        backgroundColor: palette.backgroundLevelSelection,
        body: ResponsiveScreen(
          squarishMainArea: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'Tutorial Levels',
                    style:
                        TextStyle(fontFamily: 'Permanent Marker', fontSize: 30),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Expanded(
                child: ListView(
                  children: [
                    for (final level in tutorialLevels)
                      ListTile(
                        enabled: playerProgress.highestLevelReached >=
                            level.tutorialNumber - 1,
                        onTap: () {
                          final audioController =
                              context.read<AudioController>();
                          audioController.playSfx(SfxType.buttonTap);

                          gameState.loadOnePlayerPuzzle(tutorialNumber: level.tutorialNumber - 1);

                          GoRouter.of(context)
                              .push('/tutorial/intro/${level.tutorialNumber}');
                        },
                        leading: Text(level.tutorialNumber.toString()),
                        title: Text('${level.name}'),
                      )
                  ],
                ),
              ),
            ],
          ),
          rectangularMenuArea: ElevatedButton(
            onPressed: () {
              GoRouter.of(context).pop();
            },
            child: const Text('Back'),
          ),
        ),
      );
    });
  }
}
