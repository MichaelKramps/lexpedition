import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/user_interface/basic_user_interface_button.dart';
import 'package:lexpedition/src/user_interface/featured_user_interface_button.dart';

class NewPlayerMenu extends StatelessWidget {
  const NewPlayerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Row(
        children: [
          FeaturedUserInterfaceButton(
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
        ],
      ),
    );
  }
}