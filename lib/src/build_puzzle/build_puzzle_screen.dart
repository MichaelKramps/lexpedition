import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/user_interface/basic_user_interface_button.dart';

class BuildPuzzleScreen extends StatelessWidget {
  const BuildPuzzleScreen({super.key});

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
                Text('Build a Puzzle', style: TextStyle(fontSize: Constants.headerFontSize)),
                SizedBox(height: 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BasicUserInterfaceButton(
                        onPressed: () =>
                            GoRouter.of(context).push('/buildpuzzle/1player'),
                        buttonText: 'Build Solo Puzzle'),
                    SizedBox(width: Constants.smallFont),
                    BasicUserInterfaceButton(
                        onPressed: () =>
                            GoRouter.of(context).push('/buildpuzzle/2player'),
                        buttonText: 'Build Cooperative Puzzle'),
                    SizedBox(width: Constants.smallFont),
                    BasicUserInterfaceButton(
                          onPressed: () => GoRouter.of(context).pop(),
                          buttonText: 'Back')
                  ]
                ),
              ],
            )
          ),
        ],
      )
    );
  }
}
