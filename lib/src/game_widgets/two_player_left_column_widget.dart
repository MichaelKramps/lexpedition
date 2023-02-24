import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_widgets/game_instance_widget.dart';
import 'package:lexpedition/src/play_session/two_player_play_session_screen.dart';

class TwoPlayerLeftColumnWidget extends StatelessWidget {
  final GameInstanceWidgetStateManager? gameInstanceWidgetStateManager;
  final TwoPlayerPlaySessionStateManager twoPlayerPlaySessionStateManager;

  const TwoPlayerLeftColumnWidget({super.key, required this.twoPlayerPlaySessionStateManager, this.gameInstanceWidgetStateManager});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}