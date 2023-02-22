import 'package:flutter/widgets.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/game_widgets/letter_tile_widget.dart';

class ObserverLetterGridWidget extends StatefulWidget {
  final LetterGrid letterGrid;

  const ObserverLetterGridWidget({super.key, required this.letterGrid});

  @override
  State<ObserverLetterGridWidget> createState() =>
      _ObserverLetterGridWidgetState();
}

class _ObserverLetterGridWidgetState extends State<ObserverLetterGridWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      for (var row in widget.letterGrid.rows) ...[
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          for (var letterTile in row) ...[
            LetterTileWidget(
                letterTile: letterTile, blastDirection: widget.letterGrid.blastDirection)
          ]
        ])
      ]
    ]);
  }
}
