class GameLevel {
  final int difficulty;
  final int? puzzleId;
  final List<String?> gridCode;
  final int? attempts;
  final int? attemptsFinished;
  final double? averageGuesses;

  const GameLevel(
      {required this.difficulty, required this.gridCode, this.puzzleId, this.attempts, this.attemptsFinished, this.averageGuesses});

  int get number {
    return 10;
  }
}

class TutorialLevel extends GameLevel {
  String name;

  int number;

  late int difficulty;
  late int? puzzleId;
  late List<String?> gridCode;

  /// The achievement to unlock when the level is finished, if any.
  //final String? achievementIdIOS;

  //final String? achievementIdAndroid;

  //bool get awardsAchievement => achievementIdAndroid != null;

  TutorialLevel(
      {required this.name,
      required this.number,
      required this.difficulty,
      required this.gridCode,
      this.puzzleId})
      : super(difficulty: difficulty, gridCode: gridCode, puzzleId: puzzleId);
}
