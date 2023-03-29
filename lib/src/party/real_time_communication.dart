import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:lexpedition/src/party/party_db_connection.dart';
import 'package:logging/logging.dart';

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
  MediaStream? localStream;
  MediaStream? remoteStream;
  String roomId;
  int numberLocalIceCandidates = 0;
  StreamStateCallback? onAddRemoteStream;
  late DatabaseReference roomDbReference;
  Logger _log = new Logger('RTC class');

  RealTimeCommunication({required this.roomId}) {
    this.roomDbReference = FirebaseDatabase.instance.ref('rooms/' + roomId);
  }

  Future<void> createRoom(RTCVideoRenderer remoteRenderer) async {
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
    roomDbReference.onValue.listen((DatabaseEvent event) {
      _log.info('Got updated room: ');
      try {
        DataSnapshot answerSnapshot = event.snapshot.child('answer');
        peerConnection?.setRemoteDescription(
          RTCSessionDescription(answerSnapshot.child('sdp').value as String, answerSnapshot.child('type').value as String)
        );
      } catch (e) {}
    });

    //listen for remote ICE candidates
    roomDbReference
        .child('/calleeCandidates')
        .onValue
        .listen((DatabaseEvent event) {
      for (int iceIndex = 1;
          iceIndex < event.snapshot.children.length + 1;
          iceIndex++) {
        String? candidate = null;
        try {
          candidate = event.snapshot
              .child(iceIndex.toString())
              .child('candidate')
              .toString();
        } catch (e) {}

        String? sdpMid = null;
        try {
          sdpMid = event.snapshot
              .child(iceIndex.toString())
              .child('sdpMid')
              .toString();
        } catch (e) {}

        int? sdpMLineIndex = null;
        try {
          sdpMLineIndex = event.snapshot
              .child(iceIndex.toString())
              .child('sdpMLineIndex')
              .toString() as int;
        } catch (e) {}

        peerConnection!
            .addCandidate(RTCIceCandidate(candidate, sdpMid, sdpMLineIndex));
      }
    });
  }

  Future<void> joinRoom(RTCVideoRenderer remoteRenderer) async {
    //try {
      peerConnection = await createPeerConnection(configuration);
      registerPeerConnectionListeners();

      localStream?.getTracks().forEach((MediaStreamTrack track) {
        peerConnection?.addTrack(track, localStream!);
      });

      //create SDP answer
      DataSnapshot offerSnapshot = await roomDbReference.child('offer').get();

      await peerConnection?.setRemoteDescription(RTCSessionDescription(
          offerSnapshot.child('sdp').value as String,
          offerSnapshot.child('type').value as String));

      RTCSessionDescription answer = await peerConnection!.createAnswer();
      peerConnection!.setLocalDescription(answer);

      await roomDbReference.child('answer').update(answer.toMap());

      //listen for remote ICE candidates
      roomDbReference
          .child('/callerCandidates')
          .onValue
          .listen((DatabaseEvent event) {
        for (int iceIndex = 1;
            iceIndex < event.snapshot.children.length + 1;
            iceIndex++) {
          String? candidate = null;
          try {
            candidate = event.snapshot
                .child(iceIndex.toString())
                .child('candidate')
                .toString();
          } catch (e) {}

          String? sdpMid = null;
          try {
            sdpMid = event.snapshot
                .child(iceIndex.toString())
                .child('sdpMid')
                .toString();
          } catch (e) {}

          int? sdpMLineIndex = null;
          try {
            sdpMLineIndex = event.snapshot
                .child(iceIndex.toString())
                .child('sdpMLineIndex')
                .toString() as int;
          } catch (e) {}

          peerConnection!
              .addCandidate(RTCIceCandidate(candidate, sdpMid, sdpMLineIndex));
        }
      });
    //} catch (e) {
    //  _log.info('problem joining room');
    //}
  }

  Future<void> openUserMedia(
      RTCVideoRenderer localRenderer, RTCVideoRenderer remoteRenderer) async {
    MediaStream stream = await navigator.mediaDevices
        .getUserMedia({'video': true, 'audio': true});

    localRenderer.srcObject = stream;
    localStream = stream;

    remoteRenderer.srcObject = await createLocalMediaStream('key');
  }

  Future<void> hangUp(RTCVideoRenderer localRenderer) async {
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

    if (roomId != null) {
      //delete entries into the database
      if (PartyDatabaseConnection().isPartyLeader) {
        roomDbReference.remove();
      } else {
        roomDbReference.child('/calleeCandidates').remove();
      }
    }

    localStream!.dispose();
    remoteStream!.dispose();
  }

  void registerPeerConnectionListeners() {
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      _log.info('ICE gathering state change: ' + state.toString());
    };

    peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      _log.info('Got candidate!');
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
      onAddRemoteStream?.call(remoteStream);
      this.remoteStream = remoteStream;
    };
  }
}
