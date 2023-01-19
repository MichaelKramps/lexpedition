import 'package:flutter/material.dart';
import 'package:game_template/src/game_data/letter_tile.dart';

class TileInfoWidget extends StatefulWidget {
  LetterTile letterTile;

  TileInfoWidget({super.key, required this.letterTile});

  @override
  State<TileInfoWidget> createState() => _TileInfoWidgetState();

  Color determineDotColor(int charge, int currentCharges) {
    if (charge < currentCharges) {
      return Colors.amber;
    } else {
      return Colors.black;
    }
  }
}

class _TileInfoWidgetState extends State<TileInfoWidget> {
  @override
  Widget build(BuildContext context) {
    String letter = widget.letterTile.letter.toUpperCase();
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(letter, style: TextStyle(fontSize: 56)),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        for (int charge = 0;
            charge < widget.letterTile.requiredCharges;
            charge++) ...[
          Text('.',
              style: TextStyle(
                  fontSize: 32,
                  height: 0.3,
                  color: widget.determineDotColor(
                      charge, widget.letterTile.currentCharges)))
        ]
      ])
    ]);
  }
}
