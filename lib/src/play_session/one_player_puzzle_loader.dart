import 'package:flutter/widgets.dart';
import 'package:lexpedition/src/game_data/levels.dart';
import 'package:lexpedition/src/level_info/level_db_connection.dart';
import 'package:lexpedition/src/party/party_db_connection.dart';
import 'package:lexpedition/src/play_session/one_player_play_session_screen.dart';

class OnePlayerPuzzleLoader extends StatefulWidget {
  const OnePlayerPuzzleLoader({super.key});

  @override
  State<OnePlayerPuzzleLoader> createState() => _OnePlayerPuzzleLoaderState();
}

class _OnePlayerPuzzleLoaderState extends State<OnePlayerPuzzleLoader> {
  GameLevel? _loadedLevel = null;

  @override
  Widget build(BuildContext context) {
    if (_loadedLevel != null) {
      return new OnePlayerPlaySessionScreen(_loadedLevel as GameLevel, '/freeplaywon');
    } else {
      loadOnePlayerPuzzle();
      return Container();
    }
  }

  Future<void> loadOnePlayerPuzzle() async {
    GameLevel level = await LevelDatabaseConnection.getOnePlayerPuzzle();

    PartyDatabaseConnection partyDatabaseConnection = PartyDatabaseConnection();
    partyDatabaseConnection.loadPuzzleForPlayers(level: level);

    setState(() {
      _loadedLevel = level;
    });
  }
}
