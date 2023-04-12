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
  RTCScreenState _screenState = RTCScreenState.both;

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
              GestureDetector(
                onTap: () {
                  setState(() {
                    _screenState = _screenState == RTCScreenState.both
                        ? RTCScreenState.mine
                        : RTCScreenState.both;
                  });
                },
                child: SizedBox(
                    height: determineHeight(true),
                    width: determineWidth(true),
                    child: DecoratedBox(
                        decoration: BoxDecoration(color: Color.fromARGB(255, 211, 240, 255)),
                        child: RTCVideoView(realTimeCommunication.localRenderer,
                            mirror: true))),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _screenState = _screenState == RTCScreenState.both
                        ? RTCScreenState.theirs
                        : RTCScreenState.both;
                  });
                },
                child: SizedBox(
                    height: determineHeight(false),
                    width: determineWidth(false),
                    child: DecoratedBox(
                        decoration: BoxDecoration(color: Color.fromARGB(255, 219, 219, 219)),
                        child: RTCVideoView(
                            realTimeCommunication.remoteRenderer))),
              )
            ],
          )
        ]));
      } else {
        return Container();
      }
    });
  }

  double determineHeight(bool myScreen) {
    if (_screenState == RTCScreenState.both) {
      return 80;
    } else if (_screenState == RTCScreenState.mine) {
      return myScreen ? 160 : 0;
    } else {
      return myScreen ? 0 : 160;
    }
  }

  double determineWidth(bool myScreen) {
    if (_screenState == RTCScreenState.both) {
      return 120;
    } else if (_screenState == RTCScreenState.mine) {
      return myScreen ? 240 : 0;
    } else {
      return myScreen ? 0 : 240;
    }
  }
}

enum RTCScreenState { both, mine, theirs }
