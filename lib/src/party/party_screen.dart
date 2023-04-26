import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/game_state.dart';
import 'package:provider/provider.dart';
import 'package:lexpedition/src/user_interface/basic_user_interface_button.dart';

class PartyScreen extends StatelessWidget {
  const PartyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(builder: (context, gameState, child) {
      return Scaffold(
          body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Visibility(
            visible: gameState.realTimeCommunication.roomId != '',
            child: Text(
                'Your partner code is ' + gameState.realTimeCommunication.roomId)),
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
    });
  }
}
