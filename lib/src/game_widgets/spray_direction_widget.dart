import 'package:flutter/material.dart';
import 'package:game_template/src/game_data/letter_grid.dart';

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
        semanticLabel: 'Spray Direction',
      ),
    );
  }

  String determineImage() {
    String path = 'assets/images/';

    switch (sprayDirection) {
      case (SprayDirection.right):
        path += 'sprayright';
        break;
      case (SprayDirection.down):
        path += 'spraydown';
        break;
      case (SprayDirection.left):
        path += 'sprayleft';
        break;
      default:
        path += 'sprayup';
        break;
    }

    path += '.png';

    return path;
  }
}
