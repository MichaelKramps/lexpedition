import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/user_interface/basic_user_interface_button.dart';

class MoreMenu extends StatelessWidget {
  const MoreMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body: SizedBox.expand(
        child: Row(
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
                GoRouter.of(context).push('/tutorial');
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
      )
    );
  }
}