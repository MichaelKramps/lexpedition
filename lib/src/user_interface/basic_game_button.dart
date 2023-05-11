import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/user_interface/generic_button.dart';

class BasicGameButton extends StatelessWidget {
  final String buttonText;
  final double fontSize;
  final bool muted;
  final void Function() onPressed;

  BasicGameButton(
      {super.key,
      required this.buttonText,
      required this.onPressed,
      this.muted = false,
      this.fontSize = Constants.verySmallFont});

  @override
  Widget build(BuildContext context) {
    return GenericButton(
        primaryButtonColor: Colors.black,
        primaryButtonShadow: Color.fromARGB(255, 90, 90, 90),
        textColor: Colors.white,
        buttonText: buttonText,
        fontSize: fontSize,
        width: Constants().tileSize(),
        onPressed: onPressed);
  }
}
