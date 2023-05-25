import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_mode.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:lexpedition/src/user_interface/basic_user_interface_button.dart';
import 'package:provider/provider.dart';

class MoreMenu extends StatefulWidget {
  const MoreMenu({super.key});

  @override
  State<MoreMenu> createState() => _MoreMenuState();
}

class _MoreMenuState extends State<MoreMenu> {
  bool _showTutorialBox = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Constants.defaultBackground,
          SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('More Features',
                    style: TextStyle(fontSize: Constants.headerFontSize)),
                SizedBox(height: 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BasicUserInterfaceButton(
                      onPressed: () {
                        GoRouter.of(context).push('/buildpuzzle');
                      },
                      buttonText: 'Puzzle Builder',
                    ),
                    SizedBox(width: Constants.smallFont),
                    BasicUserInterfaceButton(
                      onPressed: () {
                        setState(() {
                          _showTutorialBox = true;
                        });
                      },
                      buttonText: 'Tutorial',
                    ),
                    SizedBox(width: Constants.smallFont),
                    BasicUserInterfaceButton(
                      onPressed: () => GoRouter.of(context).push('/settings'),
                      buttonText: 'Settings',
                    ),
                    SizedBox(width: Constants.smallFont),
                    BasicUserInterfaceButton(
                        onPressed: () => GoRouter.of(context).pop(),
                        buttonText: 'Back')
                  ],
                ),
              ],
            ),
          ),
          Visibility(
            visible: _showTutorialBox,
            child: Consumer<GameState>(builder: (context, gameState, child) {
              return AlertDialog(
                  content: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                    Text(
                      'Which tutorial will you play?',
                      style: TextStyle(fontSize: Constants.mediumFont),
                    ),
                    SizedBox(height: 24),
                    Row(children: [
                      BasicUserInterfaceButton(
                        buttonText: 'Full Tutorial',
                        onPressed: () {
                          gameState.updateGameMode(GameMode.FullTutorial);
                          GoRouter.of(context).push('/tutorial/full');
                        },
                      ),
                      SizedBox(width: 16),
                      BasicUserInterfaceButton(
                        buttonText: 'Quick Tutorial',
                        onPressed: () {
                          gameState.updateGameMode(GameMode.QuickTutorial);
                          GoRouter.of(context).push('/tutorial/quick');
                        },
                      )
                    ]),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      BasicUserInterfaceButton(
                        buttonText: 'Cancel',
                        onPressed: () {
                          setState(() {
                            _showTutorialBox = false;
                          });
                        },
                      ),
                    ])
                  ]));
            }),
          )
        ],
      ),
    );
  }
}
