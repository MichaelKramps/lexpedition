import 'dart:async';
import 'dart:math';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class VoiceCaller {
  static const String _appId = 'c5d461ad74ad419e8597de4dca8aa98f';
  static const String _token = 'b4b0f6ddaf1a4e79af0967fa4bd96a8b';
  String channelName = '';

  int _uid = 0;
  int? _remoteUid;
  bool _isJoined = false;
  late RtcEngine agoraEngine;

  static VoiceCaller caller = VoiceCaller.nullConstructor();

  factory VoiceCaller() {
    return caller;
  }

  VoiceCaller.withChannel({required this.channelName}) {
    this._uid = new Random().nextInt(9999999);
    caller = this;
  }

  VoiceCaller.nullConstructor() {}

  Future<void> setupVoiceSDKEngine() async {
    // retrieve or request microphone permission
    await [Permission.microphone].request();

    //create an instance of the Agora engine
    RtcEngine agoraEngine = createAgoraRtcEngine();
    await agoraEngine
        .initialize(const RtcEngineContext(appId: VoiceCaller._appId));

    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          _isJoined = true;
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          _remoteUid = remoteUid;
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          _remoteUid = null;
        },
      ),
    );
  }

  void join() async {
    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );

    await agoraEngine.joinChannel(
      token: VoiceCaller._token,
      channelId: channelName,
      options: options,
      uid: _uid,
    );
  }

  void leave() {
    _isJoined = false;
    _remoteUid = null;
    agoraEngine.leaveChannel();
  }
}
