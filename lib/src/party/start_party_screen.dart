import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lexpedition/src/game_data/constants.dart';

class StartPartyScreen extends StatefulWidget {
  const StartPartyScreen({super.key});

  @override
  State<StartPartyScreen> createState() => _StartPartyScreenState();
}

class _StartPartyScreenState extends State<StartPartyScreen> {
  late String _shareCode = '';
  late DatabaseReference? _database = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () => {
                        setState(() {
                          _shareCode = buildShareCode();
                          _database = FirebaseDatabase.instance
                              .ref('shareCode/' + _shareCode);
                        })
                      },
                  child: Text('Get Code')),
              SizedBox(width: 25),
              Text(_shareCode, style: getTextStyle())
            ],
          ),
          Text(
              'You must give this share code to you partner. They will enter it on the "Join Party" page.',
              style: getTextStyle())
        ]
      )
    );
  }

  TextStyle getTextStyle() {
    return TextStyle(
        fontSize: Constants.smallFont, color: Colors.black);
  }

  String buildShareCode() {
    List<String> chars = [
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
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

    String shareCode = '';
    Random random = new Random();

    for (int char = 0; char < 8; char++) {
      shareCode += chars[random.nextInt(chars.length)];
    }

    return shareCode;
  }
}
