import 'dart:math';

import 'package:flutter/src/widgets/framework.dart';
import 'package:lexpedition/src/game_data/levels.dart';
import 'package:lexpedition/src/level_info/free_play_levels.dart';
import 'package:lexpedition/src/play_session/play_session_screen.dart';

class FreePlay extends StatelessWidget {
  const FreePlay({super.key});

  @override
  Widget build(BuildContext context) {
    Level level =
        freePlayLevels.elementAt(Random().nextInt(freePlayLevels.length));
    return new PlaySessionScreen(level, '/freeplay/won');
  }
}
