import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:lexpedition/src/user_interface/generic_button.dart';

class BasicUserInterfaceButton extends StatelessWidget {

  String buttonText;
  void Function() onPressFunction;

  BasicUserInterfaceButton({super.key, required this.buttonText, required this.onPressFunction});

  @override
  Widget build(BuildContext context) {
    return GenericButton(
      primaryButtonColor: Colors.blue,
      primaryButtonShadow: Color.fromARGB(255, 13, 60, 143),
      buttonText: buttonText, 
      onPressFunction: onPressFunction);
  }

  ButtonStyle unpressedStyle() {
    return ButtonStyle(
      elevation: MaterialStatePropertyAll(1)
    );
  }

  ButtonStyle pressedStyle() {
    return ButtonStyle(
      elevation: MaterialStatePropertyAll(0)
    );
  }
}