import 'package:flutter/material.dart';
import 'package:game_template/src/game_data/letter_tile.dart';

class TileInfoWidget extends StatefulWidget {
  LetterTile letterTile;

  TileInfoWidget({super.key, required this.letterTile});

  @override
  State<TileInfoWidget> createState() => _TileInfoWidgetState();

  Color determineDotColor(int charge, int currentCharges) {
    if (charge < currentCharges) {
      return Colors.green;
    } else {
      return Colors.black;
    }
  }
}

class _TileInfoWidgetState extends State<TileInfoWidget> {
  @override
  Widget build(BuildContext context) {
    String letter = widget.letterTile?.letter.toUpperCase() ?? '';
    return Column(children: [
      Text(letter),
      Row(children: [
        for (int charge = 0;
            charge < widget.letterTile.requiredCharges;
            charge++) ...[
          Text('.',
              style: TextStyle(
                  color: widget.determineDotColor(
                      charge, widget.letterTile.currentCharges)))
        ]
      ])
    ]);
  }
}
