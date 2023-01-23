import 'package:flutter/material.dart';
import 'package:game_template/src/game_data/letter_tile.dart';

class TileInfoWidget extends StatelessWidget {
  LetterTile letterTile;

  TileInfoWidget({super.key, required this.letterTile});

  @override
  Widget build(BuildContext context) {
    String letter = letterTile.letter.toUpperCase();
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(letter, style: TextStyle(fontSize: 56)),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        for (int charge = 0; charge < letterTile.requiredCharges; charge++) ...[
          Text('.',
              style: TextStyle(
                  fontSize: 32,
                  height: 0.3,
                  color: determineDotColor(charge, letterTile.currentCharges)))
        ]
      ])
    ]);
  }

  Color determineDotColor(int charge, int currentCharges) {
    if (charge < currentCharges) {
      return Colors.amber;
    } else {
      return Colors.black;
    }
  }
}
