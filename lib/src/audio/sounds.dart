// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

List<String> soundTypeToFilename(SfxType type) {
  switch (type) {
    case SfxType.tapLetter:
      return const ['tap-letter.wav'];
    case SfxType.correctGuess:
      return const ['correct-guess.mp3'];
    case SfxType.incorrectGuess:
      return const ['wrong-guess.mp3'];
    case SfxType.wonLevel:
      return const ['win-level-2.wav'];
    case SfxType.blast:
      return const ['blast.mp3'];
    default:
      return const ['tap-letter.wav'];
  }
}

/// Allows control over loudness of different SFX types.
double soundTypeToVolume(SfxType type) {
  switch (type) {
    case SfxType.tapLetter:
      return 1.2;
    case SfxType.correctGuess:
    case SfxType.wonLevel:
      return 2.0;
    case SfxType.tapButton:
      return 1.0;
    case SfxType.blast:
      return 0.4;
    default:
      return 1.0;
  }
}

enum SfxType {
  blast,
  tapButton,
  tapLetter,
  correctGuess,
  incorrectGuess,
  wonLevel,
  primedForBlast
}
