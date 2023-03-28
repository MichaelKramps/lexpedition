import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/party/party_db_connection.dart';
import 'package:lexpedition/src/party/real_time_communication.dart';
import 'package:logging/logging.dart';

class StartPartyScreen extends StatefulWidget {
  const StartPartyScreen({super.key});

  @override
  State<StartPartyScreen> createState() => _StartPartyScreenState();
}

class _StartPartyScreenState extends State<StartPartyScreen> {
  late RealTimeCommunication realTimeCommunication;
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  late String _partyCode = '';

  @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();

    super.initState();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () async {
                String newPartyCode = buildPartyCode();
                PartyDatabaseConnection partyConnection =
                    await PartyDatabaseConnection.startParty(
                        partyCode: newPartyCode);
                partyConnection.createPartyEntry();

                setState(() {
                  _partyCode = newPartyCode;
                  realTimeCommunication =
                      RealTimeCommunication(roomId: newPartyCode);
                });

                realTimeCommunication.onAddRemoteStream = (stream) {
                  _remoteRenderer.srcObject = stream;
                  setState(() {});
                };

                await realTimeCommunication.openUserMedia(
                    _localRenderer, _remoteRenderer);
                
                new Logger('start party').info('4');
                await realTimeCommunication.createRoom(_remoteRenderer);

                new Logger('start party').info('5');
              },
              child: Text('Get Code')),
          SizedBox(width: 25),
          Text(_partyCode, style: getTextStyle())
        ],
      ),
      Visibility(
          visible: _partyCode.length > 0,
          child: Column(children: [
            Text(
                'You must give this share code to you partner. They will enter it on the "Join Party" page.',
                style: getTextStyle()),
            ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).pop();
                },
                child: Text('Back'))
          ])),
      Expanded(child: RTCVideoView(_localRenderer, mirror: true))
    ]));
  }

  TextStyle getTextStyle() {
    return TextStyle(fontSize: Constants.smallFont, color: Colors.black);
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
