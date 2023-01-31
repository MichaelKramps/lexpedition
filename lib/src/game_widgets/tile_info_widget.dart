import 'package:flutter/material.dart';
import 'package:game_template/src/game_data/constants.dart';
import 'package:game_template/src/game_data/letter_tile.dart';

class TileInfoWidget extends StatelessWidget {
  final LetterTile letterTile;

  TileInfoWidget({super.key, required this.letterTile});

  @override
  Widget build(BuildContext context) {
    if (letterTile.tileType != TileType.empty) {
      String letter = letterTile.letter.toUpperCase();
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(letter,
            style: TextStyle(
                fontSize: Constants.tileSize * 0.7,
                color: determineTextColor(
                    letterTile.requiredCharges, letterTile.currentCharges))),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          for (int charge = 0;
              charge < (letterTile.requiredCharges - letterTile.currentCharges);
              charge++) ...[
            Text('.',
                style: TextStyle(
                    fontSize: Constants.tileSize * 0.6,
                    height: 0.01,
                    color: Colors.white))
          ]
        ])
      ]);
    } else {
      return Container();
    }
  }

  Color determineTextColor(int requiredCharges, int currentCharges) {
    if (currentCharges < requiredCharges) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }
}
