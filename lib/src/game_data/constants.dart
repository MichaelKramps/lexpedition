class Constants {
  static double tileSize = 64;
  static double tileMargin = tileSize * 0.025;

  static int tileOneStart = (tileMargin).ceil();
  static int tileOneEnd = (tileSize + tileMargin).floor();
  static int tileTwoStart = (tileSize + (tileMargin * 3)).ceil();
  static int tileTwoEnd = ((tileSize * 2) + (tileMargin * 4)).floor();
  static int tileThreeStart = ((tileSize * 2) + (tileMargin * 5)).ceil();
  static int tileThreeEnd = ((tileSize * 3) + (tileMargin * 6)).floor();
  static int tileFourStart = ((tileSize * 3) + (tileMargin * 7)).ceil();
  static int tileFourEnd = ((tileSize * 4) + (tileMargin * 8)).floor();
  static int tileFiveStart = ((tileSize * 4) + (tileMargin * 9)).ceil();
  static int tileFiveEnd = ((tileSize * 5) + (tileMargin * 10)).floor();
  static int tileSixStart = ((tileSize * 5) + (tileMargin * 11)).ceil();
  static int tileSixEnd = ((tileSize * 6) + (tileMargin * 12)).floor();

  static double bigFont = 42;
  static double smallFont = 24;
  static double verySmallFont = 14;

  static String assetsPath = 'assets';
  static String imagePath = assetsPath + '/images';
  static String backgroundImagePath = imagePath + '/g4.bmp';
}
