import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:lexpedition/src/play_session/one_player_play_session_screen.dart';
import 'package:lexpedition/src/tutorial/tutorial_directive.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class TutorialGameInstance extends StatelessWidget {
  final String tutorialPath;

  TutorialGameInstance({super.key, required this.tutorialPath});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(builder: (context, gameState, child) {
      return Stack(
        fit: StackFit.expand,
        children: [
          OnePlayerPlaySessionScreen(
              winRoute: '/tutorial/' + tutorialPath + '/won'),
          Visibility(
            visible: gameState.currentTutorialStepExists(),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.8), BlendMode.srcOut),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        backgroundBlendMode: BlendMode.dstOut),
                  ),
                  for (TutorialDirective window in gameState
                      .getCurrentTutorialStep()
                      .tutorialWindows) ...[createMaskWindow(window, gameState)]
                ],
              ),
            ),
          ),
          for (TutorialDirective window
              in gameState.getCurrentTutorialStep().tutorialInstructions) ...[
            createTutorialTopLayer(window, gameState)
          ],
          IgnorePointer(
              ignoring: !gameState.getCurrentTutorialStep().fullScreenClick,
              child: GestureDetector(
                onTap: () {
                  gameState.incrementTutorialStep();
                },
                child: SizedBox.expand(
                  child: Container(color: Colors.white.withOpacity(0.0)),
                ),
              ))
        ],
      );
    });
  }

  Widget createMaskWindow(
      TutorialDirective tutorialWindow, GameState gameState) {
    if (tutorialWindow.windowType == TutorialDirectiveType.text) {
      return SizedBox.shrink();
    } else {
      return GestureDetector(
        onTap: () => tutorialWindow.handleTap(gameState),
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            margin: EdgeInsets.only(
                top: tutorialWindow.getTopAlignment(),
                left: tutorialWindow.getLeftAlignment()),
            height: tutorialWindow.getHeight(),
            width: tutorialWindow.getWidth(),
            decoration: BoxDecoration(
              color: Colors.red,
            ),
          ),
        ),
      );
    }
  }

  Widget createTutorialTopLayer(
      TutorialDirective tutorialWindow, GameState gameState) {
    if (tutorialWindow.windowType == TutorialDirectiveType.text) {
      return IgnorePointer(
          ignoring: tutorialWindow.ignorePointer,
          child: GestureDetector(
              onTap: () => tutorialWindow.handleTap(gameState),
              child: Container(
                  margin: EdgeInsets.only(
                      top: tutorialWindow.getTopAlignment(),
                      left: tutorialWindow.getLeftAlignment()),
                  child: Stack(
                    children: [
                      Text(
                          tutorialWindow
                              .getText(), //to put a black outline on the text
                          style: TextStyle(
                              fontSize: Constants.mediumFont,
                              decoration: TextDecoration.none,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 3
                                ..color = Colors.black)),
                      Text(tutorialWindow.getText(),
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 217, 104),
                              decoration: TextDecoration.none,
                              fontSize: Constants.mediumFont)),
                    ],
                  ))));
    } else {
      return IgnorePointer(
          ignoring: true,
          child: GestureDetector(
            onTap: () => tutorialWindow.handleTap(gameState),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(
                    top: tutorialWindow.getTopAlignment(),
                    left: tutorialWindow.getLeftAlignment()),
                height: tutorialWindow.getHeight(),
                width: tutorialWindow.getWidth(),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromARGB(255, 255, 176, 41),
                        width: 3,
                        style: BorderStyle.solid)),
              ),
            ),
          ));
    }
  }
}
