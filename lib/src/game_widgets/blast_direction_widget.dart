import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/blast_direction.dart';
import 'package:lexpedition/src/game_data/constants.dart';

class BlastDirectionWidget extends StatelessWidget {
  final BlastDirection blastDirection;
  final Function changeDirection;

  const BlastDirectionWidget(
      {super.key, required this.blastDirection, required this.changeDirection});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => {changeDirection()},
      child: Image.asset(
        determineImage(),
        height: Constants.tileSize,
        width: Constants.tileSize,
        semanticLabel: 'blast Direction',
      ),
    );
  }

  String determineImage() {
    String path = 'assets/images/';

    switch (blastDirection) {
      case (BlastDirection.horizontal):
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
