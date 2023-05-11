// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

List<String> soundTypeToFilename(SfxType type) {
  switch (type) {
    case SfxType.tapLetter:
      return const ['tap-letter-1.wav'];
    case SfxType.tapButton:
      return const ['correct-guess-2.mp3'];
    case SfxType.correctGuess:
      return const ['correct-guess-1.wav'];
    case SfxType.incorrectGuess:
      return const ['wrong-guess-1.mp3'];
    case SfxType.blast:
      return const [
        'blast-1.mp3',
      ];
    default:
      return const ['tap-letter-1.wav'];
  }
}

/// Allows control over loudness of different SFX types.
double soundTypeToVolume(SfxType type) {
  switch (type) {
    case SfxType.tapLetter:
      return 1.2;
    case SfxType.tapButton:
      return 1.0;
    default:
      return 0.8;
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
