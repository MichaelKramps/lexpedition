import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/letter_tile.dart';

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
                fontSize: Constants.bigFont,
                height: 0.85,
                color: determineTextColor(
                    letterTile.requiredCharges, letterTile.currentCharges))),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          for (int charge = 0;
              charge < (letterTile.requiredCharges - letterTile.currentCharges);
              charge++) ...[
            Text('.',
                style: TextStyle(
                    fontSize: Constants.smallFont,
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
      return Color.fromARGB(255, 0, 0, 0);
    } else {
      return Colors.black;
    }
  }
}
