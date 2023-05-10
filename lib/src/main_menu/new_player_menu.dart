import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/user_interface/basic_user_interface_button.dart';
import 'package:provider/provider.dart';

import '../player_progress/player_progress.dart';

class NewPlayerMenu extends StatefulWidget {
  const NewPlayerMenu({super.key});

  @override
  State<NewPlayerMenu> createState() => _NewPlayerMenuState();
}

class _NewPlayerMenuState extends State<NewPlayerMenu> {
  bool _showTutorialBox = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Constants.defaultBackground,
        Container(
          decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(Constants.backgroundImagePath),
              fit: BoxFit.cover),
        )),
        SizedBox.expand(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              )
            ],
          ),
        ),
        Visibility(
          visible: _showTutorialBox,
          child: AlertDialog(
              content: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                Text(
                  'Which Tutorial path will you take?',
                  style: TextStyle(fontSize: Constants.mediumFont),
                ),
                SizedBox(height: 24),
                Row(children: [
                  BasicUserInterfaceButton(
                    buttonText: 'Full Tutorial',
                    onPressed: () {
                      GoRouter.of(context).push('/tutorial/full');
                    },
                  ),
                  SizedBox(width: 16),
                  BasicUserInterfaceButton(
                    buttonText: 'Quick Tutorial',
                    onPressed: () {
                      GoRouter.of(context).push('/tutorial/quick');
                    },
                  )
                ]),
                Row(children: [
                  BasicUserInterfaceButton(
                    buttonText: 'Skip Tutorial',
                    onPressed: () {
                      final playerProgress = context.read<PlayerProgress>();
                      playerProgress.setLevelReached(299);
                      GoRouter.of(context).push('/');
                    },
                  ),
                  SizedBox(width: 16),
                  BasicUserInterfaceButton(
                    buttonText: 'Cancel',
                    onPressed: () {
                      setState(() {
                        _showTutorialBox = false;
                      });
                    },
                  ),
                ])
              ])),
        )
      ],
    );
  }
}
