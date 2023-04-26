import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/error_definitions.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:lexpedition/src/game_widgets/error_display_widget.dart';
import 'package:lexpedition/src/level_info/level_db_connection.dart';
import 'package:lexpedition/src/user_interface/basic_user_interface_button.dart';
import 'package:provider/provider.dart';

class FreePlay extends StatelessWidget {
  const FreePlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(builder: (context, gameState, child) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage ("assets/images/Freeplay Background.png"),
            fit: BoxFit.cover, 
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(100.0),
            child: SizedBox.expand(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BasicUserInterfaceButton(
                    onPressed: () {
                        GoRouter.of(context).push('/freeplay/oneplayer');
                      },
                    buttonText: 'Single Player',
                  ),
                  BasicUserInterfaceButton(
                    onPressed: () {
                        GoRouter.of(context).push('/freeplay/twoplayer');
                      },
                    buttonText: 'Two Player',
                  ),
                  BasicUserInterfaceButton(
                    onPressed: () {
                        GoRouter.of(context).pop();
                      },
                    buttonText: 'Back',
                  ),
                  GameStateErrorDisplay()
                ],
              )
            ),
          ),
        ),
      );
    });
  }
}
