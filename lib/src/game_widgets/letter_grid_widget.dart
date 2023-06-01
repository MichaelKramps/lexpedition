import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/game_data/letter_tile.dart';
import 'package:lexpedition/src/game_widgets/letter_tile_widget.dart';

class LetterGridWidget extends StatelessWidget {
  final LetterGrid letterGrid;
  final GameState gameState;

  const LetterGridWidget({super.key, required this.letterGrid, required this.gameState});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Constants().gridHeight(),
      width: Constants().gridWidth() + Constants().tileMargin(),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        controller: letterGrid.scrollController,
        padding: EdgeInsets.all(0),
        scrollDirection: Axis.horizontal,
        children: [
        for (var column in letterGrid.columns) ...[
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            for (LetterTile letterTile in column) ...[
              LetterTileWidget(
                  letterTile: letterTile,
                  gameState: gameState,
                  blastDirection: letterGrid.blastDirection)
            ]
          ])
        ],
        determineEndingColumn()
      ]),
    );
  }

  Widget determineEndingColumn() {
    if (letterGrid.columns.length > 6) {
      return SizedBox(
        height: Constants().gridHeight() - (2 * Constants().tileMargin()),
        width: Constants().tileMargin(),
        child: const DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.red
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
