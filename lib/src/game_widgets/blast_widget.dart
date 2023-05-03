import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/blast_direction.dart';
import 'package:lexpedition/src/game_data/constants.dart';

class BlastWidget extends StatefulWidget {
  final BlastDirection blastDirection;
  final bool beginBlastAnimation;

  const BlastWidget(
      {super.key,
      required this.blastDirection,
      required this.beginBlastAnimation});

  @override
  State<BlastWidget> createState() => _BlastWidgetState();
}

class _BlastWidgetState extends State<BlastWidget> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: widget.beginBlastAnimation,
        maintainAnimation: false,
        child: Image.asset('assets/images/blast.png',
            height: Constants().tileSize(), width: Constants().tileSize()));
  }
}
