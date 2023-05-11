import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:lexpedition/src/user_interface/basic_user_interface_button.dart';
import 'package:lexpedition/src/user_interface/featured_user_interface_button.dart';
import 'package:provider/provider.dart';

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
      Constants.defaultBackground,
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        checkToDisplayPartyCode(),
        determinePartyButton(context),
        SizedBox(height: 36),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BasicUserInterfaceButton(
              onPressed: () {
                GoRouter.of(context).push('/lexpedition');
              },
              buttonText: 'Lexpedition',
            ),
            SizedBox(width: Constants.smallFont),
            BasicUserInterfaceButton(
              onPressed: () {
                GoRouter.of(context).push('/freeplay');
              },
              buttonText: 'Free Play',
            ),
            SizedBox(width: Constants.smallFont),
            BasicUserInterfaceButton(
              onPressed: () {
                GoRouter.of(context).push('/moremenu');
              },
              buttonText: 'More...',
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
                          Consumer<GameState>(
                              builder: (context, gameState, child) {
                            return BasicUserInterfaceButton(
                                onPressed: () {
                                  gameState.realTimeCommunication.hangUp();
                                  setState(() {
                                    _areYouSure = false;
                                  });
                                },
                                buttonText: "Yes");
                          }),
                          BasicUserInterfaceButton(
                              onPressed: () {
                                setState(() {
                                  _areYouSure = false;
                                });
                              },
                              buttonText: "No")
                        ],
                      )
                    ],
                  ))))
    ]);
  }

  Widget determinePartyButton(BuildContext context) {
    return Consumer<GameState>(builder: (context, gameState, child) {
      if (!gameState.realTimeCommunication.isConnected) {

        return FeaturedUserInterfaceButton(
          onPressed: () {
            GoRouter.of(context).push('/party');
          },
          buttonText: 'Play with a Friend',
        );
      } else {
        return BasicUserInterfaceButton(
          onPressed: () {
            setState(() {
              _areYouSure = true;
            });
          },
          buttonText: 'Play Solo',
        );
      }
    });
  }

  Widget checkToDisplayPartyCode() {
    return Consumer<GameState>(builder: (context, gameState, child) {
      if (!gameState.realTimeCommunication.isConnected ||
          !gameState.realTimeCommunication.isPartyLeader) {
        return SizedBox();
      } else {
        return Text(
            "Your partner code is " + gameState.realTimeCommunication.roomId);
      }
    });
  }
}
