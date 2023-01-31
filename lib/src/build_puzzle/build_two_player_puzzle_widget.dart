import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

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
    return Container(child: Text('two player'));
  }
}
