import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/error_definitions.dart';
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
        Image.asset(Constants.logoImagePath),
        SizedBox(height: 12),
        checkToDisplayPartyCode(),
        determinePartyButton(context, true),
        SizedBox(height: 24),
        Consumer<GameState>(builder: (context, gameState, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              determineLexpeditionButton(gameState),
              SizedBox(width: Constants.smallFont),
              determineFreePlayButton(gameState),
              SizedBox(width: Constants.smallFont),
              BasicUserInterfaceButton(
                onPressed: () {
                  GoRouter.of(context).push('/moremenu');
                },
                buttonText: 'More...',
              )
            ],
          );
        }),
        SizedBox(height: 24),
        determinePartyButton(context, false),
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

  Widget determineLexpeditionButton(GameState gameState) {
    if (gameState.realTimeCommunication.isConnected) {
      return FeaturedUserInterfaceButton(
        onPressed: () {
          GoRouter.of(context).push('/lexpedition');
        },
        buttonText: 'Lexpedition',
      );
    } else {
      return BasicUserInterfaceButton(
        onPressed: () async {
          await gameState.loadOnePlayerLexpedition();
          if (gameState.errorDefinition == ErrorDefinition.noError) {
            GoRouter.of(context).push('/freeplay/oneplayer');
          }
        },
        buttonText: 'Lexpedition',
      );
    }
  }

  Widget determineFreePlayButton(GameState gameState) {
    if (gameState.realTimeCommunication.isConnected) {
      return FeaturedUserInterfaceButton(
        onPressed: () async {
          await gameState.loadOnePlayerPuzzle();
          if (gameState.errorDefinition == ErrorDefinition.noError) {
            GoRouter.of(context).push('/freeplay/oneplayer');
          }
        },
        buttonText: 'Free Play',
      );
    } else {
      return BasicUserInterfaceButton(
        onPressed: () async {
          if (gameState.realTimeCommunication.isConnected) {
            GoRouter.of(context).push('/freeplay');
          } else {
            await gameState.loadOnePlayerPuzzle();
            if (gameState.errorDefinition == ErrorDefinition.noError) {
              GoRouter.of(context).push('/freeplay/oneplayer');
            }
          }
        },
        buttonText: 'Free Play',
      );
    }
  }

  Widget determinePartyButton(BuildContext context, bool topButton) {
    return Consumer<GameState>(builder: (context, gameState, child) {
      if (!gameState.realTimeCommunication.isConnected && topButton) {
        return FeaturedUserInterfaceButton(
          onPressed: () {
            GoRouter.of(context).push('/party');
          },
          buttonText: 'Play with a Friend',
        );
      } else if (gameState.realTimeCommunication.isConnected && !topButton) {
        return BasicUserInterfaceButton(
          onPressed: () {
            setState(() {
              _areYouSure = true;
            });
          },
          buttonText: 'Play Solo',
        );
      } else {
        return SizedBox.shrink();
      }
    });
  }

  Widget checkToDisplayPartyCode() {
    return Consumer<GameState>(builder: (context, gameState, child) {
      if (!gameState.realTimeCommunication.isConnected ||
          !gameState.realTimeCommunication.isPartyLeader ||
          gameState.realTimeCommunication.roomId != '') {
        return SizedBox();
      } else {
        return Text(
            "Your partner code is " + gameState.realTimeCommunication.roomId);
      }
    });
  }
}
