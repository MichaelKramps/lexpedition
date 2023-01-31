import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BuildPuzzleScreen extends StatelessWidget {
  const BuildPuzzleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () =>
                  GoRouter.of(context).push('/buildpuzzle/1player'),
              child: Text('1 Player')),
          ElevatedButton(
              onPressed: () =>
                  GoRouter.of(context).push('/buildpuzzle/2player'),
              child: Text('2 Players'))
        ]);
  }
}
