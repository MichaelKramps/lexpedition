import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:lexpedition/src/play_session/one_player_play_session_screen.dart';
import 'package:lexpedition/src/tutorial/tutorial_window.dart';
import 'package:provider/provider.dart';

class TutorialGameInstance extends StatelessWidget {
  const TutorialGameInstance({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        OnePlayerPlaySessionScreen(winRoute: '/tutorial/won'),
        Consumer<GameState>(builder: (context, gameState, child) {
          return Visibility(
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
                  for (TutorialWindow window in gameState
                      .getCurrentTutorialStep()) ...[createMaskWindow(window, gameState)]
                ],
              ),
            ),
          );
        })
      ],
    );
  }

  createMaskWindow(TutorialWindow window, GameState gameState) {
    return GestureDetector(
      onTap: () => window.handleTap(gameState),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          margin: EdgeInsets.only(
              top: window.getTopAlignment(), left: window.getLeftAlignment()),
          height: window.getHeight(),
          width: window.getWidth(),
          decoration: BoxDecoration(
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
