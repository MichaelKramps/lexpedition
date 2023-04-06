import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:lexpedition/src/user_interface/generic_button.dart';

class BasicUserInterfaceButton extends StatelessWidget {

  String buttonText;
  void Function() onPressed;

  BasicUserInterfaceButton({super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GenericButton(
      primaryButtonColor: Colors.blue,
      primaryButtonShadow: Color.fromARGB(255, 13, 60, 143),
      buttonText: buttonText, 
      onPressed: onPressed);
  }
}