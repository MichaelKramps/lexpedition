import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:lexpedition/src/party/party_db_connection.dart';
import 'package:logging/logging.dart';

typedef void StreamStateCallback(MediaStream stream);

class RealTimeCommunication extends ChangeNotifier {
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
  MediaStream? localStream;
  MediaStream? remoteStream;
  String roomId = '';
  int numberLocalIceCandidates = 0;
  StreamStateCallback? onAddRemoteStream;
  late DatabaseReference roomDbReference;
  Logger _log = new Logger('RTC class');

  RealTimeCommunication() {
    localRenderer.initialize();
    remoteRenderer.initialize();
    notifyListeners();
  }

  void addRoomId(String roomId) {
    this.roomId = roomId;
    this.roomDbReference = FirebaseDatabase.instance.ref('rooms/' + roomId);
  }

  Future<void> createRoom() async {
    peerConnection = await createPeerConnection(configuration);
    registerPeerConnectionListeners();

    localStream?.getTracks().forEach((track) {
      peerConnection?.addTrack(track, localStream!);
    });

    //create new room
    RTCSessionDescription offer = await peerConnection!.createOffer();
    await peerConnection!.setLocalDescription(offer);

    _log.info('updating database with offer');
    await roomDbReference.child('offer').update(offer.toMap());

    //listen for remote session description
    roomDbReference.child('answer').onValue.listen((DatabaseEvent event) {
      _log.info('Got updated room: ');
      try {
        DataSnapshot answerSnapshot = event.snapshot;
        if (answerSnapshot.value != null) {
          peerConnection?.setRemoteDescription(RTCSessionDescription(
              answerSnapshot.child('sdp').value as String,
              answerSnapshot.child('type').value as String));
        }
      } catch (e) {
        _log.info('problem updating room on remote update');
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
          _log.info('adding candidate');
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
    if (PartyDatabaseConnection().isPartyLeader) {
      roomDbReference.remove();
    } else {
      roomDbReference.child('/calleeCandidates').remove();
    }

    localStream!.dispose();
    remoteStream!.dispose();
  }

  void registerPeerConnectionListeners() {
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      _log.info('ICE gathering state change: ' + state.toString());
    };

    peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      numberLocalIceCandidates++;
      if (PartyDatabaseConnection().isPartyLeader) {
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
      _log.info('Got remote track: ' + event.streams[0].toString());
      _log.info(
          'connection state: ' + peerConnection!.connectionState.toString());
      event.streams[0].getTracks().forEach((track) {
        _log.info('Add track to remote stream: ' + track.toString());
        remoteStream?.addTrack(track);
      });
    };

    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      _log.info('Connection state change: ' + state.toString());
    };

    peerConnection?.onSignalingState = (RTCSignalingState state) {
      _log.info('Signaling state change: ' + state.toString());
    };

    peerConnection?.onIceConnectionState = (RTCIceConnectionState state) {
      _log.info('ICE connection state change: ' + state.toString());
    };

    peerConnection?.onAddStream = (MediaStream remoteStream) {
      _log.info('Add remote stream');
      this.remoteStream = remoteStream;
      remoteRenderer.srcObject = this.remoteStream;
      notifyListeners();
    };
  }
}
