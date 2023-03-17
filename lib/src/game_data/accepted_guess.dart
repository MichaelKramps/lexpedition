class AcceptedGuess {
  final String guess;
  final bool fromMe;
  final DateTime timeSubmitted = DateTime.now();

  AcceptedGuess({required this.guess, this.fromMe = true}) {}

  bool matchesGuess(AcceptedGuess guessToCheck) {
    return guessToCheck.guess.toLowerCase() == guess.toLowerCase();
  }
}
