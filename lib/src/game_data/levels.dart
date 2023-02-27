class GameLevel {
  final int difficulty;

  final List<String?> gridCode;

  const GameLevel({required this.difficulty, required this.gridCode});

  int get number {
    return 10;
  }
}

class TutorialLevel extends GameLevel {
  String name;

  int number;

  late int difficulty;

  late List<String?> gridCode;

  /// The achievement to unlock when the level is finished, if any.
  //final String? achievementIdIOS;

  //final String? achievementIdAndroid;

  //bool get awardsAchievement => achievementIdAndroid != null;

  TutorialLevel(
      {required this.name,
      required this.number,
      required this.difficulty,
      required this.gridCode})
      : super(difficulty: difficulty, gridCode: gridCode);
}
