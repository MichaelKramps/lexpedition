import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/constants.dart';

class NewPlayerMenu extends StatelessWidget {
  const NewPlayerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () {
              GoRouter.of(context).push('/tutorial');
            },
            child: const Text('Tutorial'),
          ),
          SizedBox(width: Constants.smallFont),
          ElevatedButton(
            onPressed: () => GoRouter.of(context).push('/settings'),
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }
}