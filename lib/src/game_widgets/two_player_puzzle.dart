import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/game_data/levels.dart';
import 'package:lexpedition/src/level_info/free_play_levels.dart';
import 'package:lexpedition/src/party/party_db_connection.dart';
import 'package:lexpedition/src/play_session/two_player_play_session_screen.dart';
import 'package:logging/logging.dart';

class TwoPlayerPuzzle extends StatefulWidget {
  const TwoPlayerPuzzle({super.key});

  @override
  State<TwoPlayerPuzzle> createState() => _TwoPlayerPuzzleState();
}

class _TwoPlayerPuzzleState extends State<TwoPlayerPuzzle> {
  LetterGrid? _theirUpdatedLetterGrid = null;
  LetterGrid? _myUpdatedLetterGrid = null;

  @override
  void initState() {
    PartyDatabaseConnection partyDatabaseConnection = PartyDatabaseConnection();

    if (partyDatabaseConnection.isPartyLeader) {
      GameLevel levelA =
          freePlayLevels.elementAt(Random().nextInt(freePlayLevels.length));
      GameLevel levelB =
          freePlayLevels.elementAt(Random().nextInt(freePlayLevels.length));

      partyDatabaseConnection.loadPuzzleForPlayers(
          gridCodeListA: levelA.gridCode, gridCodeListB: levelB.gridCode);

      updateGrids(
          theirLetterGrid: LetterGrid.fromLiveDatabase(levelB.gridCode, []),
          myLetterGrid: LetterGrid.fromLiveDatabase(levelA.gridCode, []));
    }

    partyDatabaseConnection.listenForPuzzle(updateGrids);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    new Logger('tpp').info('building TwoPlayerPuzzle');
    TwoPlayerPlaySessionScreen twoPlayerScreen = new TwoPlayerPlaySessionScreen(
        myLetterGrid: _myUpdatedLetterGrid,
        theirLetterGrid: _theirUpdatedLetterGrid);

    return Scaffold(body: twoPlayerScreen);
  }

  void updateGrids(
      {LetterGrid? myLetterGrid, required LetterGrid theirLetterGrid}) {
    setState(() {
      if (myLetterGrid != null) {
        _myUpdatedLetterGrid = myLetterGrid;
      }
      _theirUpdatedLetterGrid = theirLetterGrid;
    });
  }
}
