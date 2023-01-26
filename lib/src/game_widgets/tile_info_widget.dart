import 'package:flutter/material.dart';
import 'package:game_template/src/game_data/letter_tile.dart';

class TileInfoWidget extends StatelessWidget {
  LetterTile letterTile;

  TileInfoWidget({super.key, required this.letterTile});

  @override
  Widget build(BuildContext context) {
    String letter = letterTile.letter.toUpperCase();
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(letter,
          style: TextStyle(
              fontSize: 56,
              color: determineTextColor(
                  letterTile.requiredCharges, letterTile.currentCharges))),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        for (int charge = 0;
            charge < (letterTile.requiredCharges - letterTile.currentCharges);
            charge++) ...[
          Text('.',
              style: TextStyle(fontSize: 48, height: 0.01, color: Colors.white))
        ]
      ])
    ]);
  }

  Color determineTextColor(int requiredCharges, int currentCharges) {
    if (currentCharges < requiredCharges) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }
}
