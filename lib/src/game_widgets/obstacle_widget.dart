import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:game_template/src/game_data/constants.dart';

class ObstacleWidget extends StatelessWidget {
  final bool visible;

  const ObstacleWidget({super.key, required this.visible});

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: visible,
        child: Image.asset('assets/images/butterfly-icon.png',
            height: Constants.tileSize, width: Constants.tileSize));
  }
}
