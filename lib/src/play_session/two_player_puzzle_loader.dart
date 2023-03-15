import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/game_data/game_level.dart';
import 'package:lexpedition/src/level_info/level_db_connection.dart';
import 'package:lexpedition/src/party/party_db_connection.dart';
import 'package:lexpedition/src/play_session/two_player_play_session_screen.dart';


class TwoPlayerPuzzleLoader extends StatefulWidget {
  const TwoPlayerPuzzleLoader({super.key});

  @override
  State<TwoPlayerPuzzleLoader> createState() => _TwoPlayerPuzzleLoaderState();
}

class _TwoPlayerPuzzleLoaderState extends State<TwoPlayerPuzzleLoader> {
  bool _initialLoad = true;
  bool _playerHasWon = false;
  PartyDatabaseConnection _partyDatabaseConnection = PartyDatabaseConnection();

  late DateTime _startOfPlay;

  @override
  void initState() {
    _startOfPlay = DateTime.now();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_initialLoad) {
      loadLevel();
    }

    return Container();
  }

  Future<void> loadLevel() async {
    if (_partyDatabaseConnection.isPartyLeader) {
      GameLevel level = await LevelDatabaseConnection.getTwoPlayerPuzzle();

      _partyDatabaseConnection.loadPuzzleForPlayers(level: level);

    }

    //_partyDatabaseConnection.listenForPuzzle(updateLevel);
  }

  /* void updateLevel(
      {LetterGrid? myLetterGrid,
      required LetterGrid theirLetterGrid,
      int? blastIndex,
      int? difficulty,
      double? averageGuesses,
      int? bestAttempt}) {
    if (myLetterGrid != null) {
      //should always mean player is getting a new puzzle
      setState(() {
        _gameLevel.setMyLetterGrid(myLetterGrid);
      });
    } else if (blastIndex != null && _gameLevel.getMyLetterGrid() != null) {
      //need to blast my puzzle based on partner's blast index
      setState(() {
        _gameLevel.getMyLetterGrid()?.blastFromIndex(blastIndex);
      });
      Future<void>.delayed(Constants.blastDuration, () {
        setState(() {
          _gameLevel.getMyLetterGrid()?.unblast();
        });
        _partyDatabaseConnection.updateMyPuzzle(
            letterGrid: _gameLevel.getMyLetterGrid() as LetterGrid);
      });
    }
    if (difficulty != null && averageGuesses != null && bestAttempt != null) {
      setState(() {
        _gameLevel.difficulty = difficulty;
        _gameLevel.averageGuesses = averageGuesses;
        _gameLevel.bestAttempt = bestAttempt;
        _gameLevel.setTheirLetterGrid(theirLetterGrid);
      });
    } else {
      setState(() {
        _gameLevel.setTheirLetterGrid(theirLetterGrid);
      });
    }

    if (!_playerHasWon) {
      checkForWinAtCorrectTime();
    }
  } */

  
}
