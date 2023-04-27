import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/blast_direction.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_state.dart';

class ObserverBlastDirectionWidget extends StatelessWidget {
  final GameState gameState;

  const ObserverBlastDirectionWidget({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => {},
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

    switch (gameState.getTheirGrid()?.blastDirection) {
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
