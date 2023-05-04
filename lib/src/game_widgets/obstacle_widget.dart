import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/constants.dart';

class ObstacleWidget extends StatelessWidget {
  final bool visible;

  const ObstacleWidget({super.key, required this.visible});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.center,
        child: Visibility(
            visible: visible,
            child: Container(
              height: Constants().tileSize() * 0.85,
              width: Constants().tileSize() * 0.85,
              color: Colors.black.withOpacity(0.7),
            )
        )
      )
    );
  }
}
