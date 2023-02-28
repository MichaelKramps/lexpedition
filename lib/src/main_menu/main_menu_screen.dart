// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lexpedition/src/player_progress/player_progress.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/tutorial/tutorial_levels.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../settings/settings.dart';
import '../style/palette.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final settingsController = context.watch<SettingsController>();
    final audioController = context.watch<AudioController>();
    final playerProgress = context.watch<PlayerProgress>();

    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Visibility(
              visible: playerProgress.highestLevelReached >= tutorialLevels.length,
              child: ElevatedButton(
                onPressed: () {
                  audioController.playSfx(SfxType.buttonTap);
                  GoRouter.of(context).go('/party');
                },
                child: const Text('2 player'),
              )),
            Visibility(
              visible: playerProgress.highestLevelReached >= tutorialLevels.length,
              child: ElevatedButton(
                onPressed: () {
                  audioController.playSfx(SfxType.buttonTap);
                  GoRouter.of(context).go('/lexpedition');
                },
                child: const Text('Lexpedition'),
              )),
            Visibility(
              visible: playerProgress.highestLevelReached >= tutorialLevels.length,
              child: ElevatedButton(
                onPressed: () {
                  audioController.playSfx(SfxType.buttonTap);
                  GoRouter.of(context).go('/freeplay');
                },
                child: const Text('Free Play'),
              )),
            Visibility(
              visible: playerProgress.highestLevelReached >= tutorialLevels.length,
              child: ElevatedButton(
                onPressed: () {
                  audioController.playSfx(SfxType.buttonTap);
                  GoRouter.of(context).go('/buildpuzzle');
                },
                child: const Text('Puzzle Builder'),
              ))
          ]),
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Visibility(
              visible: playerProgress.highestLevelReached >= tutorialLevels.length,
              child: ElevatedButton(
                onPressed: () {
                  audioController.playSfx(SfxType.buttonTap);
                  GoRouter.of(context).go('/leaderboards');
                },
                child: const Text('Leaderboards'),
              )
            ),
            ElevatedButton(
              onPressed: () {
                audioController.playSfx(SfxType.buttonTap);
                GoRouter.of(context).go('/tutorial');
              },
              child: const Text('Tutorial'),
            ),
            ElevatedButton(
              onPressed: () => GoRouter.of(context).push('/settings'),
              child: const Text('Settings'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: ValueListenableBuilder<bool>(
                valueListenable: settingsController.muted,
                builder: (context, muted, child) {
                  return IconButton(
                    onPressed: () => settingsController.toggleMuted(),
                    icon: Icon(muted ? Icons.volume_off : Icons.volume_up),
                  );
                },
              ),
          )])
        ],
      )
    );
  }
}
