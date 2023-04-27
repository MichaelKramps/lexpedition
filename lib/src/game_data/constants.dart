import 'package:flutter/material.dart';

class Constants {
  double screenWidth = 10;
  double screenHeight = 10;
  bool initialized = false;
  static Constants instance = Constants.blank();

  Constants.initialize({required BuildContext context}) {
    Size screenSize = MediaQuery.of(context).size;
    instance.screenWidth = screenSize.width;
    instance.screenWidth = screenSize.height;
    instance.initialized = true;
    instance = this;
  }

  Constants.blank() {}

  factory Constants() {
    return instance;
  }

  double tileSize() {
    return 64;
  }

  double tileMargin() {
    return tileSize() * 0.025;
  }

  int tileOneStart() {
    return tileMargin().ceil();
  }

  int tileOneEnd() {
    return (tileSize() + tileMargin()).floor();
  }

  int tileTwoStart() {
    return (tileSize() + (tileMargin() * 3)).ceil();
  }

  int tileTwoEnd() {
    return ((tileSize() * 2) + (tileMargin() * 4)).floor();
  }

  int tileThreeStart() {
    return ((tileSize() * 2) + (tileMargin() * 5)).ceil();
  }

  int tileThreeEnd() {
    return ((tileSize() * 3) + (tileMargin() * 6)).floor();
  }

  int tileFourStart() {
    return ((tileSize() * 3) + (tileMargin() * 7)).ceil();
  }

  int tileFourEnd() {
    return ((tileSize() * 4) + (tileMargin() * 8)).floor();
  }

  int tileFiveStart() {
    return ((tileSize() * 4) + (tileMargin() * 9)).ceil();
  }

  int tileFiveEnd() {
    return ((tileSize() * 5) + (tileMargin() * 10)).floor();
  }

  int tileSixStart() {
    return ((tileSize() * 5) + (tileMargin() * 11)).ceil();
  }

  int tileSixEnd() {
    return ((tileSize() * 6) + (tileMargin() * 12)).floor();
  }

  static double bigFont = 42;
  static double smallFont = 24;
  static double verySmallFont = 14;

  static String assetsPath = 'assets';
  static String imagePath = assetsPath + '/images';
  static String backgroundImagePath = imagePath + '/g4.bmp';

  static const celebrationDuration = Duration(milliseconds: 2000);
  static const preCelebrationDuration = Duration(milliseconds: 500);
  static const waitForWinScreenDuration = Duration(milliseconds: 3000);

  static const Duration blastDuration = Duration(milliseconds: 350);
  static const Duration clearPuzzlesDuration = Duration(milliseconds: 400);
  static const Duration showBadGuessDuration = Duration(milliseconds: 1000);

  static const int guessLengthToActivateBlast = 5;

  static const String rtcMessageSplitter = ':;:!:';
  static const String rtcLoadLevelDataSplitter = ':';
}
