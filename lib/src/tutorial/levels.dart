import '../game_data/letter_grid.dart';

// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

var tutorialLevels = [
  TutorialLevel(
    name: 'Basic Tile',
    number: 1,
    difficulty: 5,
    letterGrid: new LetterGrid([
      't020',
      'c021',
      null,
      null,
      null,
      null,
      'a020',
      'o010',
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null
    ]),
    // TODO: When ready, change these achievement IDs.
    // You configure this in App Store Connect.
    achievementIdIOS: 'first_win',
    // You get this string when you configure an achievement in Play Console.
    achievementIdAndroid: 'NhkIwB69ejkMAOOLDb',
  ),
  TutorialLevel(
    name: 'Start Tile',
    number: 2,
    difficulty: 42,
    letterGrid: new LetterGrid([
      't020',
      'e110',
      null,
      null,
      null,
      null,
      'a020',
      'm110',
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null
    ]),
  ),
  TutorialLevel(
    name: 'End Tile',
    number: 3,
    difficulty: 100,
    letterGrid: new LetterGrid([
      'e210',
      't210',
      null,
      null,
      null,
      null,
      'a020',
      'r110',
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null
    ]),
    achievementIdIOS: 'finished',
    achievementIdAndroid: 'CdfIhE96aspNWLGSQg',
  ),
];

class TutorialLevel {
  final String name;

  final int number;

  final int difficulty;

  final LetterGrid letterGrid;

  /// The achievement to unlock when the level is finished, if any.
  final String? achievementIdIOS;

  final String? achievementIdAndroid;

  bool get awardsAchievement => achievementIdAndroid != null;

  const TutorialLevel({
    required this.name,
    required this.number,
    required this.difficulty,
    required this.letterGrid,
    this.achievementIdIOS,
    this.achievementIdAndroid,
  }) : assert(
            (achievementIdAndroid != null && achievementIdIOS != null) ||
                (achievementIdAndroid == null && achievementIdIOS == null),
            'Either both iOS and Android achievement ID must be provided, '
            'or none');
}
