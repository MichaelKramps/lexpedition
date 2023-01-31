import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';

class BuildTwoPlayerPuzzleWidget extends StatefulWidget {
  const BuildTwoPlayerPuzzleWidget({super.key});

  @override
  State<BuildTwoPlayerPuzzleWidget> createState() =>
      _BuildTwoPlayerPuzzleWidgetState();
}

class _BuildTwoPlayerPuzzleWidgetState
    extends State<BuildTwoPlayerPuzzleWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ElevatedButton(
            onPressed: () => GoRouter.of(context).push('/buildpuzzle'),
            child: Text('Back')));
  }
}
