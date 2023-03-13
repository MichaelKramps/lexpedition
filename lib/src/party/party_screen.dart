import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/party/party_db_connection.dart';

class PartyScreen extends StatelessWidget {
  const PartyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PartyDatabaseConnection partyDatabaseConnection = PartyDatabaseConnection();
    return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Visibility(
          visible: partyDatabaseConnection.partyCode != '',
          child:
              Text('Current Party Code: ' + partyDatabaseConnection.partyCode)),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () => GoRouter.of(context).push('/party/join'),
                child: Text('Enter Code')),
            SizedBox(width: Constants.smallFont),
            ElevatedButton(
                onPressed: () => GoRouter.of(context).push('/party/start'),
                child: Text('Invite Friend')),
            SizedBox(width: Constants.smallFont),
            ElevatedButton(
                onPressed: () => GoRouter.of(context).pop(),
                child: Text('Back'))
          ])
    ]));
  }
}
