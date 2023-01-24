import '../game_data/letter_grid.dart';

// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

var tutorialLevels = [
  TutorialLevel(
    name: 'Basic Tile',
    number: 1,
    difficulty: 5,
    gridCode: [
      't020',
      'c020',
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
    ],
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
    gridCode: [
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
    ],
  ),
  TutorialLevel(
    name: 'End Tile',
    number: 3,
    difficulty: 100,
    gridCode: [
      'e210',
      't210',
      null,
      null,
      null,
      null,
      'a020',
      'r010',
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
    ],
    achievementIdIOS: 'finished',
    achievementIdAndroid: 'CdfIhE96aspNWLGSQg',
  ),
  TutorialLevel(
      name: 'All 3 Tile Types',
      number: 4,
      difficulty: 100,
      gridCode: [
        'e220',
        't210',
        's010',
        null,
        null,
        null,
        'a030',
        'r110',
        'o010',
        null,
        null,
        null,
        'l020',
        'p110',
        'd010',
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
  TutorialLevel(name: 'Energy Spray', number: 5, difficulty: 100, gridCode: [
    'e210',
    't010',
    's010',
    'z010',
    null,
    null,
    'a030',
    'r120',
    'r010',
    'n010',
    null,
    null,
    'l020',
    'p010',
    'd010',
    'u010',
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null
  ]),
  TutorialLevel(name: 'Statues', number: 6, difficulty: 100, gridCode: [
    'e210',
    't010',
    's011',
    'z010',
    null,
    null,
    'a030',
    'r121',
    'r010',
    'n010',
    null,
    null,
    'l020',
    'p010',
    'd010',
    'u010',
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null
  ]),
  TutorialLevel(name: 'Anti Magic', number: 7, difficulty: 100, gridCode: [
    'e210',
    't010',
    's010',
    'z010',
    null,
    null,
    'a030',
    'r121',
    'r010',
    'n010',
    null,
    null,
    'l020',
    'p010',
    'd010',
    'u010',
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null
  ]),
];

class TutorialLevel {
  final String name;

  final int number;

  final int difficulty;

  final List<String?> gridCode;

  /// The achievement to unlock when the level is finished, if any.
  final String? achievementIdIOS;

  final String? achievementIdAndroid;

  bool get awardsAchievement => achievementIdAndroid != null;

  const TutorialLevel({
    required this.name,
    required this.number,
    required this.difficulty,
    required this.gridCode,
    this.achievementIdIOS,
    this.achievementIdAndroid,
  }) : assert(
            (achievementIdAndroid != null && achievementIdIOS != null) ||
                (achievementIdAndroid == null && achievementIdIOS == null),
            'Either both iOS and Android achievement ID must be provided, '
            'or none');
}
