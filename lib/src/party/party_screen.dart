import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:lexpedition/src/user_interface/basic_user_interface_button.dart';
import 'package:provider/provider.dart';

class PartyScreen extends StatelessWidget {
  const PartyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(builder: (context, gameState, child) {
      return Scaffold(
          body: Stack(
            children: [
              Constants.defaultBackground,
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Play with a Friend', style: TextStyle(fontSize: Constants.headerFontSize)),
                SizedBox(height: 48),
                Visibility(
                  visible: gameState.realTimeCommunication.roomId != '',
                  child: Text(
                      'Your partner code is ' + gameState.realTimeCommunication.roomId,
                      style: TextStyle(fontSize: Constants.mediumFont, color: Colors.green),)),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BasicUserInterfaceButton(
                        onPressed: () => GoRouter.of(context).push('/party/start'),
                        buttonText: 'Invite Friend'),
                    SizedBox(width: Constants.smallFont),
                    BasicUserInterfaceButton(
                        onPressed: () => GoRouter.of(context).push('/party/join'),
                        buttonText: 'Join Friend'),
                    SizedBox(width: Constants.smallFont),
                    BasicUserInterfaceButton(
                        onPressed: () => GoRouter.of(context).pop(),
                        buttonText: 'Back')
                ])
              ]),
            ],
          ));
    });
  }
}
