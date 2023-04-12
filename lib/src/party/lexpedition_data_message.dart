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
    this.type = LexpeditionDataMessageType.gameData;
    this.text = gameDataString;
  }

  LexpeditionDataMessageType determineDataType(String rtcMessageText) {
    String typeString = rtcMessageText.split(Constants.rtcMessageSplitter)[0];

    switch (typeString) {
      case 'gameData':
        return LexpeditionDataMessageType.gameData;
      case 'chat':
        return LexpeditionDataMessageType.chat;
      default:
        return LexpeditionDataMessageType.raw;
    }
  }

  String dataTypeToString() {
    switch (this.type) {
      case LexpeditionDataMessageType.gameData:
        return 'gameData';
      case LexpeditionDataMessageType.chat:
        return 'chat';
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

enum LexpeditionDataMessageType { gameData, chat, raw }
