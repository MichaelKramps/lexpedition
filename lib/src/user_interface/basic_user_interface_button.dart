import 'package:flutter/material.dart';
import 'package:lexpedition/src/user_interface/generic_button.dart';

class BasicUserInterfaceButton extends StatelessWidget {

  final String buttonText;
  final void Function() onPressed;

  BasicUserInterfaceButton({super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GenericButton(
      primaryButtonColor: Colors.black,
      primaryButtonShadow: Color.fromARGB(255, 90, 90, 90),
      textColor: Colors.white,
      buttonText: buttonText, 
      onPressed: onPressed);
  }
}