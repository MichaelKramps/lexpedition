import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_widgets/two_player_puzzle.dart';
import 'package:lexpedition/src/party/party_db_connection.dart';
import 'package:wakelock/wakelock.dart';

class JoinPartyScreen extends StatefulWidget {
  const JoinPartyScreen({super.key});

  @override
  State<JoinPartyScreen> createState() => _JoinPartyScreenState();
}

class _JoinPartyScreenState extends State<JoinPartyScreen> {
  bool _joined = PartyDatabaseConnection().listener != null;
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
      return TwoPlayerPuzzle();
    } else {
      return Scaffold(
          body: SizedBox.expand(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
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
                      await PartyDatabaseConnection.joinParty(partyCode: partyCode);
                      setState(() {
                        _joined = true;
                      });
                    }
                  },
                  child: Text('Join'))
            ])
        )
      );
    }
  }
}
