import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/constants.dart';

class BuildPuzzleScreen extends StatelessWidget {
  const BuildPuzzleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () =>
                  GoRouter.of(context).push('/buildpuzzle/1player'),
              child: Text('Build Solo Puzzle')),
          SizedBox(width: Constants.smallFont),
          ElevatedButton(
              onPressed: () =>
                  GoRouter.of(context).push('/buildpuzzle/2player'),
              child: Text('Build Cooperative Puzzle')),
          SizedBox(width: Constants.smallFont),
          ElevatedButton(
                onPressed: () => GoRouter.of(context).pop(),
                child: Text('Back'))
        ]
      ))
    );
  }
}
