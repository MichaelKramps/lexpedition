import 'package:lexpedition/src/game_data/game_level.dart';
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
          .withTopText(text: "The game board is a\n6x4 grid which can hold\nup to 24 letter tiles"),
        TutorialStep.fullScreenClick()
          .withInfoPanel()
          .withMiddleText(text: "The top of the board has several items\nthat we will learn about as you\nprogress through the tutorials"),
        TutorialStep.fullScreenClick()
          .withLetterGrid()
          .withTopText(text: "The grid is where you create words\nby selecting letter tiles"),
        TutorialStep()
          .withHighlightedTile(index: 9)
          .withTopText(text: "Tap on a tile to select it"),
        TutorialStep.fullScreenClick()
          .withAnswerBox()
          .withMiddleText(text: "The answer box shows your current guess"),
        TutorialStep()
          .withHighlightedTile(index: 15)
          .withDisabledAnswerBox()
          .withBottomText(text: "Now select the letter tile with the \"O\""),
        TutorialStep()
          .withHighlightedTile(index: 14)
          .withDisabledAnswerBox()
          .withBottomText(text: "Next select the letter tile with the \"A\""),
        TutorialStep()
          .withHighlightedTile(index: 8)
          .withDisabledAnswerBox()
          .withBottomText(text: "Finally, select the letter tile with the \"T\""),
        TutorialStep()
          .withDisabledAnswerBox()
          .withSubmit()
          .withMiddleText(text: 'Tap the submit button to submit your current guess')
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
        TutorialStep.fullScreenClick()
          .withTopText(text: "Take a look at the puzzle")
          .withGameBoard(),
        TutorialStep()
          .withHighlightedTile(index: 15)
          .withTopText(text: "To start, click on the \"T\""),
        TutorialStep()
          .withHighlightedTile(index: 9)
          .withTopText(text: "And now the \"R\""),
        TutorialStep.fullScreenClick()
          .withAnswerBox()
          .withMiddleText(text: "After starting a guess, you may realize that you want to start over"),
        TutorialStep()
          .withMiddleText(text: "To clear your guess, click the \"Clear\" button")
          .withDisabledAnswerBox()
          .withClear(),
        TutorialStep.fullScreenClick()
          .withAnswerBox()
          .withMiddleText(text: "Notice that your answer has been cleared from the answer box"),
        TutorialStep.fullScreenClick()
          .withMiddleText(text: "Now enter the word \"TEAR\" and tap the \"Submit\" button")
      ]),
      GameLevel(
      name: "Letter Selection Choices",
      averageGuesses: 3,
      bestAttempt: 3,
      tutorialKey: 203,
      gridCode: [
        't010',
        'o010',
        null,
        null,
        'r010',
        'e010',
        'n010',
        'e010',
        null,
        null,
        'b010',
        'a010',
        null,
        null,
        'v010',
        'e010',
        null,
        null,
        null,
        null,
        'a010',
        's010',
        null,
        null
      ],
      tutorialSteps: [
        TutorialStep.fullScreenClick()
          .withGameBoard()
          .withTopText(text: 'There are rules regarding which tiles can be selected at a given time'),
        TutorialStep.fullScreenClick()
          .withTile(index: 0)
          .withTile(index: 1)
          .withTile(index: 4)
          .withTile(index: 5)
          .withTile(index: 6)
          .withTile(index: 7)
          .withTile(index: 10)
          .withTile(index: 11)
          .withTile(index: 14)
          .withTile(index: 15)
          .withTile(index: 20)
          .withTile(index: 21)
          .withTopText(text: 'When starting a new guess, you may select any letter'),
        TutorialStep()
          .withHighlightedTile(index: 0)
          .withBottomText(text: 'Select the "T"'),
        TutorialStep.fullScreenClick()
          .withTile(index: 1)
          .withTile(index: 6)
          .withTile(index: 7)
          .withBottomText(text: 'After selecting a letter, next you may select any letter touching it'),
        TutorialStep.fullScreenClick()
          .withTile(index: 4)
          .withTile(index: 5)
          .withTile(index: 10)
          .withTile(index: 11)
          .withTile(index: 14)
          .withTile(index: 15)
          .withTile(index: 20)
          .withTile(index: 21)
          .withTopText(text: 'Which means none of these letters can be selected'),
        TutorialStep()
          .withHighlightedTile(index: 1)
          .withBottomText(text: 'Now go ahead and select the "O"'),
        TutorialStep.fullScreenClick()
          .withAnswerBox()
          .withTile(index: 0)
          .withTile(index: 1)
          .withTile(index: 6)
          .withTile(index: 7)
          .withBottomText(text: 'You may see the word "TOTE" but letters can only be selected once per guess'),
        TutorialStep()
          .withHighlightedTile(index: 6)
          .withAnswerBox()
          .withBottomText(text: 'So go ahead and select the "N"'),
        TutorialStep()
          .withHighlightedTile(index: 7)
          .withAnswerBox()
          .withBottomText(text: 'And the "E"'),
        TutorialStep()
          .withAnswerBox()
          .withSubmit()
          .withMiddleText(text: 'And submit the guess'),
        TutorialStep.fullScreenClick()
          .withMiddleText(text: 'Great! Now find words using the letters that we haven\'t used yet and finish the level.')
      ]
      ),
      GameLevel(
      name: "Diagonal Selections",
      averageGuesses: 3,
      bestAttempt: 3,
      tutorialKey: 204,
      gridCode: [
        null,
        null,
        'w010',
        null,
        'd010',
        null,
        null,
        'o010',
        null,
        'e010',
        null,
        'm010',
        'w010',
        null,
        'e010',
        null,
        'o010',
        null,
        null,
        'd010',
        null,
        'm010',
        null,
        null
      ],
      tutorialSteps: [
        TutorialStep.fullScreenClick()
          .withGameBoard()
          .withTopText(text: 'Letters may look like they don\'t touch, but they actually do'),
        TutorialStep.fullScreenClick()
          .withTile(index: 2)
          .withTile(index: 7)
          .withTile(index: 12)
          .withTopText(text: 'You can make the word "WOW" here'),
        TutorialStep.fullScreenClick()
          .withTile(index: 4)
          .withTile(index: 9)
          .withTile(index: 14)
          .withTile(index: 19)
          .withTopText(text: 'And here is "DEED"'),
        TutorialStep.fullScreenClick()
          .withTile(index: 11)
          .withTile(index: 16)
          .withTile(index: 21)
          .withTopText(text: 'And "MOM"'),
        TutorialStep.fullScreenClick()
          .withGameBoard()
          .withMiddleText(text: 'Now go ahead and finish this tricky puzzle')
      ]
      ),
  GameLevel(
      name: "Check Point #1",
      averageGuesses: 5,
      bestAttempt: 4,
      tutorialKey: 205,
      gridCode: [
        'f010',
        'a010',
        null,
        'b010',
        'i010',
        'g010',
        'r010',
        'e010',
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        'a010',
        'e010',
        'b010',
        'e010',
        't010',
        null,
        'g010',
        'm010'
      ]),
      GameLevel(
      name: "Multiple Uses",
      averageGuesses: 4,
      bestAttempt: 4,
      tutorialKey: 206,
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
        'a030',
        null,
        null,
        null,
        null,
        'e020',
        'r010',
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
          .withTile(index: 8)
          .withTile(index: 9)
          .withTile(index: 14)
          .withTile(index: 15)
          .withTopText(text: 'Letters have boxes under them to indicate how many times they must be used to complete the puzzle'),
        TutorialStep.fullScreenClick()
          .withTile(index: 9)
          .withTopText(text: 'This tile must be used in three different words'),
        TutorialStep.fullScreenClick()
          .withTile(index: 15)
          .withTopText(text: 'While this one must be used in only one word'),
        TutorialStep()
          .withHighlightedTile(index: 8)
          .withTopText(text: 'Tap the "B"'),
        TutorialStep()
          .withHighlightedTile(index: 14)
          .withTopText(text: 'Now the "E"'),
        TutorialStep()
          .withHighlightedTile(index: 9)
          .withTopText(text: 'The "A"'),
        TutorialStep()
          .withHighlightedTile(index: 15)
          .withTopText(text: 'Finally the "R"'),
        TutorialStep()
          .withDisabledAnswerBox()
          .withSubmit()
          .withMiddleText(text: 'And submit your answer'),
        TutorialStep.fullScreenClick()
          .withTile(index: 8)
          .withTile(index: 9)
          .withTile(index: 14)
          .withTile(index: 15)
          .withTopText(text: 'A green box means a letter was successfully used, and a black box means you still need to use the letter again'),
        TutorialStep.fullScreenClick()
          .withMiddleText(text: 'Now find some more words to finish this puzzle')
      ]
      ),
      GameLevel(
      name: "Start Letters",
      averageGuesses: 4,
      bestAttempt: 4,
      tutorialKey: 207,
      gridCode: [
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        'a110',
        'c110',
        null,
        null,
        null,
        null,
        't110',
        'r110',
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
          .withLetterGrid()
          .withTopText(text: 'These letters are different. Their boxes will only turn green if they are used at the beginning of a word.'),
        TutorialStep()
          .withDisabledTile(index: 8)
          .withDisabledTile(index: 9)
          .withHighlightedTile(index: 14)
          .withDisabledTile(index: 15)
          .withTopText(text: 'Let\'s spell the word "TAR"'),
        TutorialStep()
          .withHighlightedTile(index: 8)
          .withDisabledTile(index: 9)
          .withDisabledTile(index: 14)
          .withDisabledTile(index: 15)
          .withTopText(text: 'Now tap the "A"'),
        TutorialStep()
          .withDisabledTile(index: 8)
          .withDisabledTile(index: 9)
          .withDisabledTile(index: 14)
          .withHighlightedTile(index: 15)
          .withTopText(text: 'Now "R"'),
        TutorialStep.fullScreenClick()
          .withTile(index: 8)
          .withTile(index: 9)
          .withTile(index: 14)
          .withTile(index: 15)
          .withTopText(text: 'Notice the "A" and "R" have a red select color, while the "T" has a green select color'),
        TutorialStep()
          .withDisabledAnswerBox()
          .withSubmit()
          .withMiddleText(text: 'Now submit the guess'),
        TutorialStep.fullScreenClick()
          .withTile(index: 8)
          .withTile(index: 9)
          .withTile(index: 14)
          .withTile(index: 15)
          .withTopText(text: 'Now notice that the "T" got a green box, but the "A" and "R" did not'),
        TutorialStep.fullScreenClick()
          .withTile(index: 8)
          .withTile(index: 9)
          .withTile(index: 14)
          .withTile(index: 15)
          .withTopText(text: 'This is because start letters will only get a green box when used at the start of a word'),
        TutorialStep.fullScreenClick()
          .withLetterGrid()
          .withTopText(text: 'Now find three more words, each starting with a different letter, to finish the puzzle')
      ]
      ),
      GameLevel(
      name: "End Letters",
      averageGuesses: 4,
      bestAttempt: 4,
      tutorialKey: 208,
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
        'a210',
        null,
        null,
        null,
        null,
        'r210',
        't210',
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
          .withLetterGrid()
          .withTopText(text: 'And here we have another new type of letter called "End Letters"'),
        TutorialStep()
          .withDisabledTile(index: 8)
          .withDisabledTile(index: 9)
          .withDisabledTile(index: 14)
          .withHighlightedTile(index: 15)
          .withTopText(text: 'Let\'s spell the word "TEA"'),
        TutorialStep()
          .withHighlightedTile(index: 8)
          .withDisabledTile(index: 9)
          .withDisabledTile(index: 14)
          .withDisabledTile(index: 15)
          .withTopText(text: 'Now tap the "E"'),
        TutorialStep()
          .withDisabledTile(index: 8)
          .withHighlightedTile(index: 9)
          .withDisabledTile(index: 14)
          .withDisabledTile(index: 15)
          .withTopText(text: 'And the "A"'),
        TutorialStep.fullScreenClick()
          .withDisabledTile(index: 8)
          .withDisabledTile(index: 9)
          .withDisabledTile(index: 14)
          .withDisabledTile(index: 15)
          .withTopText(text: 'Again, notice the "T" and "E" have a red select color, indicating they will not get a green box with this guess'),
        TutorialStep()
          .withDisabledAnswerBox()
          .withSubmit()
          .withMiddleText(text: 'Now submit your guess'),
        TutorialStep.fullScreenClick()
          .withTile(index: 8)
          .withTile(index: 9)
          .withTile(index: 14)
          .withTile(index: 15)
          .withTopText(text: 'As we expected, the "A" got a green box, but the "T" and "E" did not'),
        TutorialStep.fullScreenClick()
          .withDisabledTile(index: 8)
          .withDisabledTile(index: 9)
          .withDisabledTile(index: 14)
          .withDisabledTile(index: 15)
          .withTopText(text: 'This is of course because "End Letters" will only get a green box if used at the end of a word'),
        TutorialStep.fullScreenClick()
          .withMiddleText(text: 'Now find three more words, each ending with a different letter, to complete this puzzle')
      ]
      ),
      GameLevel(
      name: "The Three Letter Types",
      averageGuesses: 3,
      bestAttempt: 3,
      tutorialKey: 209,
      gridCode: [
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        'l110',
        'e220',
        null,
        null,
        null,
        null,
        'a030',
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
        TutorialStep.fullScreenClick()
          .withMiddleText(text: 'Now you\'ve seen all the letter types, so let\'s see them all together'),
        TutorialStep.fullScreenClick()
          .withLetterGrid()
          .withTopText(text: 'Here we have start, end and normal letters all in the same puzzle'),
        TutorialStep.fullScreenClick()
          .withDisabledTile(index: 8)
          .withDisabledTile(index: 9)
          .withDisabledTile(index: 14)
          .withDisabledTile(index: 15)
          .withTopText(text: 'The "L" is a start letter, the "E" is an end letter, and the "A" and "T" are normal letters'),
        TutorialStep()
          .withDisabledTile(index: 8)
          .withDisabledTile(index: 9)
          .withDisabledTile(index: 14)
          .withHighlightedTile(index: 15)
          .withTopText(text: 'Let\'s spell "TALE"'),
        TutorialStep()
          .withDisabledTile(index: 8)
          .withDisabledTile(index: 9)
          .withHighlightedTile(index: 14)
          .withDisabledTile(index: 15)
          .withTopText(text: 'Tap the "A" and keep an eye on the selection colors'),
        TutorialStep()
          .withHighlightedTile(index: 8)
          .withDisabledTile(index: 9)
          .withDisabledTile(index: 14)
          .withDisabledTile(index: 15)
          .withTopText(text: 'Now the "L"'),
        TutorialStep()
          .withDisabledTile(index: 8)
          .withHighlightedTile(index: 9)
          .withDisabledTile(index: 14)
          .withDisabledTile(index: 15)
          .withTopText(text: 'And the "E"'),
        TutorialStep.fullScreenClick()
          .withDisabledTile(index: 8)
          .withDisabledTile(index: 9)
          .withDisabledTile(index: 14)
          .withDisabledTile(index: 15)
          .withTopText(text: 'So it looks like only the "L" will not get a green box here'),
        TutorialStep()
          .withAnswerBox()
          .withSubmit()
          .withMiddleText(text: 'Go ahead and submit the guess'),
        TutorialStep.fullScreenClick()
          .withDisabledTile(index: 8)
          .withDisabledTile(index: 9)
          .withDisabledTile(index: 14)
          .withDisabledTile(index: 15)
          .withTopText(text: 'Just what we expected'),
        TutorialStep.fullScreenClick()
          .withMiddleText(text: 'Now find more words to complete the puzzle. The selection colors will help guide you.')
      ]
      ),
      GameLevel(
      name: "Check Point #2",
      averageGuesses: 7,
      bestAttempt: 6,
      tutorialKey: 210,
      gridCode: [
        'r210',
        'u010',
        null,
        'n210',
        'i010',
        'f110',
        'p110',
        'o010',
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        'l020',
        'e210',
        'n110',
        'o020',
        't210',
        null,
        'i010',
        'm010'
      ]),
      GameLevel(
      name: "Multiple Charges",
      averageGuesses: 3,
      bestAttempt: 3,
      tutorialKey: 211,
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
];
