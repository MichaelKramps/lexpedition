import 'package:flutter/material.dart';
import 'package:lexpedition/src/user_interface/generic_button.dart';

class FeaturedUserInterfaceButton extends StatelessWidget {
  final String buttonText;
  final void Function() onPressed;

  FeaturedUserInterfaceButton({super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GenericButton(
      primaryButtonColor: Colors.green, 
      primaryButtonShadow: Color.fromARGB(255, 44, 101, 46), 
      buttonText: buttonText, 
      onPressed: onPressed);
  }
}
