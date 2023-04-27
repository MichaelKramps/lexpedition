// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/main_menu/new_player_menu.dart';
import 'package:lexpedition/src/main_menu/tutorial_complete_player_menu.dart';
import 'package:lexpedition/src/player_progress/player_progress.dart';
import 'package:lexpedition/src/tutorial/tutorial_levels.dart';
import 'package:provider/provider.dart';

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
    if (!Constants().initialized) {
      Constants.initialize(context: context);
    }
    final palette = context.watch<Palette>();
    //final settingsController = context.watch<SettingsController>();
    //final audioController = context.watch<AudioController>();
    final playerProgress = context.watch<PlayerProgress>();

    return Scaffold(
        backgroundColor: palette.backgroundMain,
        body: determineCorrectMenuToUse(playerProgress));
  }

  Widget determineCorrectMenuToUse(PlayerProgress playerProgress) {
    if (playerProgress.highestLevelReached >= tutorialLevels.length) {
      return TutorialCompletePlayerMenu();
    } else {
      return NewPlayerMenu();
    }
  }
}
