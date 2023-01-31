class Constants {
  static double tileSize = 80;
  static double tileMargin = 2;

  static int tileOneStart = (tileMargin).round();
  static int tileOneEnd = (tileSize + tileMargin).round();
  static int tileTwoStart = (tileSize + (tileMargin * 3)).round();
  static int tileTwoEnd = ((tileSize * 2) + (tileMargin * 4)).round();
  static int tileThreeStart = ((tileSize * 2) + (tileMargin * 5)).round();
  static int tileThreeEnd = ((tileSize * 3) + (tileMargin * 6)).round();
  static int tileFourStart = ((tileSize * 3) + (tileMargin * 7)).round();
  static int tileFourEnd = ((tileSize * 4) + (tileMargin * 8)).round();
  static int tileFiveStart = ((tileSize * 4) + (tileMargin * 9)).round();
  static int tileFiveEnd = ((tileSize * 5) + (tileMargin * 10)).round();
  static int tileSixStart = ((tileSize * 5) + (tileMargin * 11)).round();
  static int tileSixEnd = ((tileSize * 6) + (tileMargin * 12)).round();
}
