import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:lexpedition/src/party/real_time_communication.dart';
import 'package:provider/provider.dart';

class PartyVideoDisplayWidget extends StatefulWidget {
  const PartyVideoDisplayWidget({super.key});

  @override
  State<PartyVideoDisplayWidget> createState() =>
      _PartyVideoDisplayWidgetState();
}

class _PartyVideoDisplayWidgetState extends State<PartyVideoDisplayWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RealTimeCommunication>(
        builder: (context, realTimeCommunication, child) {
      if (realTimeCommunication.roomId.length > 0) {
        return Expanded(
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  height: 100,
                  width: 100,
                  child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.blueGrey),
                      child: RTCVideoView(realTimeCommunication.localRenderer,
                          mirror: true))),
              SizedBox(
                  height: 100,
                  width: 100,
                  child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.grey),
                      child:
                          RTCVideoView(realTimeCommunication.remoteRenderer)))
            ],
          )
        ]));
      } else {
        return Container();
      }
    });
  }
}
