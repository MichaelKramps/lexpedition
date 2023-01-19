import 'package:game_template/src/game_data/valid_words.dart';

class WordHelper {
  static bool isValidWord(String guess) {
    for (String word in validWords) {
      if (guess.toLowerCase() == word.toLowerCase()) {
        return true;
      }
    }
    return false;
  }
}
