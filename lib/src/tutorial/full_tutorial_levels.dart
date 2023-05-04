import 'package:lexpedition/src/game_data/game_level.dart';
import 'package:lexpedition/src/tutorial/tutorial_directive.dart';
import 'package:lexpedition/src/tutorial/tutorial_step.dart';

var fullTutorialLevels = [
  GameLevel(
      name: "The Game Board",
      averageGuesses: 1,
      bestAttempt: 1,
      tutorialKey: 201,
      gridCode: [
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
        TutorialStep.fullScreenClick()
          .withGameBoard()
          .withText(text: "The game board is a\n6x4 grid which can hold\nup to 24 letter tiles"),
        TutorialStep.fullScreenClick()
          .withInfoPanel()
          .withText(text: "The top of the board has several items\nthat we will learn about as you\nprogress through the tutorials", position: TutorialTextPosition.middleLeft),
        TutorialStep.fullScreenClick()
          .withLetterGrid()
          .withText(text: "The grid is where you create words\nby selecting letter tiles"),
        TutorialStep()
          .withHighlightedTile(index: 9)
          .withText(text: "Tap on a tile to select it"),
        
        [
          TutorialDirective(windowType: TutorialDirectiveType.answerBox),
          TutorialDirective(
              windowType: TutorialDirectiveType.text,
              text: "The answer box shows your current guess",
              position: TutorialTextPosition.middle,
              ignorePointer: false)
        ],
        [
          TutorialDirective(
              windowType: TutorialDirectiveType.tile, tileIndex: 15),
          TutorialDirective(
              windowType: TutorialDirectiveType.answerBox,
              preventTapAction: true),
          TutorialDirective(
              windowType: TutorialDirectiveType.text,
              text: "Now select the letter tile with the \"O\"",
              position: TutorialTextPosition.bottomMiddle),
          TutorialDirective(
              windowType: TutorialDirectiveType.tileHighlight, tileIndex: 15)
        ],
        [
          TutorialDirective(
              windowType: TutorialDirectiveType.tile, tileIndex: 14),
          TutorialDirective(
              windowType: TutorialDirectiveType.answerBox,
              preventTapAction: true),
          TutorialDirective(
              windowType: TutorialDirectiveType.text,
              text: "Next select the letter tile with the \"A\"",
              position: TutorialTextPosition.bottomMiddle),
          TutorialDirective(
              windowType: TutorialDirectiveType.tileHighlight, tileIndex: 14)
        ],
        [
          TutorialDirective(
              windowType: TutorialDirectiveType.tile, tileIndex: 8),
          TutorialDirective(
              windowType: TutorialDirectiveType.answerBox,
              preventTapAction: true),
          TutorialDirective(
              windowType: TutorialDirectiveType.text,
              text: "Finally, select the letter tile with the \"T\"",
              position: TutorialTextPosition.bottomMiddle),
          TutorialDirective(
              windowType: TutorialDirectiveType.tileHighlight, tileIndex: 8)
        ],
        [
          TutorialDirective(windowType: TutorialDirectiveType.submit),
          TutorialDirective(
              windowType: TutorialDirectiveType.answerBox,
              preventTapAction: true),
          TutorialDirective(
              windowType: TutorialDirectiveType.text,
              text: 'Tap the submit button to submit your current guess',
              position: TutorialTextPosition.middle,
              ignorePointer: false)
        ],
      ]),
  GameLevel(
      name: "The Clear Button",
      averageGuesses: 1,
      bestAttempt: 1,
      tutorialKey: 202,
      gridCode: [
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        'e010',
        'r010',
        null,
        null,
        null,
        null,
        'a010',
        't010',
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
        [
          TutorialDirective(
              windowType: TutorialDirectiveType.text,
              text: "Take a look at the puzzle",
              ignorePointer: false),
          TutorialDirective(windowType: TutorialDirectiveType.gameBoard)
        ],
        [
          TutorialDirective(
              windowType: TutorialDirectiveType.text,
              text: "To start, click on the \"T\""),
          TutorialDirective(
              windowType: TutorialDirectiveType.tile, tileIndex: 15),
          TutorialDirective(
              windowType: TutorialDirectiveType.tileHighlight, tileIndex: 15)
        ],
        [
          TutorialDirective(
              windowType: TutorialDirectiveType.text,
              text: "And now the \"R\""),
          TutorialDirective(
              windowType: TutorialDirectiveType.tile, tileIndex: 9),
          TutorialDirective(
              windowType: TutorialDirectiveType.tileHighlight, tileIndex: 9)
        ],
        [
          TutorialDirective(
              windowType: TutorialDirectiveType.text,
              text:
                  "After starting a guess, you may realize that you want to start over",
              position: TutorialTextPosition.middleLeft,
              ignorePointer: false),
          TutorialDirective(windowType: TutorialDirectiveType.answerBox)
        ],
        [
          TutorialDirective(
              windowType: TutorialDirectiveType.text,
              text: "To clear your guess, click the \"Clear\" button",
              position: TutorialTextPosition.middleLeft),
          TutorialDirective(
              windowType: TutorialDirectiveType.answerBox,
              preventTapAction: true),
          TutorialDirective(windowType: TutorialDirectiveType.clear)
        ],
        [
          TutorialDirective(
              windowType: TutorialDirectiveType.text,
              text:
                  "Notice that your answer has been cleared from the answer box",
              position: TutorialTextPosition.middleLeft,
              ignorePointer: false),
          TutorialDirective(windowType: TutorialDirectiveType.answerBox)
        ],
        [
          TutorialDirective(
              windowType: TutorialDirectiveType.text,
              text: "Now enter the word \"TEAR\" and tap the \"Submit\" button",
              position: TutorialTextPosition.middleLeft,
              ignorePointer: false)
        ],
      ]),
  GameLevel(
      name: "Multiple Charges",
      averageGuesses: 3,
      bestAttempt: 3,
      tutorialKey: 203,
      gridCode: [
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
  GameLevel(
    name: "Start Tile",
    averageGuesses: 3,
    bestAttempt: 2,
    tutorialKey: 204,
    gridCode: [
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
  GameLevel(
      name: "End Tile",
      averageGuesses: 3,
      bestAttempt: 2,
      tutorialKey: 205,
      gridCode: [
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
  GameLevel(
      name: "All 3 Tile Types",
      averageGuesses: 5,
      bestAttempt: 3,
      tutorialKey: 205,
      gridCode: [
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
  GameLevel(
      name: "Magic Blast",
      averageGuesses: 2,
      bestAttempt: 2,
      tutorialKey: 206,
      gridCode: [
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
  GameLevel(
      name: "Obstacles",
      averageGuesses: 2,
      bestAttempt: 2,
      tutorialKey: 207,
      gridCode: [
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
