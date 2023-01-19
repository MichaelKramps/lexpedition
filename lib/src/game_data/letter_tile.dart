class LetterTile {
  late String letter;
  late TileType tileType;
  late int requiredCharges;
  late int currentCharges;
  bool selected = false;

  LetterTile(String letter, TileType tileType, int requiredCharges,
      int currentCharges) {
    this.letter = letter;
    this.tileType = tileType;
    this.requiredCharges = requiredCharges;
    this.currentCharges = currentCharges;
  }

  LetterTile.withLetter(String letter) {
    this.letter = letter;
    this.tileType = TileType.basic;
    this.requiredCharges = 1;
    this.currentCharges = 0;
  }

  LetterTile.withLetterAndType(String letter, TileType tileType) {
    this.letter = letter;
    this.tileType = tileType;
    this.requiredCharges = 1;
    this.currentCharges = 0;
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
}

enum TileType { basic, start, end }
