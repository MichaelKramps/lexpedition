import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/error_definitions.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:lexpedition/src/game_widgets/error_display_widget.dart';
import 'package:provider/provider.dart';

class FreePlay extends StatelessWidget {
  const FreePlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(builder: (context, gameState, child) {
      return Scaffold(
          body: Stack(
            children: [SizedBox.expand(
                  child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    await gameState.loadOnePlayerPuzzle();
                    if (gameState.errorDefinition == ErrorDefinition.noError) {
                      GoRouter.of(context).push('/freeplay/oneplayer');
                    }            
                  },
                  child: Text('One Player')),
              SizedBox(width: Constants.smallFont),
              ElevatedButton(
                  onPressed: () async {
                    await gameState.loadTwoPlayerPuzzle();
                    if (gameState.errorDefinition == ErrorDefinition.noError){
                      GoRouter.of(context).push('/freeplay/twoplayer');
                    }                   
                  },
                  child: Text('Two Player')),
              SizedBox(width: Constants.smallFont),
              ElevatedButton(
                  onPressed: () => GoRouter.of(context).push('/'), child: Text('Back'))
            ],     
          )), 
          GameStateErrorDisplay()
        ])
      );
    });
  }
}
