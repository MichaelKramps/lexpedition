import 'dart:math';

import 'package:flutter/material.dart';
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
  LetterGrid? _theirUpdatedLetterGrid = null;
  LetterGrid? _myUpdatedLetterGrid = null;

  @override
  void initState() {
    PartyDatabaseConnection partyDatabaseConnection = PartyDatabaseConnection();
    Level levelA =
        freePlayLevels.elementAt(Random().nextInt(freePlayLevels.length));
    Level levelB =
        freePlayLevels.elementAt(Random().nextInt(freePlayLevels.length));

    partyDatabaseConnection.loadPuzzleForPlayers(
        gridCodeListA: levelA.gridCode, gridCodeListB: levelB.gridCode);

    setState(() {
      _myUpdatedLetterGrid = LetterGrid(levelA.gridCode, 1);
      _theirUpdatedLetterGrid = LetterGrid(levelB.gridCode, 1);
    });

    partyDatabaseConnection.listenForPuzzle(updateGrids);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TwoPlayerPlaySessionScreen twoPlayerScreen = new TwoPlayerPlaySessionScreen(
        myLetterGrid: _myUpdatedLetterGrid,
        theirLetterGrid: _theirUpdatedLetterGrid);

    return Scaffold(body: twoPlayerScreen);
  }

  void updateGrids(
      {LetterGrid? myLetterGrid, required LetterGrid theirLetterGrid}) {
    setState(() {
      _theirUpdatedLetterGrid = theirLetterGrid;
    });
  }
}
