import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_widgets/game_instance_widget.dart';
import 'package:lexpedition/src/play_session/two_player_play_session_screen.dart';

class TwoPlayerRightColumnWidget extends StatelessWidget {
  final GameInstanceWidgetStateManager? gameInstanceWidgetStateManager;
  final TwoPlayerPlaySessionStateManager twoPlayerPlaySessionStateManager;

  const TwoPlayerRightColumnWidget(
      {super.key, this.gameInstanceWidgetStateManager, required this.twoPlayerPlaySessionStateManager});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () => twoPlayerPlaySessionStateManager.toggleScreen(), child: Text('Switch'));
  }
}
