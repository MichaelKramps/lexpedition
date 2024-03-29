import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:lexpedition/src/game_data/button_push.dart';
import 'package:lexpedition/src/game_data/game_level.dart';
import 'package:lexpedition/src/party/lexpedition_data_message.dart';

typedef void StreamStateCallback(MediaStream stream);

class RealTimeCommunication {
  Map<String, dynamic> configuration = {
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302'
        ]
      }
    ]
  };

  RTCPeerConnection? peerConnection;
  RTCVideoRenderer localRenderer = RTCVideoRenderer();
  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  RTCDataChannel? _dataChannel;
  MediaStream? localStream;
  MediaStream? remoteStream;
  String roomId = '';
  bool isPartyLeader = true;
  bool isConnected = false;
  late Function notifyListeners;
  late Function(GameLevel) loadPuzzleFromPeerUpdate;
  late Function(ButtonPush, int?) pushButtonFromPeerUpdate;
  int numberLocalIceCandidates = 0;
  StreamStateCallback? onAddRemoteStream;
  late DatabaseReference roomDbReference;

  RealTimeCommunication() {
    localRenderer.initialize();
    remoteRenderer.initialize();
    ;
  }

  void setGameStateFunctions(
      {required Function notifyListeners,
      required Function(GameLevel) loadPuzzleFromPeerUpdate,
      required Function(ButtonPush, int?) pushButtonFromPeerUpdate}) {
    this.notifyListeners = notifyListeners;
    this.loadPuzzleFromPeerUpdate = loadPuzzleFromPeerUpdate;
    this.pushButtonFromPeerUpdate = pushButtonFromPeerUpdate;
  }

  void addRoomId(String roomId) {
    this.roomId = roomId;
    this.roomDbReference = FirebaseDatabase.instance.ref('rooms/' + roomId);
  }

  Future<void> createRoom() async {
    this.isPartyLeader = true;
    peerConnection = await createPeerConnection(configuration);
    _dataChannel = await peerConnection!
        .createDataChannel('peerData', RTCDataChannelInit());
    _dataChannel!.onMessage = (RTCDataChannelMessage dataMessage) {
      handleDataChannelMessage(LexpeditionDataMessage(dataMessage));
    };

    registerPeerConnectionListeners();

    localStream?.getTracks().forEach((track) {
      peerConnection?.addTrack(track, localStream!);
    });

    //create new room
    RTCSessionDescription offer = await peerConnection!.createOffer();
    await peerConnection!.setLocalDescription(offer);

    //updating database with offer
    await roomDbReference.child('offer').update(offer.toMap());

    //listen for remote session description
    roomDbReference.child('answer').onValue.listen((DatabaseEvent event) {
      //Got updated room
      try {
        DataSnapshot answerSnapshot = event.snapshot;
        if (answerSnapshot.value != null) {
          peerConnection?.setRemoteDescription(RTCSessionDescription(
              answerSnapshot.child('sdp').value as String,
              answerSnapshot.child('type').value as String));
        }
      } catch (e) {
        //problem updating room on remote update
      }
    });

    //listen for remote ICE candidates
    roomDbReference
        .child('/calleeCandidates')
        .onValue
        .listen((DatabaseEvent event) {
      String iceIndex = event.snapshot.children.length.toString();
      String? candidate = null;
      try {
        candidate = event.snapshot
            .child(iceIndex.toString())
            .child('candidate')
            .value as String;
      } catch (e) {}

      String? sdpMid = null;
      try {
        sdpMid = event.snapshot.child(iceIndex.toString()).child('sdpMid').value
            as String;
      } catch (e) {}

      int? sdpMLineIndex = null;
      try {
        sdpMLineIndex = event.snapshot
            .child(iceIndex.toString())
            .child('sdpMLineIndex')
            .value as int;
      } catch (e) {}

      if (candidate != null && sdpMid != null && sdpMLineIndex != null) {
        peerConnection!
            .addCandidate(RTCIceCandidate(candidate, sdpMid, sdpMLineIndex));
      }
    });
  }

  Future<void> joinRoom() async {
    this.isPartyLeader = false;
    peerConnection = await createPeerConnection(configuration);
    registerPeerConnectionListeners();

    localStream?.getTracks().forEach((MediaStreamTrack track) {
      peerConnection?.addTrack(track, localStream!);
    });

    //create SDP answer
    DataSnapshot offerSnapshot = await roomDbReference.child('offer').get();

    try {
      await peerConnection?.setRemoteDescription(RTCSessionDescription(
          offerSnapshot.child('sdp').value as String,
          offerSnapshot.child('type').value as String));
    } catch (e) {}

    RTCSessionDescription answer = await peerConnection!.createAnswer();
    peerConnection!.setLocalDescription(answer);

    await roomDbReference.child('answer').update(answer.toMap());

    //listen for remote ICE candidates
    roomDbReference
        .child('/callerCandidates')
        .onValue
        .listen((DatabaseEvent event) {
      int numberCandidates = event.snapshot.children.length;
      String? candidate = null;
      for (int iceIndex = 1; iceIndex <= numberCandidates; iceIndex++) {
        try {
          candidate = event.snapshot
              .child(iceIndex.toString())
              .child('candidate')
              .value as String;
        } catch (e) {}

        String? sdpMid = null;
        try {
          sdpMid = event.snapshot
              .child(iceIndex.toString())
              .child('sdpMid')
              .value as String;
        } catch (e) {}

        int? sdpMLineIndex = null;
        try {
          sdpMLineIndex = event.snapshot
              .child(iceIndex.toString())
              .child('sdpMLineIndex')
              .value as int;
        } catch (e) {}

        if (candidate != null && sdpMid != null && sdpMLineIndex != null) {
          peerConnection!
              .addCandidate(RTCIceCandidate(candidate, sdpMid, sdpMLineIndex));
        }
      }
    });
  }

  Future<void> openUserMedia() async {
    MediaStream stream = await navigator.mediaDevices
        .getUserMedia({'video': true, 'audio': true});

    localRenderer.srcObject = stream;
    localStream = stream;

    remoteRenderer.srcObject = await createLocalMediaStream('key');

    notifyListeners();
  }

  Future<void> hangUp() async {
    this.isPartyLeader = true;
    this.isConnected = false;
    this.roomId = '';

    List<MediaStreamTrack> tracks = localRenderer.srcObject!.getTracks();
    tracks.forEach((track) {
      track.stop();
    });

    if (remoteStream != null) {
      remoteStream!.getTracks().forEach((track) {
        track.stop();
      });
    }

    if (peerConnection != null) {
      peerConnection!.close();
    }

    //delete entries into the database
    if (this.isPartyLeader) {
      roomDbReference.remove();
    } else {
      roomDbReference.child('/calleeCandidates').remove();
    }

    localStream!.dispose();
    remoteStream!.dispose();

    notifyListeners();
  }

  void registerPeerConnectionListeners() {
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      //ICE gathering state change
    };

    peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      numberLocalIceCandidates++;
      if (this.isPartyLeader) {
        roomDbReference
            .child('/callerCandidates')
            .update({numberLocalIceCandidates.toString(): candidate.toMap()});
      } else {
        roomDbReference
            .child('/calleeCandidates')
            .update({numberLocalIceCandidates.toString(): candidate.toMap()});
      }
    };

    peerConnection?.onTrack = (RTCTrackEvent event) {
      event.streams[0].getTracks().forEach((track) {
        remoteStream?.addTrack(track);
      });
    };

    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
        this.isConnected = true;
        notifyListeners();
      } else {
        this.isConnected = false;
        notifyListeners();
      }
    };

    peerConnection?.onSignalingState = (RTCSignalingState state) {
      //Signaling state change
    };

    peerConnection?.onIceConnectionState = (RTCIceConnectionState state) {
      //'ICE connection state change
    };

    peerConnection?.onAddStream = (MediaStream remoteStream) {
      this.remoteStream = remoteStream;
      remoteRenderer.srcObject = this.remoteStream;
      notifyListeners();
    };

    peerConnection?.onDataChannel = (RTCDataChannel channel) {
      _dataChannel = channel;
      _dataChannel!.onMessage = (RTCDataChannelMessage dataMessage) {
        handleDataChannelMessage(LexpeditionDataMessage(dataMessage));
      };
    };
  }

  void handleDataChannelMessage(LexpeditionDataMessage message) {
    if (message.type == LexpeditionDataMessageType.loadLevel) {
      //handle level load data
      GameLevel level = GameLevel.fromPeer(message.text);
      loadPuzzleFromPeerUpdate(level);
    } else if (message.type == LexpeditionDataMessageType.buttonPush) {
      //handle button push
      pushButtonFromPeerUpdate(message.buttonPush, message.tileIndexSelected);
    } else {
      //handle raw data
    }
  }

  void sendPuzzleToPeer(GameLevel level) {
    if (this.isConnected) {
      LexpeditionDataMessage thisMessage =
          LexpeditionDataMessage.fromLoadLevelData(level.rtcEncode());
      _dataChannel
          ?.send(RTCDataChannelMessage(thisMessage.createMessageText()));
    }
  }

  void sendButtonPushToPeer(
      {required ButtonPush buttonPushed, int? tileIndex}) {
    LexpeditionDataMessage thisMessage = LexpeditionDataMessage.fromButtonPush(
        buttonPushed: buttonPushed, tileIndex: tileIndex);
    _dataChannel?.send(RTCDataChannelMessage(thisMessage.createMessageText()));
  }
}
