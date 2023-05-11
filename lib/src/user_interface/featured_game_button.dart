import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/user_interface/generic_button.dart';

class FeaturedGameButton extends StatelessWidget {
  final String buttonText;
  final double fontSize;
  final bool muted;
  final void Function() onPressed;

  FeaturedGameButton(
      {super.key,
      required this.buttonText,
      required this.onPressed,
      this.fontSize = Constants.verySmallFont,
      this.muted = false});

  @override
  Widget build(BuildContext context) {
    return GenericButton(
        primaryButtonColor: Colors.green,
        primaryButtonShadow: Color.fromARGB(255, 44, 101, 46),
        textColor: Colors.white,
        buttonText: buttonText,
        fontSize: fontSize,
        width: Constants().tileSize(),
        onPressed: onPressed);
  }
}
