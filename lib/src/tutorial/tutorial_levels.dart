import 'package:lexpedition/src/game_data/game_level.dart';
import 'package:lexpedition/src/tutorial/tutorial_window.dart';

// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

var tutorialLevels = [
  GameLevel(name: "Basic Tile", averageGuesses: 2, bestAttempt: 1, tutorialNumber: 1, gridCode: [
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    't010',
    'c010',
    null,
    null,
    null,
    null,
    'a010',
    'o010',
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null
  ],
  tutorialSteps: [
    [TutorialWindow(windowType: TutorialWindowType.tile, tileIndex: 9), TutorialWindow(windowType: TutorialWindowType.text, text: "Tap on a tile to select it", position: TutorialTextPosition.bottomMiddle)],
    [TutorialWindow(windowType: TutorialWindowType.tile, tileIndex: 8), TutorialWindow(windowType: TutorialWindowType.tile, tileIndex: 14), TutorialWindow(windowType: TutorialWindowType.tile, tileIndex: 15), TutorialWindow(windowType: TutorialWindowType.text, text: "Now select any tile touching that tile", position: TutorialTextPosition.bottomMiddle)],
    [TutorialWindow(windowType: TutorialWindowType.answerBox), TutorialWindow(windowType: TutorialWindowType.text, text: "The answer box shows your current guess", position: TutorialTextPosition.middle)],
  ]
  ),
  GameLevel(name: "Multiple Charges", averageGuesses: 3, bestAttempt: 3, tutorialNumber: 2, gridCode: [
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    'b020',
    'r020',
    null,
    null,
    null,
    null,
    'a030',
    'e010',
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null
  ]),
  GameLevel(name: "Start Tile", averageGuesses: 3, bestAttempt: 2, tutorialNumber: 3, gridCode: [
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
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
      null
    ],
  ),
  GameLevel(name: "End Tile", averageGuesses: 3, bestAttempt: 2, tutorialNumber: 4, gridCode: [
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
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
    null
  ]),
  GameLevel(name: "All 3 Tile Types", averageGuesses: 5, bestAttempt: 3, tutorialNumber: 5, gridCode: [
    null,
    'e210',
    't220',
    's010',
    null,
    null,
    null,
    'a020',
    'r110',
    'o020',
    null,
    null,
    null,
    'l010',
    'p120',
    'd010',
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null
  ]),
  GameLevel(name: "Magic Blast", averageGuesses: 2, bestAttempt: 2, tutorialNumber: 6, gridCode: [
    't110',
    'r010',
    'e010',
    null,
    'x010',
    null,
    null,
    'a010',
    't010',
    null,
    null,
    'x010',
    null,
    null,
    null,
    null,
    null,
    null,
    'b110',
    'e010',
    'a010',
    's010',
    't210',
    null
  ]),
  GameLevel(name: "Obstacles", averageGuesses: 2, bestAttempt: 2, tutorialNumber: 7, gridCode: [
    null,
    null,
    null,
    null,
    'j111',
    null,
    null,
    null,
    null,
    null,
    'o011',
    null,
    null,
    null,
    null,
    null,
    'b211',
    null,
    'g110',
    'r010',
    'e010',
    'a010',
    't220',
    null
  ])
];

