import 'package:lexpedition/src/game_data/blast_direction.dart';

import 'letter_tile.dart';

class LetterGrid {
  late List<String?> encodedTiles;
  late List<LetterTile> letterTiles;
  late List<List<LetterTile>> rows;
  BlastDirection blastDirection = BlastDirection.vertical;
  List<String> guesses = [];
  late int par;

  LetterGrid(List<String?> letterTiles, int par) {
    assert(letterTiles.length == 24);
    this.encodedTiles = letterTiles;
    this.letterTiles = this.decodeLetterTiles(letterTiles);
    this.rows = this.setRows(this.letterTiles);
    this.par = par;
  }

  LetterGrid.fromLiveDatabase(List<String?> letterTiles, List<String> guesses) {
    assert(letterTiles.length == 24);
    this.encodedTiles = letterTiles;
    this.letterTiles = this.decodeLetterTiles(letterTiles);
    this.rows = this.setRows(this.letterTiles);
    this.par = 1;
    this.guesses = guesses;
  }

  List<LetterTile> decodeLetterTiles(List<String?> encodedTiles) {
    List<LetterTile> decodedLetterTiles = [];

    for (int index = 0; index < encodedTiles.length; index++) {
      String? encodedTileString = encodedTiles[index];
      decodedLetterTiles
          .add(LetterTile.fromEncodedString(encodedTileString, index));
    }

    return decodedLetterTiles;
  }

  List<List<LetterTile>> setRows(List<LetterTile> letterTiles) {
    List<List<LetterTile>> rows = [];

    for (int row = 0; row < 4; row++) {
      //all grids should be 4x6
      List<LetterTile> thisRow = [];

      int baseIndex = row * 6;

      thisRow.add(letterTiles[baseIndex]);
      thisRow.add(letterTiles[baseIndex + 1]);
      thisRow.add(letterTiles[baseIndex + 2]);
      thisRow.add(letterTiles[baseIndex + 3]);
      thisRow.add(letterTiles[baseIndex + 4]);
      thisRow.add(letterTiles[baseIndex + 5]);

      rows.add(thisRow);
    }

    return rows;
  }

  List<String?> getReEncodedGrid() {
    List<String?> reEncodedGrid = [];

    for (int tileIndex = 0; tileIndex < letterTiles.length; tileIndex++) {
      LetterTile thisTile = letterTiles[tileIndex];
      reEncodedGrid.add(thisTile.encodeTile());
    }

    return reEncodedGrid;
  }

  String getGridStringForDatabase() {
    List<String?> encodedGrid = getReEncodedGrid();
    return encodedGrid.join(',');
  }

  String encodedGridToString() {
    encodedTiles = getReEncodedGrid();
    String gridString = '';

    for (String? encodedTile in encodedTiles) {
      if (encodedTile == null) {
        gridString += 'null,';
      } else {
        gridString += encodedTile;
        gridString += ',';
      }
    }

    return gridString.substring(0, gridString.length - 1);
  }

  void resetGrid() {
    blastDirection = BlastDirection.vertical;
    guesses = [];
    for (var tile in this.letterTiles) {
      tile.resetTile();
    }
  }

  bool isFullyCharged() {
    for (var tile in this.letterTiles) {
      if (!tile.isCharged()) {
        return false;
      }
    }

    return true;
  }

  void addGuess(String guess) {
    this.guesses.add(guess);
  }

  bool isNewGuess(String guess) {
    return !this.guesses.contains(guess);
  }

  void changeBlastDirection() {
    if (blastDirection == BlastDirection.values.last) {
      blastDirection = BlastDirection.values.first;
    } else {
      blastDirection = BlastDirection.values[blastDirection.index + 1];
    }
  }
}
