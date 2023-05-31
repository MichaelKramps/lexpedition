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
        null,
        't010',
        'a010',
        null,
        null,
        'c010',
        'o010',
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
          .withHighlightedTile(index: 13)
          .withTopText(text: "Tap on a tile to select it"),
        TutorialStep.fullScreenClick()
          .withAnswerBox()
          .withMiddleText(text: "The answer box shows your current guess"),
        TutorialStep()
          .withHighlightedTile(index: 14)
          .withDisabledAnswerBox()
          .withBottomText(text: "Now select the letter tile with the \"O\""),
        TutorialStep()
          .withHighlightedTile(index: 10)
          .withDisabledAnswerBox()
          .withBottomText(text: "Next select the letter tile with the \"A\""),
        TutorialStep()
          .withHighlightedTile(index: 9)
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
        null,
        'e010',
        'a010',
        null,
        null,
        'r010',
        't010',
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
      tutorialSteps: [
        TutorialStep.fullScreenClick()
          .withTopText(text: "Take a look at the puzzle")
          .withGameBoard(),
        TutorialStep()
          .withHighlightedTile(index: 14)
          .withTopText(text: "To start, click on the \"T\""),
        TutorialStep()
          .withHighlightedTile(index: 13)
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
        'n010',
        null,
        null,
        'o010',
        'e010',
        null,
        null,
        null,
        null,
        'v010',
        'a010',
        null,
        null,
        'e010',
        's010',
        'r010',
        'b010',
        null,
        null,
        'e010',
        'a010',
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
          .withTile(index: 10)
          .withTile(index: 11)
          .withTile(index: 14)
          .withTile(index: 15)
          .withTile(index: 16)
          .withTile(index: 17)
          .withTile(index: 20)
          .withTile(index: 21)
          .withTopText(text: 'When starting a new guess, you may select any letter'),
        TutorialStep()
          .withHighlightedTile(index: 0)
          .withBottomText(text: 'Select the "T"'),
        TutorialStep.fullScreenClick()
          .withTile(index: 1)
          .withTile(index: 4)
          .withTile(index: 5)
          .withBottomText(text: 'After selecting a letter, next you may select any letter touching it'),
        TutorialStep.fullScreenClick()
          .withTile(index: 10)
          .withTile(index: 11)
          .withTile(index: 14)
          .withTile(index: 15)
          .withTile(index: 16)
          .withTile(index: 17)
          .withTile(index: 20)
          .withTile(index: 21)
          .withTopText(text: 'Which means none of these letters can be selected'),
        TutorialStep()
          .withHighlightedTile(index: 4)
          .withBottomText(text: 'Now go ahead and select the "O"'),
        TutorialStep.fullScreenClick()
          .withAnswerBox()
          .withTile(index: 0)
          .withTile(index: 1)
          .withTile(index: 4)
          .withTile(index: 5)
          .withBottomText(text: 'You may see the word "TOTE" but letters can only be selected once per guess'),
        TutorialStep()
          .withHighlightedTile(index: 1)
          .withAnswerBox()
          .withBottomText(text: 'So go ahead and select the "N"'),
        TutorialStep()
          .withHighlightedTile(index: 5)
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
        null,
        'o010',
        null,
        'd010',
        'w010',
        null,
        'e010',
        null,
        null,
        'e010',
        null,
        'm010',
        'd010',
        null,
        'o010',
        null,
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
          .withTile(index: 5)
          .withTile(index: 8)
          .withTopText(text: 'You can make the word "WOW" here'),
        TutorialStep.fullScreenClick()
          .withTile(index: 7)
          .withTile(index: 10)
          .withTile(index: 13)
          .withTile(index: 16)
          .withTopText(text: 'And here is "DEED"'),
        TutorialStep.fullScreenClick()
          .withTile(index: 15)
          .withTile(index: 18)
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
        'r010',
        null,
        'b010',
        'a010',
        'e010',
        null,
        'e010',
        null,
        null,
        null,
        't010',
        'b010',
        null,
        null,
        null,
        'i010',
        null,
        'a010',
        'g010',
        'g010',
        null,
        'e010',
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
        null,
        'b020',
        'e020',
        null,
        null,
        'a030',
        'r010',
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
      tutorialSteps: [
        TutorialStep.fullScreenClick()
          .withTile(index: 9)
          .withTile(index: 13)
          .withTile(index: 10)
          .withTile(index: 14)
          .withTopText(text: 'Letters have boxes under them to indicate how many times they must be used to complete the puzzle'),
        TutorialStep.fullScreenClick()
          .withTile(index: 13)
          .withTopText(text: 'This tile must be used in three different words'),
        TutorialStep.fullScreenClick()
          .withTile(index: 14)
          .withTopText(text: 'While this one must be used in only one word'),
        TutorialStep()
          .withHighlightedTile(index: 9)
          .withTopText(text: 'Tap the "B"'),
        TutorialStep()
          .withHighlightedTile(index: 10)
          .withTopText(text: 'Now the "E"'),
        TutorialStep()
          .withHighlightedTile(index: 13)
          .withTopText(text: 'The "A"'),
        TutorialStep()
          .withHighlightedTile(index: 14)
          .withTopText(text: 'Finally the "R"'),
        TutorialStep()
          .withDisabledAnswerBox()
          .withSubmit()
          .withMiddleText(text: 'And submit your answer'),
        TutorialStep.fullScreenClick()
          .withTile(index: 9)
          .withTile(index: 13)
          .withTile(index: 10)
          .withTile(index: 14)
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
        null,
        'a110',
        't110',
        null,
        null,
        'c110',
        'r110',
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
      tutorialSteps: [
        TutorialStep.fullScreenClick()
          .withLetterGrid()
          .withTopText(text: 'These letters are different. Their boxes will only turn green if they are used at the beginning of a word.'),
        TutorialStep()
          .withDisabledTile(index: 9)
          .withDisabledTile(index: 13)
          .withHighlightedTile(index: 10)
          .withDisabledTile(index: 14)
          .withTopText(text: 'Let\'s spell the word "TAR"'),
        TutorialStep()
          .withHighlightedTile(index: 9)
          .withDisabledTile(index: 13)
          .withDisabledTile(index: 10)
          .withDisabledTile(index: 14)
          .withTopText(text: 'Now tap the "A"'),
        TutorialStep()
          .withDisabledTile(index: 9)
          .withDisabledTile(index: 13)
          .withDisabledTile(index: 10)
          .withHighlightedTile(index: 14)
          .withTopText(text: 'Now "R"'),
        TutorialStep.fullScreenClick()
          .withTile(index: 9)
          .withTile(index: 13)
          .withTile(index: 10)
          .withTile(index: 14)
          .withTopText(text: 'Notice the "A" and "R" have a red select color, while the "T" has a green select color'),
        TutorialStep()
          .withDisabledAnswerBox()
          .withSubmit()
          .withMiddleText(text: 'Now submit the guess'),
        TutorialStep.fullScreenClick()
          .withTile(index: 9)
          .withTile(index: 13)
          .withTile(index: 10)
          .withTile(index: 14)
          .withTopText(text: 'Now notice that the "T" had its black box turn green, but the "A" and "R" did not'),
        TutorialStep.fullScreenClick()
          .withTile(index: 9)
          .withTile(index: 13)
          .withTile(index: 10)
          .withTile(index: 14)
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
        null,
        'e210',
        'r210',
        null,
        null,
        'a210',
        't210',
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
      tutorialSteps: [
        TutorialStep.fullScreenClick()
          .withLetterGrid()
          .withTopText(text: 'And here we have another new type of letter called "End Letters"'),
        TutorialStep()
          .withDisabledTile(index: 9)
          .withDisabledTile(index: 13)
          .withDisabledTile(index: 10)
          .withHighlightedTile(index: 14)
          .withTopText(text: 'Let\'s spell the word "TEA"'),
        TutorialStep()
          .withHighlightedTile(index: 9)
          .withDisabledTile(index: 13)
          .withDisabledTile(index: 10)
          .withDisabledTile(index: 14)
          .withTopText(text: 'Now tap the "E"'),
        TutorialStep()
          .withDisabledTile(index: 9)
          .withHighlightedTile(index: 13)
          .withDisabledTile(index: 10)
          .withDisabledTile(index: 14)
          .withTopText(text: 'And the "A"'),
        TutorialStep.fullScreenClick()
          .withDisabledTile(index: 9)
          .withDisabledTile(index: 13)
          .withDisabledTile(index: 10)
          .withDisabledTile(index: 14)
          .withTopText(text: 'Again, notice the "T" and "E" have a red select color, indicating they will not get a green box with this guess'),
        TutorialStep()
          .withDisabledAnswerBox()
          .withSubmit()
          .withMiddleText(text: 'Now submit your guess'),
        TutorialStep.fullScreenClick()
          .withTile(index: 9)
          .withTile(index: 13)
          .withTile(index: 10)
          .withTile(index: 14)
          .withTopText(text: 'As we expected, the "A" got a green box, but the "T" and "E" did not'),
        TutorialStep.fullScreenClick()
          .withDisabledTile(index: 9)
          .withDisabledTile(index: 13)
          .withDisabledTile(index: 10)
          .withDisabledTile(index: 14)
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
        null,
        'l110',
        'a030',
        null,
        null,
        'e220',
        't010',
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
      tutorialSteps: [
        TutorialStep.fullScreenClick()
          .withMiddleText(text: 'Now you\'ve seen all the letter types, so let\'s see them all together'),
        TutorialStep.fullScreenClick()
          .withLetterGrid()
          .withTopText(text: 'Here we have start, end and normal letters all in the same puzzle'),
        TutorialStep.fullScreenClick()
          .withDisabledTile(index: 9)
          .withDisabledTile(index: 13)
          .withDisabledTile(index: 10)
          .withDisabledTile(index: 14)
          .withTopText(text: 'The "L" is a start letter, the "E" is an end letter, and the "A" and "T" are normal letters'),
        TutorialStep()
          .withDisabledTile(index: 9)
          .withDisabledTile(index: 13)
          .withDisabledTile(index: 10)
          .withHighlightedTile(index: 14)
          .withTopText(text: 'Let\'s spell "TALE"'),
        TutorialStep()
          .withDisabledTile(index: 9)
          .withDisabledTile(index: 13)
          .withHighlightedTile(index: 10)
          .withDisabledTile(index: 14)
          .withTopText(text: 'Tap the "A" and keep an eye on the selection colors'),
        TutorialStep()
          .withHighlightedTile(index: 9)
          .withDisabledTile(index: 13)
          .withDisabledTile(index: 10)
          .withDisabledTile(index: 14)
          .withTopText(text: 'Now the "L"'),
        TutorialStep()
          .withDisabledTile(index: 9)
          .withHighlightedTile(index: 13)
          .withDisabledTile(index: 10)
          .withDisabledTile(index: 14)
          .withTopText(text: 'And the "E"'),
        TutorialStep.fullScreenClick()
          .withDisabledTile(index: 9)
          .withDisabledTile(index: 13)
          .withDisabledTile(index: 10)
          .withDisabledTile(index: 14)
          .withTopText(text: 'So it looks like all the letters will get a green box here except "L"'),
        TutorialStep()
          .withAnswerBox()
          .withSubmit()
          .withMiddleText(text: 'Go ahead and submit the guess'),
        TutorialStep.fullScreenClick()
          .withDisabledTile(index: 9)
          .withDisabledTile(index: 13)
          .withDisabledTile(index: 10)
          .withDisabledTile(index: 14)
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
        'p110',
        null,
        'n110',
        'u010',
        'o010',
        null,
        'o020',
        null,
        null,
        null,
        't210',
        'n210',
        null,
        null,
        null,
        'i010',
        null,
        'l020',
        'i010',
        'f110',
        null,
        'e210',
        'm010'
      ]),
      GameLevel(
      name: "5+ Letter Words",
      averageGuesses: 2,
      bestAttempt: 2,
      tutorialKey: 211,
      gridCode: [
        'b110',
        null,
        null,
        'y010',
        'l010',
        null,
        null,
        'a010',
        'a010',
        null,
        null,
        'y010',
        's010',
        null,
        null,
        null,
        't210',
        'x210',
        'x110',
        'x010',
        null,
        null,
        null,
        null
      ],
      tutorialSteps: [
        TutorialStep.fullScreenClick()
          .withLetterGrid()
          .withTopText(text: 'If you make a word that is 5 or more letters long, a special charge will blast from the last letter in the word.'),
        TutorialStep()
          .withHighlightedTile(index: 0)
          .withMiddleText(text: 'Let\'s make the 5 letter word "BLAST"'),
        TutorialStep()
          .withHighlightedTile(index: 4)
          .withDisabledAnswerBox()
          .withMiddleText(text: 'Now tap the "L"'),
        TutorialStep()
          .withHighlightedTile(index: 8)
          .withDisabledAnswerBox()
          .withMiddleText(text: 'The "A"'),
        TutorialStep()
          .withHighlightedTile(index: 12)
          .withDisabledAnswerBox()
          .withMiddleText(text: 'The "S"'),
        TutorialStep()
          .withHighlightedTile(index: 16)
          .withDisabledAnswerBox()
          .withMiddleText(text: 'And the "T"'),
        TutorialStep.fullScreenClick()
          .withLetterGrid()
          .withTopText(text: 'Notice the 3 "X" letters that are currently highlighted, and all need to be used once'),
        TutorialStep()
          .withDisabledAnswerBox()
          .withSubmit()
          .withDisabledLetterGrid()
          .withMiddleText(text: 'Now submit your answer to see what happens'),
        TutorialStep.fullScreenClick()
          .withLetterGrid(),
        TutorialStep.fullScreenClick()
          .withMiddleText(text: 'The blast used the letters that were highlighted. They no longer need to be used.'),
        TutorialStep.fullScreenClick()
          .withMiddleText(text: 'Now finish up the level')
        
      ]
      ),
      GameLevel(
      name: "Blast Direction",
      averageGuesses: 2,
      bestAttempt: 2,
      tutorialKey: 212,
      gridCode: [
        't110',
        null,
        null,
        'e110',
        'r010',
        'a010',
        null,
        'r010',
        'e010',
        't210',
        null,
        'u010',
        null,
        null,
        null,
        'p010',
        'x110',
        null,
        null,
        't210',
        null,
        'x210',
        null,
        null
      ],
      tutorialSteps: [
        TutorialStep.fullScreenClick()
          .withDisabledLetterGrid()
          .withTopText(text: 'There is also a way to change the direction of the blast, which we will need to beat this level'),
        TutorialStep()
          .withHighlightedTile(index: 3)
          .withMiddleText(text: 'First, let\'s spell the word "ERUPT"'),
        TutorialStep()
          .withHighlightedTile(index: 7)
          .withDisabledAnswerBox()
          .withMiddleText(text: 'Now tap the "R"'),
        TutorialStep()
          .withHighlightedTile(index: 11)
          .withDisabledAnswerBox()
          .withMiddleText(text: 'The "U"'),
        TutorialStep()
          .withHighlightedTile(index: 15)
          .withDisabledAnswerBox()
          .withMiddleText(text: 'The "P"'),
        TutorialStep()
          .withHighlightedTile(index: 19)
          .withDisabledAnswerBox()
          .withMiddleText(text: 'And the "T"'),
        TutorialStep.fullScreenClick()
          .withDisabledLetterGrid()
          .withTopText(text: 'This answer should allow us to charge one of the "X" letters'),
        TutorialStep()
          .withDisabledLetterGrid()
          .withDisabledAnswerBox()
          .withSubmit(),
        TutorialStep.fullScreenClick()
          .withDisabledLetterGrid(),
        TutorialStep()
          .withHighlightedTile(index: 0)
          .withBottomText(text: 'Now, let\'s spell the word "TREAT"'),
        TutorialStep()
          .withHighlightedTile(index: 4)
          .withDisabledAnswerBox()
          .withBottomText(text: 'Now tap the "R"'),
        TutorialStep()
          .withHighlightedTile(index: 8)
          .withDisabledAnswerBox()
          .withBottomText(text: 'The "E"'),
        TutorialStep()
          .withHighlightedTile(index: 5)
          .withDisabledAnswerBox()
          .withBottomText(text: 'The "A"'),
        TutorialStep()
          .withHighlightedTile(index: 9)
          .withDisabledAnswerBox()
          .withBottomText(text: 'And the "T"'),
        TutorialStep.fullScreenClick()
          .withDisabledLetterGrid()
          .withTopText(text: 'Right now we aren\'t going to use the other "X"'),
        TutorialStep()
          .withBlastDirection()
          .withDisabledLetterGrid()
          .withBottomText(text: 'In order to hit it, we need to change the blast direction'),
        TutorialStep()
          .withDisabledLetterGrid()
          .withInfoPanel()
          .withSubmit()
          .withBottomText(text: 'That\'s better, now submit the answer')
      ]
      ),
      GameLevel(
      name: "Blocked Letters",
      averageGuesses: 2,
      bestAttempt: 2,
      tutorialKey: 213,
      gridCode: [
        null,
        null,
        null,
        'g110',
        null,
        null,
        null,
        'r010',
        null,
        null,
        null,
        'e010',
        null,
        null,
        null,
        'a010',
        'j111',
        'o011',
        'b211',
        't210',
        null,
        null,
        null,
        null
      ],
      tutorialSteps: [
        TutorialStep.fullScreenClick()
          .withDisabledLetterGrid()
          .withHighlightedTile(index: 16)
          .withHighlightedTile(index: 17)
          .withHighlightedTile(index: 18)
          .withTopText(text: 'Letters can be blocked'),
        TutorialStep.fullScreenClick()
          .withDisabledLetterGrid()
          .withMiddleText(text: 'While blocked, letters cannot be used in a guess'),
        TutorialStep.fullScreenClick()
          .withDisabledLetterGrid()
          .withBottomText(text: 'But they are unblocked when hit with a blast'),
        TutorialStep.fullScreenClick()
          .withMiddleText(text: 'So use the blast to unblock the three letters and finish the puzzle')
      ]
      ),
      GameLevel(
      name: "Final Check Point",
      averageGuesses: 3,
      bestAttempt: 3,
      tutorialKey: 214,
      gridCode: [
        't110',
        null,
        'q010',
        'p110',
        'r010',
        null,
        't210',
        'u010',
        'u010',
        null,
        'n010',
        'z010',
        's010',
        null,
        'e010',
        'z010',
        't220',
        null,
        'v010',
        'l011',
        'x010',
        null,
        'e110',
        'e210'
      ]),
];
