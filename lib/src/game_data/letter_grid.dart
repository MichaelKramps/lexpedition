import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/accepted_guess.dart';
import 'package:lexpedition/src/game_data/blast_direction.dart';
import 'package:lexpedition/src/game_data/constants.dart';

import 'letter_tile.dart';

class LetterGrid {
  late List<String?> encodedTiles;
  late List<LetterTile> letterTiles;
  late List<List<LetterTile>> columns;
  ScrollController scrollController = ScrollController();
  int currentColumn = 0;
  BlastDirection blastDirection = BlastDirection.vertical;
  List<LetterTile> currentGuess = [];
  List<AcceptedGuess> guesses = [];

  LetterGrid(List<String?> gridData) {
    assert(gridData.length >= 24);
    if (gridData.length == 25) {
      // includes blast direction
      this.blastDirection = BlastDirection.values[int.parse(gridData[24]!)];
      gridData.removeLast();
    }
    this.encodedTiles = gridData;
    this.letterTiles = this.decodeLetterTiles(gridData);
    this.columns = this.setColumns(this.letterTiles);
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
    ]);
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

  List<List<LetterTile>> setColumns(List<LetterTile> letterTiles) {
    List<List<LetterTile>> columns = [];

    for (int column = 0; column < (letterTiles.length / 4).floor(); column++) {
      //all grids have 4 rows
      List<LetterTile> thisColumn = [];

      int baseIndex = column * 4;

      thisColumn.add(letterTiles[baseIndex]);
      thisColumn.add(letterTiles[baseIndex + 1]);
      thisColumn.add(letterTiles[baseIndex + 2]);
      thisColumn.add(letterTiles[baseIndex + 3]);

      columns.add(thisColumn);
    }

    return columns;
  }

  bool isBlank() {
    for (LetterTile tile in letterTiles) {
      if (tile.tileType != TileType.empty) {
        return false;
      }
    }
    return true;
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
        if (acceptedGuess.matchesGuess(AcceptedGuess(guess: dbGuess))) {
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

    gridString += blastDirection.index.toString();

    return gridString;
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

  void updateCurrentColumn() {
    bool updatedCurrentColumn = false;
    if (currentColumn < columns.length - 6) {
      for (int columnIndex = currentColumn;
          columnIndex < columns.length;
          columnIndex++) {
        List<LetterTile> thisColumn = columns[columnIndex];
        bool columnIsCharged = true;
        for (LetterTile thisTile in thisColumn) {
          if (!thisTile.isCharged()) {
            columnIsCharged = false;
            break;
          }
        }
        if (columnIsCharged) {
          updatedCurrentColumn = true;
          currentColumn++;
        } else {
          break;
        }
      }
    }

    if (updatedCurrentColumn) {
      double columnOffset =
          currentColumn * Constants().tileSize() + Constants().tileMargin() * 2;
      scrollController.animateTo(columnOffset,
          duration: Duration(milliseconds: 500), curve: Curves.easeIn);
    }
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

  void setChargedFromPartnerTiles() {
    for (int i = 0; i < letterTiles.length; i++) {
      LetterTile thisTile = letterTiles[i];
      if (thisTile.primedForBlast) {
        thisTile.primedForBlast = false;
        thisTile.primedForBlastFromPartner = true;
        thisTile.qualifiesToBeBlasted = false;
        thisTile.qualifiesToBeBlastedFromPartner = true;
      } else if (thisTile.primedForBlastFromPartner) {
        thisTile.primedForBlast = true;
        thisTile.primedForBlastFromPartner = false;
        thisTile.qualifiesToBeBlasted = true;
        thisTile.qualifiesToBeBlastedFromPartner = false;
      } else if (thisTile.qualifiesToBeBlasted) {
        thisTile.qualifiesToBeBlastedFromPartner = true;
        thisTile.qualifiesToBeBlasted = false;
      } else if (thisTile.qualifiesToBeBlastedFromPartner) {
        thisTile.qualifiesToBeBlasted = true;
        thisTile.qualifiesToBeBlastedFromPartner = false;
      } else {
        thisTile.qualifiesToBeBlasted = false;
        thisTile.qualifiesToBeBlastedFromPartner = false;
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
    List<int> indexesToBlast =
        LetterGrid.indexesToBlast(index: index, blastDirection: blastDirection, currentColumn: currentColumn);

    for (int index in indexesToBlast) {
      letterTiles[index].blast();
    }
  }

  static List<int> indexesToBlast(
      {required int index, required BlastDirection blastDirection, int currentColumn = 0}) {
    int ad = currentColumn * 4; //adjustment for currentColumn

    List<List<int>> rows = [
      [0 + ad, 4 + ad, 8 + ad, 12 + ad, 16 + ad, 20 + ad],
      [1 + ad, 5 + ad, 9 + ad, 13 + ad, 17 + ad, 21 + ad],
      [2 + ad, 6 + ad, 10 + ad, 14 + ad, 18 + ad, 22 + ad],
      [3 + ad, 7 + ad, 11 + ad, 15 + ad, 19 + ad, 23 + ad]
    ];

    List<List<int>> columns = [
      [0 + ad, 1 + ad, 2 + ad, 3 + ad],
      [4 + ad, 5 + ad, 6 + ad, 7 + ad],
      [8 + ad, 9 + ad, 10 + ad, 11 + ad],
      [12 + ad, 13 + ad, 14 + ad, 15 + ad],
      [16 + ad, 17 + ad, 18 + ad, 19 + ad],
      [20 + ad, 21 + ad, 22 + ad, 23 + ad]
    ];

    if (blastDirection == BlastDirection.horizontal) {
      for (List<int> row in rows) {
        if (row.contains(index)) {
          return row;
        }
      }
    } else {
      for (List<int> column in columns) {
        if (column.contains(index)) {
          return column;
        }
      }
    }
    return [];
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
