import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/build_puzzle/blank_grid.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/game_widgets/letter_tile_widget.dart';
import 'package:lexpedition/src/game_widgets/observer_letter_grid_widget.dart';
import 'package:lexpedition/src/party/party_db_connection.dart';
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
  LetterGrid _grid = LetterGrid(blankGrid, 1);

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
        body: Row(children: [
          Expanded(
            child: ListView(
              children: [
                SizedBox(height: 24),
                for (var guess in _grid.guesses.reversed) ...[
                  Center(child:Text(guess, style: TextStyle(fontSize: Constants.smallFont)))
                ]
              ]
            )
          ),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                child: ObserverLetterGridWidget(letterGrid: _grid)
              )
            ]
          ),
          Expanded(child: SizedBox())
        ]
      )
    );
  }

  void updateGrid(LetterGrid letterGrid) {
    setState(() {
      _grid = letterGrid;
    });
  }
}
