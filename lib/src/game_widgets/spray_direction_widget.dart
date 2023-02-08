import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';

class SprayDirectionWidget extends StatelessWidget {
  final SprayDirection sprayDirection;
  final Function changeDirection;

  const SprayDirectionWidget(
      {super.key, required this.sprayDirection, required this.changeDirection});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => {changeDirection()},
      child: Image.asset(
        determineImage(),
        height: Constants.tileSize,
        width: Constants.tileSize,
        semanticLabel: 'Spray Direction',
      ),
    );
  }

  String determineImage() {
    String path = 'assets/images/';

    switch (sprayDirection) {
      case (SprayDirection.horizontal):
        path += 'staveright';
        break;
      default:
        path += 'staveup';
        break;
    }

    path += '.png';

    return path;
  }
}
