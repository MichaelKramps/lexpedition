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
        height: 60,
        width: 60,
        semanticLabel: 'Spray Direction',
      ),
    );
  }

  String determineImage() {
    String path = 'assets/images/';

    switch (sprayDirection) {
      case (SprayDirection.right):
        path += 'staveright';
        break;
      case (SprayDirection.down):
        path += 'stavedown';
        break;
      case (SprayDirection.left):
        path += 'staveleft';
        break;
      default:
        path += 'staveup';
        break;
    }

    path += '.png';

    return path;
  }
}
