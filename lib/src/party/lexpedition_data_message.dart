import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:lexpedition/src/game_data/constants.dart';

class LexpeditionDataMessage {
  LexpeditionDataMessageType type = LexpeditionDataMessageType.raw;
  String text = '';

  LexpeditionDataMessage(RTCDataChannelMessage rtcDataMessage) {
    //rtcDataMessage should have the format -> 'type:;:data'
    this.type = determineDataType(rtcDataMessage.text);
    this.text = determineText(rtcDataMessage.text);
  }

  LexpeditionDataMessage.fromGameData(String gameDataString) {
    this.type = LexpeditionDataMessageType.updateLevel;
    this.text = gameDataString;
  }

  LexpeditionDataMessage.fromLoadLevelData(String gameDataString) {
    this.type = LexpeditionDataMessageType.loadLevel;
    this.text = gameDataString;
  }

  LexpeditionDataMessage.fromBlastIndex(int blastIndex) {
    this.type = LexpeditionDataMessageType.blastIndex;
    this.text = blastIndex.toString();
  }

  LexpeditionDataMessage.fromAcceptedGuess(String acceptedGuess) {
    this.type = LexpeditionDataMessageType.acceptedGuess;
    this.text = acceptedGuess;
  }

  LexpeditionDataMessageType determineDataType(String rtcMessageText) {
    String typeString = rtcMessageText.split(Constants.rtcMessageSplitter)[0];

    switch (typeString) {
      case 'updateLevel':
        return LexpeditionDataMessageType.updateLevel;
      case 'loadLevel':
        return LexpeditionDataMessageType.loadLevel;
      case 'blastIndex':
        return LexpeditionDataMessageType.blastIndex;
      case 'acceptedGuess':
        return LexpeditionDataMessageType.acceptedGuess;
      default:
        return LexpeditionDataMessageType.raw;
    }
  }

  String dataTypeToString() {
    switch (this.type) {
      case LexpeditionDataMessageType.updateLevel:
        return 'updateLevel';
      case LexpeditionDataMessageType.loadLevel:
        return 'loadLevel';
      case LexpeditionDataMessageType.blastIndex:
        return 'blastIndex';
      case LexpeditionDataMessageType.acceptedGuess:
        return 'acceptedGuess';
      default:
        return 'raw';
    }
  }

  String determineText(String rtcMessageText) {
    List<String> splitText = rtcMessageText.split(Constants.rtcMessageSplitter);

    if (splitText.length == 2) {
      return splitText[1];
    } else {
      return '';
    }
  }

  String createMessageText() {
    return dataTypeToString() + Constants.rtcMessageSplitter + this.text;
  }
}

enum LexpeditionDataMessageType { updateLevel, loadLevel, blastIndex, acceptedGuess, raw }
