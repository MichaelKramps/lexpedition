import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/party/party_db_connection.dart';
import 'package:lexpedition/src/user_interface/basic_user_interface_button.dart';

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
              Text('Your partner code is ' + partyDatabaseConnection.partyCode)),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BasicUserInterfaceButton(
                onPressed: () => GoRouter.of(context).push('/party/join'),
                buttonText: 'Enter Code'),
            SizedBox(width: Constants.smallFont),
            BasicUserInterfaceButton(
                onPressed: () => GoRouter.of(context).push('/party/start'),
                buttonText: 'Invite Friend'),
            SizedBox(width: Constants.smallFont),
            BasicUserInterfaceButton(
                onPressed: () => GoRouter.of(context).pop(),
                buttonText: 'Back')
          ])
    ]));
  }
}
