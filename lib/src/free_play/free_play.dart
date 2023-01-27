import 'dart:math';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:game_template/src/game_data/levels.dart';
import 'package:game_template/src/level_info/free_play_levels.dart';
import 'package:game_template/src/play_session/play_session_screen.dart';

class FreePlay extends StatelessWidget {
  const FreePlay({super.key});

  @override
  Widget build(BuildContext context) {
    Level level =
        freePlayLevels.elementAt(Random().nextInt(freePlayLevels.length - 1));
    return PlaySessionScreen(level, '/freeplay/won');
  }
}
