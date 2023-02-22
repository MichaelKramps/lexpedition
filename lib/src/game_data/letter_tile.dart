class LetterTile {
  String letter = '';
  late TileType tileType;
  int requiredCharges = 0;
  int currentCharges = 0;
  int requiredObstacleCharges = 0;
  int currentObstacleCharges = 0;
  int index = -1;
  bool selected = false;
  bool blastFrom = false;

  LetterTile(String letter, TileType tileType, int requiredCharges,
      int requiredObstacleCharges, int index) {
    this.letter = letter;
    this.tileType = tileType;
    this.requiredCharges = requiredCharges;
    this.currentCharges = 0;
    this.requiredObstacleCharges = requiredObstacleCharges;
    this.currentObstacleCharges = 0;
    this.index = index;
  }

  LetterTile.fromEncodedString(String? encodedString, int index) {
    if (encodedString == null || encodedString == 'null') {
      this.tileType = TileType.empty;
    } else {
      if (encodedString.length == 4) {
        //represents starting tile
        this.letter = encodedString[0];
        this.tileType = TileType.values[int.parse(encodedString[1])];
        this.requiredCharges = int.parse(encodedString[2]);
        this.requiredObstacleCharges = int.parse(encodedString[3]);
      } else if (encodedString.length == 5) {
        //represents starting tile
        this.selected = encodedString[0] == '1' ? true : false;
        this.letter = encodedString[1];
        this.tileType = TileType.values[int.parse(encodedString[2])];
        this.requiredCharges = int.parse(encodedString[3]);
        this.requiredObstacleCharges = int.parse(encodedString[4]);
      } else if (encodedString.length == 6) {
        //represents tile during game
        this.letter = encodedString[0];
        this.tileType = TileType.values[int.parse(encodedString[1])];
        this.requiredCharges = int.parse(encodedString[2]);
        this.currentCharges = int.parse(encodedString[3]);
        this.requiredObstacleCharges = int.parse(encodedString[4]);
        this.currentObstacleCharges = int.parse(encodedString[5]);
      } else if (encodedString.length == 7) {
        this.selected = encodedString[0] == '1' ? true : false;
        this.letter = encodedString[1];
        this.tileType = TileType.values[int.parse(encodedString[2])];
        this.requiredCharges = int.parse(encodedString[3]);
        this.currentCharges = int.parse(encodedString[4]);
        this.requiredObstacleCharges = int.parse(encodedString[5]);
        this.currentObstacleCharges = int.parse(encodedString[6]);
      } else {
        this.tileType = TileType.empty;
      }
      this.index = index;
    }
  }

  String? encodeTile() {
    bool hasLetter = this.letter != '';
    bool hasType = this.tileType != TileType.empty;

    late String? encodedString;
    if (hasLetter && hasType) {
      encodedString = '';
      if (this.selected) {
        encodedString += '1';
      }
      encodedString += this.letter;
      encodedString += this.tileType.index.toString();
      encodedString += this.requiredCharges.toString();

      if (this.currentCharges == 0 && this.currentObstacleCharges == 0) {
        // tile has not yet been touched
        encodedString += this.requiredObstacleCharges.toString();
      } else {
        // tile has been used during a game
        encodedString += this.currentCharges.toString();
        encodedString += this.requiredObstacleCharges.toString();
        encodedString += this.currentObstacleCharges.toString();
      }
    } else {
      return null;
    }

    return encodedString;
  }

  void addCharge() {
    this.currentCharges += 1;
  }

  void removeCharge() {
    this.currentCharges -= 1;
  }

  void select() {
    this.selected = true;
  }

  void unselect() {
    this.selected = false;
  }

  void blast() {
    this.blastFrom = true;
    if (this.clearOfObstacles()) {
      this.addCharge();
    }
    //must come after clearOfObstacles check
    this.addObstacleCharge();
  }

  void unblast() {
    this.blastFrom = false;
  }

  void addObstacleCharge() {
    this.currentObstacleCharges += 1;
  }

  void resetTile() {
    this.currentCharges = 0;
    this.currentObstacleCharges = 0;
    this.selected = false;
  }

  bool isCharged() {
    //log(this.letter + ' : ' + this.currentCharges.toString());
    return this.currentCharges >= this.requiredCharges;
  }

  bool clearOfObstacles() {
    return this.currentObstacleCharges >= this.requiredObstacleCharges;
  }

  bool allowedToSelect(LetterTile nextSelection) {
    if (!nextSelection.selected) {
      //cannot select same tile twice
      //cannot select a tile with an obstacle on it
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

enum TileType { basic, start, end, empty }
