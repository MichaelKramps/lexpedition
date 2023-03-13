import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/party/party_db_connection.dart';

class TutorialCompletePlayerMenu extends StatelessWidget {
  const TutorialCompletePlayerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          determinePartyButton(context),
          SizedBox(width: Constants.smallFont),
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
      ),
    );
  }

  Widget determinePartyButton(BuildContext context) {
    PartyDatabaseConnection partyDatabaseConnection = PartyDatabaseConnection();

    if (partyDatabaseConnection.isNull()) {
      return ElevatedButton(
        onPressed: () {
          GoRouter.of(context).push('/party');
        },
        child: const Text('Play with a Friend'),
      );
    } else {
      return ElevatedButton(
        onPressed: () {
          partyDatabaseConnection.leaveParty();
        },
        child: const Text('Play Solo'),
      );
    }
  }
}
