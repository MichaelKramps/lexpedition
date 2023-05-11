import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:lexpedition/src/user_interface/basic_user_interface_button.dart';
import 'package:provider/provider.dart';

class StartPartyScreen extends StatefulWidget {
  const StartPartyScreen({super.key});

  @override
  State<StartPartyScreen> createState() => _StartPartyScreenState();
}

class _StartPartyScreenState extends State<StartPartyScreen> {
  late String _partyCode = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Constants.defaultBackground,
            Column(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                Text('Invite My Friend to Play', style: TextStyle(fontSize: Constants.headerFontSize)),
                SizedBox(height: 48),
                Visibility(
                  visible: _partyCode.length > 0,
                  child: Column(children: [
                    Text('My share code: ' + _partyCode, style: TextStyle(fontSize: Constants.mediumFont, color: Colors.green)),
                    Text(
                        'You must give this share code to you partner.\nThey will enter it on the "Join Friend" page.',
                        style: TextStyle(fontSize: Constants.smallFont, color: Colors.black)),
                  ])),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Consumer<GameState>(
                        builder: (context, gameState, child) {
                      return BasicUserInterfaceButton(
                          onPressed: () async {
                            String newPartyCode = buildPartyCode();

                            setState(() {
                              _partyCode = newPartyCode;
                            });

                            gameState.realTimeCommunication.addRoomId(newPartyCode);
                            await gameState.realTimeCommunication.openUserMedia();
                            await gameState.realTimeCommunication.createRoom();
                          },
                          buttonText: 'Get a Share Code');
                    }),
                    SizedBox(width: 25),
                    BasicUserInterfaceButton(
                      onPressed: () {
                        GoRouter.of(context).pop();
                      },
                      buttonText: 'Back'),
                  ],
                )
    ]),
          ],
        ));
  }

  TextStyle getTextStyle() {
    return TextStyle(fontSize: Constants.smallFont, color: Colors.green);
  }

  String buildPartyCode() {
    List<String> chars = [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
      'X',
      'Y',
      'Z'
    ];

    String partyCode = '';
    Random random = new Random();

    for (int char = 0; char < 6; char++) {
      partyCode += chars[random.nextInt(chars.length)];
    }

    return partyCode;
  }
}
