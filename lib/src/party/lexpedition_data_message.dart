import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:lexpedition/src/game_data/button_push.dart';
import 'package:lexpedition/src/game_data/constants.dart';

class LexpeditionDataMessage {
  LexpeditionDataMessageType type = LexpeditionDataMessageType.raw;
  ButtonPush buttonPush = ButtonPush.clearGuess;
  int? tileIndexSelected;
  String text = '';

  LexpeditionDataMessage(RTCDataChannelMessage rtcDataMessage) {
    //rtcDataMessage should have the format -> 'type:;:data'
    List<String> splitText =
        rtcDataMessage.text.split(Constants.rtcMessageSplitter);
    this.type = determineDataType(splitText[0]);
    setMessageContent(splitText[1]);
  }

  LexpeditionDataMessage.fromLoadLevelData(String gameDataString) {
    this.type = LexpeditionDataMessageType.loadLevel;
    this.text = gameDataString;
  }

  LexpeditionDataMessage.fromButtonPush(
      {required ButtonPush buttonPushed, int? tileIndex}) {
    this.type = LexpeditionDataMessageType.buttonPush;
    this.text = buttonPushed.index.toString() +
        Constants.rtcButtonPushSplitter +
        tileIndex.toString();
  }

  LexpeditionDataMessageType determineDataType(String typeString) {
    switch (typeString) {
      case 'loadLevel':
        return LexpeditionDataMessageType.loadLevel;
      case 'buttonPush':
        return LexpeditionDataMessageType.buttonPush;
      default:
        return LexpeditionDataMessageType.raw;
    }
  }

  String dataTypeToString() {
    switch (this.type) {
      case LexpeditionDataMessageType.loadLevel:
        return 'loadLevel';
      case LexpeditionDataMessageType.buttonPush:
        return 'buttonPush';
      default:
        return 'raw';
    }
  }

  void setMessageContent(String messageContentText) {
    this.text = messageContentText;
    if (this.type == LexpeditionDataMessageType.buttonPush) {
      List<String> buttonTextSplit =
          messageContentText.split(Constants.rtcButtonPushSplitter);
      this.buttonPush = ButtonPush.values[int.parse(buttonTextSplit[0])];
      if (buttonTextSplit[1] != 'null') {
        this.tileIndexSelected = int.parse(buttonTextSplit[1]);
      }
    }
  }

  String createMessageText() {
    return dataTypeToString() + Constants.rtcMessageSplitter + this.text;
  }
}

enum LexpeditionDataMessageType { loadLevel, buttonPush, raw }
