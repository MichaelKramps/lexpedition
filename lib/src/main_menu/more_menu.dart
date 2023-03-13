import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/constants.dart';

class MoreMenu extends StatelessWidget {
  const MoreMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body: SizedBox.expand(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).push('/buildpuzzle');
              },
              child: const Text('Puzzle Builder'),
            ),
            SizedBox(width: Constants.smallFont),
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
            SizedBox(width: Constants.smallFont),
            ElevatedButton(
                onPressed: () => GoRouter.of(context).pop(),
                child: Text('Back'))
          ],
        ),
      )
    );
  }
}