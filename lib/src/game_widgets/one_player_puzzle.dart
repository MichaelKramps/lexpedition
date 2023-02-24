import 'dart:math';

import 'package:flutter/src/widgets/framework.dart';
import 'package:lexpedition/src/game_data/levels.dart';
import 'package:lexpedition/src/level_info/free_play_levels.dart';
import 'package:lexpedition/src/party/party_db_connection.dart';
import 'package:lexpedition/src/play_session/one_player_play_session_screen.dart';

class OnePlayerPuzzle extends StatelessWidget {
  const OnePlayerPuzzle({super.key});

  @override
  Widget build(BuildContext context) {
    PartyDatabaseConnection partyDatabaseConnection = PartyDatabaseConnection();

    Level level =
        freePlayLevels.elementAt(Random().nextInt(freePlayLevels.length));

    partyDatabaseConnection.loadPuzzleForPlayers(gridCodeListA: level.gridCode);

    return new OnePlayerPlaySessionScreen(level, '/freeplaywon');
  }
}
