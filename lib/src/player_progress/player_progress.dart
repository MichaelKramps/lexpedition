// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:lexpedition/src/tutorial/full_tutorial_levels.dart';
import 'package:lexpedition/src/tutorial/quick_tutorial_levels.dart';

import 'persistence/player_progress_persistence.dart';

/// Encapsulates the player's progress.
class PlayerProgress extends ChangeNotifier {
  static const maxHighestScoresPerPlayer = 10;

  final PlayerProgressPersistence _store;

  int _highestLevelReached = 0;
  bool _tutorialPassed = false;

  /// Creates an instance of [PlayerProgress] backed by an injected
  /// persistence [store].
  PlayerProgress(PlayerProgressPersistence store) : _store = store;

  /// The highest level that the player has reached so far.
  int get highestLevelReached => _highestLevelReached;
  bool get tutorialPassed => _tutorialPassed;

  /// Fetches the latest data from the backing persistence store.
  Future<void> getLatestFromStore() async {
    final level = await _store.getHighestLevelReached();
    final bool passed = await _store.getTutorialPassed();
    if (level > _highestLevelReached) {
      _highestLevelReached = level;
      notifyListeners();
    } else if (level < _highestLevelReached) {
      await _store.saveHighestLevelReached(_highestLevelReached);
    }

    if (passed) {
      _tutorialPassed = passed;
      notifyListeners();
    } else if (_tutorialPassed) {
      await _store.saveTutorialPassed(_tutorialPassed);
    }
  }

  /// Resets the player's progress so it's like if they just started
  /// playing the game for the first time.
  void reset() {
    _highestLevelReached = 0;
    _tutorialPassed = false;
    notifyListeners();
    _store.saveHighestLevelReached(_highestLevelReached);
    _store.saveTutorialPassed(_tutorialPassed);
  }

  /// Registers [level] as reached.
  ///
  /// If this is higher than [highestLevelReached], it will update that
  /// value and save it to the injected persistence store.
  void setLevelReached(int level) {
    if (level > _highestLevelReached) {
      _highestLevelReached = level;
      notifyListeners();

      unawaited(_store.saveHighestLevelReached(level));
    }
    
    if (level > 100 && level < 200) {
      if ((level - 100) >= quickTutorialLevels.length) {
        setTutorialPassed(true);
      }
    } else if (level > 200) {
      if ((level - 200) >= fullTutorialLevels.length) {
        setTutorialPassed(true);
      }
    }
  }

  void setTutorialPassed(bool passed) {
    if (passed && !_tutorialPassed) {
      _tutorialPassed = passed;
      notifyListeners();

      unawaited(_store.saveTutorialPassed(passed));
    }
  }
}
