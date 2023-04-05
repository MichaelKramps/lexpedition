import 'package:flutter/material.dart';
import 'package:lexpedition/src/party/party_video_display_widget.dart';

class VideoCallWrapperWidget extends StatelessWidget {
  final Widget screen;

  VideoCallWrapperWidget({required this.screen, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        screen,
        PartyVideoDisplayWidget()
      ],
    );
  }
}
