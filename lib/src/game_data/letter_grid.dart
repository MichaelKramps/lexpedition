import 'package:lexpedition/src/game_data/accepted_guess.dart';
import 'package:lexpedition/src/game_data/blast_direction.dart';

import 'letter_tile.dart';

class LetterGrid {
  late List<String?> encodedTiles;
  late List<LetterTile> letterTiles;
  late List<List<LetterTile>> rows;
  BlastDirection blastDirection = BlastDirection.vertical;
  List<LetterTile> currentGuess = [];
  List<AcceptedGuess> guesses = [];
  late int par;

  LetterGrid(List<String?> letterTiles, int par) {
    assert(letterTiles.length == 24);
    this.encodedTiles = letterTiles;
    this.letterTiles = this.decodeLetterTiles(letterTiles);
    this.rows = this.setRows(this.letterTiles);
    this.par = par;
  }

  factory LetterGrid.blankGrid() {
    return LetterGrid([
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null
    ], 0);
  }

  LetterGrid.fromLiveDatabase(
      {required List<String?> letterTiles,
      required List<String> guesses,
      BlastDirection? blastDirection}) {
    assert(letterTiles.length == 24);
    this.encodedTiles = letterTiles;
    this.letterTiles = this.decodeLetterTiles(letterTiles);
    this.rows = this.setRows(this.letterTiles);
    this.par = 1;
    setGuessesFromDatabase(guesses);
    if (blastDirection != null) {
      this.blastDirection = blastDirection;
    }
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

  void setGuessesFromDatabase(List<String> guessesFromDatabase) {
    for (String dbGuess in guessesFromDatabase) {
      bool alreadyExists = false;
      for (AcceptedGuess acceptedGuess in guesses) {
        if (acceptedGuess.matchesGuess(dbGuess)) {
          alreadyExists = true;
        }
      }
      if (!alreadyExists && dbGuess != "") {
        guesses.add(AcceptedGuess(guess: dbGuess, fromMe: false));
      }
    }
  }

  void updateGuessesFromLetterGrid(LetterGrid newLetterGrid) {
    for (AcceptedGuess acceptedGuess in newLetterGrid.guesses) {
      if (guessIsNew(acceptedGuess)) {
        guesses.add(acceptedGuess);
      }
    }
  }

  bool guessIsNew(AcceptedGuess acceptedGuess) {
    for (AcceptedGuess guess in guesses) {
      if (guess.guess.toLowerCase() == acceptedGuess.guess.toLowerCase()) {
        return false;
      }
    }
    return true;
  }

  String createGuessesForDatabase() {
    List<String> guessStrings = [];
    for (AcceptedGuess guess in guesses) {
      guessStrings.add(guess.guess);
    }
    return guessStrings.join(',');
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

  void clearCurrentGuess() {
    this.currentGuess = [];
    clearPrimedForBlast();
  }

  void removeLastInCurrentGuess() {
    this.currentGuess.removeLast();
    attemptToPrimeForBlast();
  }

  void updateCurrentGuess(LetterTile letterTile) {
    this.currentGuess.add(letterTile);
    clearPrimedForBlast();
    attemptToPrimeForBlast();
  }

  void clearPrimedForBlast() {
    for (LetterTile tile in this.letterTiles) {
      tile.unprimeForBlast();
    }
  }

  void attemptToPrimeForBlast() {
    if (currentGuess.length >= 5) {
      this.currentGuess.last.primeForBlast();
    }
  }

  void primeForBlastFromIndex(int index) {
    this.letterTiles[index].primeForBlast();
  }

  void chargeTilesFromGuess() {
    for (int tile = 0; tile < currentGuess.length; tile++) {
      LetterTile thisTile = currentGuess[tile];
      thisTile.selected = false;
      bool qualifiesAsBasicTile = thisTile.tileType == TileType.basic;
      bool qualifiesAsStartTile =
          thisTile.tileType == TileType.start && thisTile == currentGuess[0];
      bool qualifiesAsEndTile = thisTile.tileType == TileType.end &&
          thisTile == currentGuess[currentGuess.length - 1];
      if (qualifiesAsBasicTile || qualifiesAsStartTile || qualifiesAsEndTile) {
        thisTile.addCharge();
      }
    }
  }

  void addGuess(String guess) {
    this.guesses.add(AcceptedGuess(guess: guess));
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

  void blastFromIndex(int index) {
    assert(index >= 0 && index < 24);
    late List<int> indexesToBlast;

    List<List<int>> rows = [
      [0, 1, 2, 3, 4, 5],
      [6, 7, 8, 9, 10, 11],
      [12, 13, 14, 15, 16, 17],
      [18, 19, 20, 21, 22, 23]
    ];

    List<List<int>> columns = [
      [0, 6, 12, 18],
      [1, 7, 13, 19],
      [2, 8, 14, 20],
      [3, 9, 15, 21],
      [4, 10, 16, 22],
      [5, 11, 17, 23]
    ];

    if (blastDirection == BlastDirection.horizontal) {
      for (List<int> row in rows) {
        if (row.contains(index)) {
          indexesToBlast = row;
        }
      }
    } else {
      for (List<int> column in columns) {
        if (column.contains(index)) {
          indexesToBlast = column;
        }
      }
    }

    for (int index in indexesToBlast) {
      letterTiles[index].blast();
    }
  }

  void unblast() {
    for (LetterTile letterTile in letterTiles) {
      letterTile.unblast();
      letterTile.unprimeForBlast();
    }
  }

  void unselectAll() {
    for (LetterTile letterTile in letterTiles) {
      letterTile.unselect();
    }
  }
}
