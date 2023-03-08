class AcceptedGuess {
  final String guess;
  final bool fromMe;
  final DateTime timeSubmitted = DateTime.now();

  AcceptedGuess({required this.guess, this.fromMe = true}) {}

  bool matchesGuess(String guessToCheck) {
    return guessToCheck.toLowerCase() == guess.toLowerCase();
  }
}
