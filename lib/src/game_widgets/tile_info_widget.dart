import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/letter_tile.dart';

class TileInfoWidget extends StatelessWidget {
  final LetterTile letterTile;

  TileInfoWidget({super.key, required this.letterTile});

  @override
  Widget build(BuildContext context) {
    if (letterTile.tileType != TileType.empty) {
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(determineTileText(letterTile),
            style: TextStyle(
                fontFamily: "anything",
                fontSize: Constants.bigFont,
                height: 0.85,
                color: determineTextColor(
                    letterTile.requiredCharges, letterTile.currentCharges))),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          for (int charge = 1;
              charge <= letterTile.requiredCharges;
              charge++) ...[
            Text(charge <= letterTile.currentCharges ? '\u25A0' : '\u25A1',
                style: TextStyle(
                    fontFamily: "anything",
                    fontWeight: FontWeight.w600,
                    fontSize: Constants.verySmallFont,
                    height: 0.4,
                    color: charge <= letterTile.currentCharges
                        ? Colors.green
                        : Colors.black))
          ]
        ])
      ]);
    } else {
      return Container();
    }
  }

  Color determineTextColor(int requiredCharges, int currentCharges) {
    /*if (currentCharges < requiredCharges) {
      return Colors.white;
    } else {*/
    return Colors.black;
    //}
  }

  String determineTileText(LetterTile letterTile) {
    String letter = letterTile.letter.toUpperCase();

    /*switch (letterTile.tileType) {
      case TileType.start:
        return letter + '-';
      case TileType.end:
        return '-' + letter;
      default:
        return letter;
    }*/
    return letter;
  }
}
