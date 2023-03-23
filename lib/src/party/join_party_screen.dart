import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:lexpedition/src/play_session/two_player_play_session_screen.dart';
import 'package:lexpedition/src/party/party_db_connection.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

class JoinPartyScreen extends StatefulWidget {
  const JoinPartyScreen({super.key});

  @override
  State<JoinPartyScreen> createState() => _JoinPartyScreenState();
}

class _JoinPartyScreenState extends State<JoinPartyScreen> {
  bool _joined = PartyDatabaseConnection().listener != null;
  bool _error = false;
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
  }

  @override
  void dispose() {
    _textController.dispose();
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_joined) {
      return Consumer<GameState>(builder: (context, gameState, child) {
        return TwoPlayerPlaySessionScreen(gameState: gameState);
      });
    } else {
      return Scaffold(
          body: SizedBox.expand(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                  width: 300,
                  child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Party Code"))),
              ElevatedButton(
                  onPressed: () async {
                    String partyCode = _textController.text.toUpperCase();
                    if (await PartyDatabaseConnection.canJoinParty(partyCode)) {
                      await PartyDatabaseConnection.joinParty(
                          partyCode: partyCode);

                      setState(() {
                        _joined = true;
                        _error = false;
                      });

                    } else {
                      setState(() {
                        _error = true;
                      });
                    }
                  },
                  child: Text('Join'))
            ]),
            Visibility(
                visible: _error,
                child: Text(
                    'Failed to join a party, please check your code and try again.'))
          ])));
    }
  }
}
