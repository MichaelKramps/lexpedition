import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class BuildOnePlayerPuzzleWidget extends StatefulWidget {
  const BuildOnePlayerPuzzleWidget({super.key});

  @override
  State<BuildOnePlayerPuzzleWidget> createState() =>
      _BuildOnePlayerPuzzleWidgetState();
}

class _BuildOnePlayerPuzzleWidgetState
    extends State<BuildOnePlayerPuzzleWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text('one player'));
  }
}
