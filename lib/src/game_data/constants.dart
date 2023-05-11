import 'package:flutter/material.dart';

class Constants {
  double screenWidth = 10;
  double screenHeight = 10;
  late double _tileSize = 64;
  late double _tileMargin = 1.5;
  late double _gridXStart = 0;
  bool initialized = false;
  static Constants instance = Constants.blank();

  Constants.initialize(
      {required this.screenWidth, required this.screenHeight}) {
    this.initialized = true;
    if (screenHeight > screenWidth) {
      double copyHeight = screenHeight;
      screenHeight = screenWidth;
      screenWidth = copyHeight;
    }
    _tileSize = (screenHeight / 5) - 5;
    _tileMargin = _tileSize * 0.025;
    _gridXStart = ((screenWidth - gridWidth()) / 2);
    if (_tileSize < 30 || _tileSize > 150) {
      _tileSize = 64;
      _tileMargin = 1.5;
      _gridXStart = 0;
    }
    instance = this;
  }

  Constants.blank() {}

  factory Constants() {
    return instance;
  }

  double tileSize() {
    return _tileSize;
  }

  double gridWidth() {
    return (_tileSize * 6) + (_tileMargin * 12);
  }

  double gridHeight() {
    return (_tileSize * 4) + (_tileMargin * 8);
  }

  double gridXStart() {
    return _gridXStart;
  }

  void setGridXStart(double gridXStart) {
    this._gridXStart = gridXStart;
  }

  double gridYStart() {
    return tileSize() + tileMargin();
  }

  double tileMargin() {
    return _tileMargin;
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

  static const double headerFontSize = 48;
  static const double bigFont = 42;
  static const double bigMediumFont = 36;
  static const double mediumFont = 32;
  static const double smallMediumFont = 28;
  static const double smallFont = 24;
  static const double verySmallFont = 14;

  static const String assetsPath = 'assets';
  static const String imagePath = assetsPath + '/images';
  static const String backgroundImagePath = imagePath + '/crumpled-paper.png';
  static const String logoImagePath = imagePath + '/lexpedition-logo.gif';
  static String blastImage = imagePath + '/brush-stroke.png';

  static const celebrationDuration = Duration(milliseconds: 2000);
  static const celebrationAnimationDuration = Duration(milliseconds: 1200);
  static const preCelebrationDuration = Duration(milliseconds: 500);
  static const waitForWinScreenDuration = Duration(milliseconds: 3000);

  static const Duration blastDuration = Duration(milliseconds: 350);
  static const Duration clearPuzzlesDuration = Duration(milliseconds: 400);
  static const Duration showBadGuessDuration = Duration(milliseconds: 1000);

  static const int guessLengthToActivateBlast = 5;

  static const String rtcMessageSplitter = ':;:!:';
  static const String rtcLoadLevelDataSplitter = ':';

  //User Interface Constants
  static const double buttonWidth = 240;
  static const double buttonDepth = 3;
  static const double buttonBorderRadiusAmount = 5;
  static const BorderRadiusGeometry buttonBorderRadius =
      BorderRadius.all(Radius.circular(Constants.buttonBorderRadiusAmount));
  static const Duration buttonPressAnimationDuration =
      Duration(milliseconds: 75);
  static const String buttonUIFont = 'Syne Mono';

  static Widget defaultBackground = Container(
      decoration: BoxDecoration(
          image: const DecorationImage(
              image: AssetImage(Constants.backgroundImagePath),
              fit: BoxFit.cover)));
}
