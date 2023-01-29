import 'dart:developer';

import 'letter_tile.dart';

class LetterGrid {
  late List<LetterTile> letterTiles;
  late List<List<LetterTile>> rows;
  SprayDirection sprayDirection = SprayDirection.up;
  List<String> guesses = [];
  late int par;

  LetterGrid(List<String?> letterTiles, int par) {
    assert(letterTiles.length == 24);
    this.letterTiles = this.decodeLetterTiles(letterTiles);
    this.rows = this.setRows(this.letterTiles);
    this.par = par;
  }

  List<LetterTile> decodeLetterTiles(List<String?> encodedTiles) {
    List<LetterTile> decodedLetterTiles = [];

    for (int index = 0; index < encodedTiles.length; index++) {
      String? encodedTile = encodedTiles[index];
      if (encodedTile != null) {
        String letter = encodedTile[0];
        TileType tileType = TileType.values[int.parse(encodedTile[1])];
        int requiredCharges = int.parse(encodedTile[2]);
        int requiredObstacleCharges = int.parse(encodedTile[3]);
        final LetterTile thisDecodedLetterTile = LetterTile(
            letter, tileType, requiredCharges, requiredObstacleCharges, index);

        decodedLetterTiles.add(thisDecodedLetterTile);
      } else {
        decodedLetterTiles.add(LetterTile('', TileType.empty, 0, 0, index));
      }
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

  void changeSprayDirection() {
    if (sprayDirection == SprayDirection.values.last) {
      sprayDirection = SprayDirection.values.first;
    } else {
      sprayDirection = SprayDirection.values[sprayDirection.index + 1];
    }
  }
}

enum SprayDirection { up, right, down, left }
