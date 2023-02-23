import 'package:flutter/material.dart';
import 'package:lexpedition/src/build_puzzle/blank_grid.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/party/party_db_connection.dart';
import 'package:lexpedition/src/play_session/two_player_play_session_screen.dart';
import 'package:logging/logging.dart';
import 'package:wakelock/wakelock.dart';

class JoinPartyScreen extends StatefulWidget {
  const JoinPartyScreen({super.key});

  @override
  State<JoinPartyScreen> createState() => _JoinPartyScreenState();
}

class _JoinPartyScreenState extends State<JoinPartyScreen> {
  bool _joined = false;
  PartyDatabaseConnection? _partyConnection = null;
  final _textController = TextEditingController();
  LetterGrid? _myGrid = null;
  LetterGrid _theirGrid = LetterGrid(blankGrid, 1);

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
    return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Visibility(
          visible: !_joined,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                    _partyConnection = await PartyDatabaseConnection.joinParty(
                        partyCode: partyCode);
                    setState(() {
                      _joined = true;
                    });
                    _partyConnection?.listenForPuzzle(updateGrids);
                  }
                },
                child: Text('Join'))
          ])),
      Visibility(
          visible: _joined,
          child: TwoPlayerPlaySessionScreen(
            myLetterGrid: _myGrid,
            theirLetterGrid: _theirGrid,
          ))
    ]));
  }

  void updateGrids(
      {LetterGrid? myLetterGrid, required LetterGrid theirLetterGrid}) {
    setState(() {
      if (myLetterGrid != null) {
        _myGrid = myLetterGrid;
      }
      _theirGrid = theirLetterGrid;
    });
  }
}
