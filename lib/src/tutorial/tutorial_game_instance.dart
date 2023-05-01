import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:lexpedition/src/play_session/one_player_play_session_screen.dart';
import 'package:lexpedition/src/tutorial/tutorial_window.dart';
import 'package:provider/provider.dart';

class TutorialGameInstance extends StatelessWidget {
  const TutorialGameInstance({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(builder: (context, gameState, child) {
      return Stack(
        fit: StackFit.expand,
        children: [
          OnePlayerPlaySessionScreen(winRoute: '/tutorial/won'),
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
                  for (TutorialWindow window
                      in gameState.getCurrentTutorialStep()) ...[
                    createMaskWindow(window, gameState)
                  ]
                ],
              ),
            ),
          ),
          for (TutorialWindow window
                      in gameState.getCurrentTutorialStep()) ...[
            createTutorialText(window)
          ]
        ],
      );
    });
  }

  Widget createMaskWindow(TutorialWindow tutorialWindow, GameState gameState) {
    if (tutorialWindow.windowType == TutorialWindowType.text) {
      return Container();
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

  Widget createTutorialText(TutorialWindow tutorialWindow) {
    if (tutorialWindow.windowType == TutorialWindowType.text) {
      return IgnorePointer(
        child: Text('hello', style: TextStyle(color: Colors.white, decoration: TextDecoration.none))
      );
    } else {
      return Container();
    }
  }
}
