import 'package:flutter/material.dart';
import 'package:game_template/src/game_data/letter_tile.dart';
import 'package:game_template/src/game_widgets/tile_info_widget.dart';

class LetterTileWidget extends StatefulWidget {
  final LetterTile? letterTile;

  LetterTileWidget({super.key, required this.letterTile});

  @override
  State<LetterTileWidget> createState() => _LetterTileWidgetState();

  Color determineTileColor(letterTile) {
    if (letterTile.isCharged()) {
      return Colors.yellow;
    }

    switch (letterTile.tileType) {
      case (TileType.start):
        return Colors.green;
      case (TileType.end):
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}

class _LetterTileWidgetState extends State<LetterTileWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.letterTile != null) {
      final ButtonStyle style = ElevatedButton.styleFrom(
          fixedSize: Size.fromHeight(50),
          backgroundColor: widget.determineTileColor(widget.letterTile));

      LetterTile nonNullLetterTile =
          widget.letterTile ?? new LetterTile('', TileType.basic, 0, 0);
      return ElevatedButton(
          onPressed: () {},
          style: style,
          child: TileInfoWidget(letterTile: nonNullLetterTile));
    } else {
      return SizedBox(width: 50, height: 50);
    }
  }
}
