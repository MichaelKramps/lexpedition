import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/build_puzzle/blank_grid.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/game_widgets/letter_tile_widget.dart';
import 'package:lexpedition/src/party/party_db_connection.dart';

class JoinPartyScreen extends StatefulWidget {
  const JoinPartyScreen({super.key});

  @override
  State<JoinPartyScreen> createState() => _JoinPartyScreenState();
}

class _JoinPartyScreenState extends State<JoinPartyScreen> {
  bool _joined = false;
  PartyDatabaseConnection? _partyConnection = null;
  final _textController = TextEditingController();
  LetterGrid _grid = LetterGrid(blankGrid, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
            width: 300,
            child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Party Code"))),
        ElevatedButton(
            onPressed: () async {
              String partyCode = _textController.text.toUpperCase();
              if (await PartyDatabaseConnection.canJoinParty(partyCode)) {
                _partyConnection = await PartyDatabaseConnection.joinParty(
                    partyCode: partyCode);
                setState(() {
                  _joined = true;
                });
                _partyConnection?.listenForPuzzle(updateGrid);
              }
            },
            child: Text('Join')),
        ElevatedButton(
            onPressed: () async {
              _partyConnection?.leaveParty();
              GoRouter.of(context).push('/');
            },
            child: Text('Leave'))
      ]),
      Visibility(
          visible: _joined,
          child: Column(children: [
            for (var row in _grid.rows) ...[
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (var letterTile in row) ...[
                  LetterTileWidget(
                      letterTile: letterTile,
                      sprayDirection: _grid.sprayDirection)
                ]
              ])
            ]
          ]))
    ]));
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void updateGrid(LetterGrid letterGrid) {
    setState(() {
      _grid = letterGrid;
    });
  }
}
