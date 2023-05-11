import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/error_definitions.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:lexpedition/src/game_widgets/error_display_widget.dart';
import 'package:lexpedition/src/user_interface/basic_user_interface_button.dart';
import 'package:provider/provider.dart';

class FreePlay extends StatelessWidget {
  const FreePlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(builder: (context, gameState, child) {
      return Scaffold(
          body: Stack(
            children: [
              Constants.defaultBackground,
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Free Play', style: TextStyle(fontSize: Constants.headerFontSize)),
                  SizedBox(height: 48),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BasicUserInterfaceButton(
                          onPressed: () async {
                            await gameState.loadOnePlayerPuzzle();
                            if (gameState.errorDefinition == ErrorDefinition.noError) {
                              GoRouter.of(context).push('/freeplay/oneplayer');
                            }            
                          },
                          buttonText: 'Solo Puzzle'),
                      SizedBox(width: Constants.smallFont),
                      BasicUserInterfaceButton(
                          onPressed: () async {
                            await gameState.loadTwoPlayerPuzzle();
                            if (gameState.errorDefinition == ErrorDefinition.noError){
                              GoRouter.of(context).push('/freeplay/twoplayer');
                            }                   
                          },
                          buttonText: 'Cooperative Puzzle'),
                      SizedBox(width: Constants.smallFont),
                      BasicUserInterfaceButton(
                          onPressed: () => GoRouter.of(context).push('/'), buttonText: 'Back')
                    ],     
                  ),
                ],
              ), 
            GameStateErrorDisplay()
        ])
      );
    });
  }
}
