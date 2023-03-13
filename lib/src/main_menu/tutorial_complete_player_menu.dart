import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/party/party_db_connection.dart';

class TutorialCompletePlayerMenu extends StatelessWidget {
  const TutorialCompletePlayerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        determinePartyButton(context),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).push('/lexpedition');
              },
              child: const Text('Lexpedition'),
            ),
            SizedBox(width: Constants.smallFont),
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).push('/freeplay');
              },
              child: const Text('Free Play'),
            ),
            SizedBox(width: Constants.smallFont),
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).push('/moremenu');
              },
              child: const Text('More...'),
            )
          ],
        )
      ]
    );
  }

  Widget determinePartyButton(BuildContext context) {
    PartyDatabaseConnection partyDatabaseConnection = PartyDatabaseConnection();

    if (partyDatabaseConnection.isNull()) {
      final ButtonStyle buttonStyle = TextButton.styleFrom(
        backgroundColor: Colors.amber);

      return ElevatedButton(
        onPressed: () {
          GoRouter.of(context).push('/party');
        },
        style: buttonStyle,
        child: const Text('Play with a Friend'),
      );
    } else {
      return ElevatedButton(
        onPressed: () {
          //TODO: ask if they really want to leave the party
          partyDatabaseConnection.leaveParty();
        },
        child: const Text('Play Solo'),
      );
    }
  }
}
