import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/game_data/levels.dart';
import 'package:lexpedition/src/level_info/free_play_levels.dart';
import 'package:lexpedition/src/party/party_db_connection.dart';
import 'package:lexpedition/src/play_session/two_player_play_session_screen.dart';

class TwoPlayerPuzzle extends StatefulWidget {
  const TwoPlayerPuzzle({super.key});

  @override
  State<TwoPlayerPuzzle> createState() => _TwoPlayerPuzzleState();
}

class _TwoPlayerPuzzleState extends State<TwoPlayerPuzzle> {
  @override
  Widget build(BuildContext context) {
    PartyDatabaseConnection partyDatabaseConnection = PartyDatabaseConnection();

    Level levelA =
        freePlayLevels.elementAt(Random().nextInt(freePlayLevels.length));
    Level levelB =
        freePlayLevels.elementAt(Random().nextInt(freePlayLevels.length));

    partyDatabaseConnection.loadPuzzleForPlayers(gridCodeListA: levelA.gridCode, gridCodeListB: levelB.gridCode);

    TwoPlayerPlaySessionScreen twoPlayerScreen = new TwoPlayerPlaySessionScreen(
        myLetterGrid: LetterGrid(levelA.gridCode, levelA.difficulty),
        theirLetterGrid: LetterGrid(levelB.gridCode, levelB.difficulty));

    return Scaffold(body: twoPlayerScreen);
  }
}
