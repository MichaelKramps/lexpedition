import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/party/party_db_connection.dart';
import 'package:lexpedition/src/user_interface/basic_user_interface_button.dart';
import 'package:lexpedition/src/user_interface/generic_button.dart';

class TutorialCompletePlayerMenu extends StatefulWidget {
  const TutorialCompletePlayerMenu({super.key});

  @override
  State<TutorialCompletePlayerMenu> createState() =>
      _TutorialCompletePlayerMenuState();
}

class _TutorialCompletePlayerMenuState
    extends State<TutorialCompletePlayerMenu> {
  bool _areYouSure = false;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        checkToDisplayPartyCode(),
        determinePartyButton(context),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BasicUserInterfaceButton(
              onPressed: () {
                GoRouter.of(context).push('/lexpedition');
              },
              buttonText: 'LEXPEDITION',
            ),
            SizedBox(width: Constants.smallFont),
            BasicUserInterfaceButton(
              onPressed: () {
                GoRouter.of(context).push('/freeplay');
              },
              buttonText: "FREE PLAY",
            ),
            SizedBox(width: Constants.smallFont),
            BasicUserInterfaceButton(
              onPressed: () {
                GoRouter.of(context).push('/moremenu');
              },
              buttonText: "MORE...",
            )
          ],
        )
      ]),
      Visibility(
          visible: _areYouSure,
          child: Container(
              alignment: Alignment.center,
              color: Colors.amber,
              child: SizedBox.fromSize(
                  size: Size(360, 180),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          "Are you sure you want to disconnect from your partner?"),
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                PartyDatabaseConnection().leaveParty();
                                setState(() {
                                  _areYouSure = false;
                                });
                              },
                              child: Text("Yes")),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _areYouSure = false;
                                });
                              },
                              child: Text("No"))
                        ],
                      )
                    ],
                  ))))
    ]);
  }

  Widget determinePartyButton(BuildContext context) {
    PartyDatabaseConnection partyDatabaseConnection = PartyDatabaseConnection();

    if (partyDatabaseConnection.isNull()) {
      final ButtonStyle buttonStyle =
          TextButton.styleFrom(backgroundColor: Colors.amber);

      return ElevatedButton(
        onPressed: () {
          GoRouter.of(context).push('/party');
        },
        style: buttonStyle,
        child: const Text('Play with a Friend'),
      );
    } else {
      return BasicUserInterfaceButton(
        onPressed: () {
          setState(() {
            _areYouSure = true;
          });
        },
        buttonText: 'PLAY SOLO',
      );
    }
  }

  Widget checkToDisplayPartyCode() {
    PartyDatabaseConnection partyDatabaseConnection = PartyDatabaseConnection();
    if (partyDatabaseConnection.isNull() ||
        !partyDatabaseConnection.isPartyLeader) {
      return SizedBox();
    } else {
      return Text("Your partner code is " + partyDatabaseConnection.partyCode);
    }
  }
}
