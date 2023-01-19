import 'package:flutter/material.dart';
import 'package:game_template/src/game_data/letter_tile.dart';
import 'package:game_template/src/game_widgets/tile_info_widget.dart';

class LetterTileWidget extends StatefulWidget {
  final LetterTile? letterTile;
  final Function(String) updateGuess;

  LetterTileWidget(
      {super.key, required this.letterTile, required this.updateGuess});

  @override
  State<LetterTileWidget> createState() => _LetterTileWidgetState();

  Color determineTileColor(LetterTile letterTile) {
    if (letterTile.isCharged()) {
      return Colors.amber;
    }

    switch (letterTile.tileType) {
      case (TileType.start):
        return Colors.green.shade700;
      case (TileType.end):
        return Colors.red.shade700;
      default:
        return Colors.blueGrey.shade600;
    }
  }

  BorderSide determineBorder(LetterTile letterTile) {
    if (letterTile.selected) {
      return BorderSide(width: 1, color: Colors.orange);
    } else {
      return BorderSide(width: 0);
    }
  }
}

class _LetterTileWidgetState extends State<LetterTileWidget> {
  late LetterTile? _tile = widget.letterTile;

  @override
  Widget build(BuildContext context) {
    if (_tile != null) {
      LetterTile nonNullLetterTile =
          _tile ?? new LetterTile('', TileType.basic, 0, 0);

      final ButtonStyle style = ElevatedButton.styleFrom(
          fixedSize: Size.square(80),
          backgroundColor: widget.determineTileColor(nonNullLetterTile),
          side: widget.determineBorder(nonNullLetterTile));

      return Container(
          margin: EdgeInsets.all(2),
          child: ElevatedButton(
              onPressed: () {
                widget.updateGuess(nonNullLetterTile.letter.toUpperCase());
                setState((() {
                  nonNullLetterTile.selected = true;
                }));
              },
              style: style,
              child: TileInfoWidget(letterTile: nonNullLetterTile)));
    } else {
      return Container(
          margin: EdgeInsets.all(2),
          width: 80,
          height: 80,
          color: Colors.grey.shade300);
    }
  }
}
