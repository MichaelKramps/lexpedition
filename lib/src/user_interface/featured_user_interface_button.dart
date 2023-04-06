import 'package:flutter/material.dart';
import 'package:lexpedition/src/user_interface/generic_button.dart';

class FeaturedUserInterfaceButton extends StatelessWidget {
  String buttonText;
  void Function() onPressed;

  FeaturedUserInterfaceButton({super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GenericButton(
      primaryButtonColor: Colors.orange, 
      primaryButtonShadow: Colors.deepOrange, 
      buttonText: buttonText, 
      onPressed: onPressed);
  }
}
