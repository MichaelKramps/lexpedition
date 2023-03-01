import 'package:firebase_database/firebase_database.dart';
import 'package:lexpedition/src/build_puzzle/blank_grid.dart';
import 'package:lexpedition/src/game_data/levels.dart';

class LevelDatabaseConnection {
  static Future<GameLevel> getOnePlayerPuzzle() async {
    GameLevel gameLevel = GameLevel(difficulty: 0, gridCode: blankGrid);

    await FirebaseDatabase.instance
        .ref('onePlayerPuzzles')
        .orderByChild('attempts')
        .startAt(0)
        .limitToFirst(1)
        .once(DatabaseEventType.value)
        .then((value) {
      DataSnapshot puzzleEntry = value.snapshot.children.first;
      String gridString = puzzleEntry.child('gridCode').value as String;
      int par = puzzleEntry.child('averageGuesses').value as int;
      gameLevel = GameLevel(difficulty: par, gridCode: gridString.split(','));
    });
    return gameLevel;
  }

  static Future<void> logOnePlayerPuzzleResults(int puzzleId) async {

  }
}
