import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/error_definitions.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:lexpedition/src/play_session/two_player_play_session_screen.dart';
import 'package:lexpedition/src/user_interface/basic_user_interface_button.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

class JoinPartyScreen extends StatefulWidget {
  const JoinPartyScreen({super.key});

  @override
  State<JoinPartyScreen> createState() => _JoinPartyScreenState();
}

class _JoinPartyScreenState extends State<JoinPartyScreen> {
  bool _submittedCode = false;
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
    return Consumer<GameState>(builder: (context, gameState, child) {
      if (gameState.realTimeCommunication.isConnected) {
        return TwoPlayerPlaySessionScreen();
      } else {
        return Scaffold(
            body: Stack(
          children: [
            Constants.defaultBackground,
            SizedBox.expand(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Text('Enter Share Code from Friend',
                      style: TextStyle(fontSize: Constants.bigFont)),
                  SizedBox(height: 48),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    SizedBox(
                        width: 300,
                        child: TextField(
                            controller: _textController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Party Code"))),
                    SizedBox(width: 12),
                    BasicUserInterfaceButton(
                        onPressed: () async {
                          String partyCode = _textController.text.toUpperCase();

                          if (_submittedCode) {
                            setState(() {
                              _submittedCode = false;
                            });
                          }

                          if (gameState.errorDefinition !=
                              ErrorDefinition.noError) {
                            gameState.resetError();
                          }

                          gameState.realTimeCommunication.addRoomId(partyCode);
                          try {
                            await gameState.realTimeCommunication
                                .openUserMedia();
                            await gameState.realTimeCommunication.joinRoom();
                            setState(() {
                              _submittedCode = true;
                            });
                          } catch (e) {
                            gameState
                                .setError(ErrorDefinition.peerConnectionError);
                            gameState.realTimeCommunication.hangUp();
                          }
                        },
                        buttonText: 'Join'),
                    SizedBox(width: 12),
                    BasicUserInterfaceButton(
                        buttonText: 'Back',
                        onPressed: () => {GoRouter.of(context).pop()})
                  ]),
                  Visibility(
                      visible: _submittedCode,
                      child: Text('Attempting to connect to partner...')),
                  Visibility(
                      visible: gameState.errorDefinition ==
                          ErrorDefinition.peerConnectionError,
                      child: Text(
                          'There was a problem connecting. Try re-entering your code.'))
                ])),
          ],
        ));
      }
    });
  }
}
