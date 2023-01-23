import 'package:flutter/material.dart';
import 'package:game_template/src/game_data/letter_tile.dart';
import 'package:game_template/src/game_widgets/tile_info_widget.dart';

class LetterTileWidget extends StatelessWidget {
  final LetterTile? letterTile;

  const LetterTileWidget({super.key, required this.letterTile});

  @override
  Widget build(BuildContext context) {
    if (letterTile != null) {
      final ButtonStyle style = ElevatedButton.styleFrom(
          fixedSize: Size.square(80),
          backgroundColor: determineTileColor(letterTile),
          side: determineBorder(letterTile));

      return Container(
          margin: EdgeInsets.all(2),
          child: ElevatedButton(
              onPressed: () {},
              style: style,
              child: TileInfoWidget(
                  letterTile: letterTile ??
                      new LetterTile('l', TileType.basic, 0, 0, 0))));
    } else {
      return Container(
          margin: EdgeInsets.all(2),
          width: 80,
          height: 80,
          color: Colors.grey.shade300);
    }
  }

  Color determineTileColor(LetterTile? letterTile) {
    if (letterTile != null && letterTile.isCharged()) {
      return Colors.amber;
    }

    if (letterTile != null) {
      switch (letterTile.tileType) {
        case (TileType.start):
          return Colors.green.shade700;
        case (TileType.end):
          return Colors.red.shade700;
        default:
          return Colors.blueGrey.shade600;
      }
    }

    return Colors.black;
  }

  BorderSide determineBorder(LetterTile? letterTile) {
    if (letterTile != null && letterTile.selected) {
      return BorderSide(width: 1, color: Colors.orange);
    } else {
      return BorderSide(width: 0);
    }
  }
}
