import 'package:lexpedition/src/tutorial/tutorial_directive.dart';

class TutorialStep {
  bool fullScreenClick = false;
  List<TutorialDirective> tutorialWindows = [];
  List<TutorialDirective> tutorialInstructions = [];

  TutorialStep();

  TutorialStep.fullScreenClick({this.fullScreenClick = true});

  TutorialStep withText(
      {required String text,
      TutorialTextPosition position = TutorialTextPosition.topLeft}) {
    tutorialInstructions.add(TutorialDirective(
        windowType: TutorialDirectiveType.text,
        text: text,
        position: position));
    return this;
  }

  TutorialStep withHighlightedTile({required int index}) {
    tutorialWindows.add(TutorialDirective(
        windowType: TutorialDirectiveType.tile, tileIndex: index));
    tutorialInstructions.add(TutorialDirective(
        windowType: TutorialDirectiveType.tileHighlight, tileIndex: index));
    return this;
  }

  TutorialStep withTile({required int index}) {
    tutorialWindows.add(TutorialDirective(
        windowType: TutorialDirectiveType.tile, tileIndex: index));
    return this;
  }

  TutorialStep withSubmit() {
    tutorialWindows
        .add(TutorialDirective(windowType: TutorialDirectiveType.submit));
    return this;
  }

  TutorialStep withClear() {
    tutorialWindows
        .add(TutorialDirective(windowType: TutorialDirectiveType.clear));
    return this;
  }

  TutorialStep withBlastDirection() {
    tutorialWindows.add(
        TutorialDirective(windowType: TutorialDirectiveType.blastDirection));
    return this;
  }

  TutorialStep withAnswerBox() {
    tutorialWindows
        .add(TutorialDirective(windowType: TutorialDirectiveType.answerBox));
    return this;
  }

  TutorialStep withGameBoard() {
    tutorialWindows
        .add(TutorialDirective(windowType: TutorialDirectiveType.gameBoard));
    return this;
  }

  TutorialStep withInfoPanel() {
    tutorialWindows
        .add(TutorialDirective(windowType: TutorialDirectiveType.infoPanel));
    return this;
  }

  TutorialStep withLetterGrid() {
    tutorialWindows
        .add(TutorialDirective(windowType: TutorialDirectiveType.letterGrid));
    return this;
  }
}
