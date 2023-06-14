import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/blast_direction.dart';
import 'package:lexpedition/src/game_data/constants.dart';

class BlastWidget extends StatelessWidget {
  final BlastDirection blastDirection;
  final bool beginBlastAnimation;

  const BlastWidget(
      {super.key,
      required this.blastDirection,
      required this.beginBlastAnimation});

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: beginBlastAnimation,
        maintainAnimation: false,
        child: RotatedBox(
          quarterTurns: blastDirection == BlastDirection.horizontal ? 0 : 1,
          child: Image.asset(Constants.blastImage,
              height: Constants().tileSize(), 
              width: Constants().tileSize()
          ),
        ));
  }
}
