class LetterTile {
  late String letter;
  late TileType tileType;
  late int requiredCharges;
  late int currentCharges;
  late int index = -1;
  bool selected = false;

  LetterTile(String letter, TileType tileType, int requiredCharges,
      int currentCharges, int index) {
    this.letter = letter;
    this.tileType = tileType;
    this.requiredCharges = requiredCharges;
    this.currentCharges = currentCharges;
    this.index = index;
  }

  void addCharge() {
    this.currentCharges += 1;
  }

  void removeCharge() {
    this.currentCharges -= 1;
  }

  bool isCharged() {
    return this.currentCharges >= this.requiredCharges;
  }

  bool allowedToSelect(LetterTile nextSelection) {
    if (!nextSelection.selected) {
      //cannot select same tile twice
      for (int allowedIndex in this.adjacentIndexes()) {
        if (allowedIndex == nextSelection.index) {
          return true;
        }
      }
    }

    return false;
  }

  List<int> adjacentIndexes() {
    int row = (index / 6).floor();
    List<int> rowsToCheck = [row];

    if (row == 0) {
      //first row
      rowsToCheck.add(row + 1);
    } else if (row == 5) {
      //last row
      rowsToCheck.add(row - 1);
    } else {
      //middle row
      rowsToCheck.add(row - 1);
      rowsToCheck.add(row + 1);
    }

    int column = index % 6;
    List<int> columnsToCheck = [column];

    if (column == 0) {
      //first column
      columnsToCheck.add(column + 1);
    } else if (column == 5) {
      //last column
      columnsToCheck.add(column - 1);
    } else {
      //middle column
      columnsToCheck.add(column - 1);
      columnsToCheck.add(column + 1);
    }

    List<int> adjacentIndexes = [];

    for (int row in rowsToCheck) {
      for (int column in columnsToCheck) {
        int thisIndex = (row * 6) + column;
        if (thisIndex != this.index) {
          adjacentIndexes.add(thisIndex);
        }
      }
    }

    return adjacentIndexes;
  }
}

enum TileType { basic, start, end }
