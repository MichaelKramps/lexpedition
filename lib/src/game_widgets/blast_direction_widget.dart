import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/blast_direction.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_state.dart';

class BlastDirectionWidget extends StatelessWidget {
  final GameState gameState;

  const BlastDirectionWidget({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => {gameState.changeBlastDirectionAndNotify()},
      child: RotatedBox(
        quarterTurns: gameState.getMyGrid()!.blastDirection == BlastDirection.horizontal ? 0 : 1,
        child: Image.asset(
          Constants.blastImage,
          height: Constants().tileSize(),
          width: Constants().tileSize(),
          semanticLabel: 'blast Direction',
        ),
      ),
    );
  }
}
