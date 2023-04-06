import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:logging/logging.dart';

class GenericButton extends StatefulWidget {
  final Color primaryButtonColor;
  final Color primaryButtonShadow;
  final String buttonText;
  final void Function() onPressed;

  GenericButton(
      {super.key,
      required this.primaryButtonColor,
      required this.primaryButtonShadow,
      required this.buttonText,
      required this.onPressed});

  @override
  State<GenericButton> createState() => _GenericButtonState();
}

class _GenericButtonState extends State<GenericButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Constants.bigFont + Constants.buttonBorderRadiusAmount,
      width: calculateButtonWidth(),
      child: GestureDetector(
          onTap: () => pressButton(),
          child: Container(
              child: Stack(children: [
            Positioned(
                bottom: 0,
                child: Container(
                  height: Constants.bigFont,
                  width: calculateButtonWidth(),
                  decoration: BoxDecoration(
                      borderRadius: Constants.buttonBorderRadius,
                      color: widget.primaryButtonShadow),
                )),
            AnimatedPositioned(
                duration: Constants.buttonPressAnimationDuration,
                curve: Curves.decelerate,
                bottom: buttonPosition(),
                child: Container(
                  height: Constants.bigFont,
                  width: calculateButtonWidth(),
                  decoration: BoxDecoration(
                      borderRadius: Constants.buttonBorderRadius,
                      color: widget.primaryButtonColor),
                  child: Center(
                      child: Text(widget.buttonText.toUpperCase(),
                          style: TextStyle(
                              fontSize: Constants.smallFont,
                              color: Colors.white))),
                ))
          ]))),
    );
  }

  double calculateButtonWidth() {
    return widget.buttonText.length * 20;
  }

  void pressButton() async {
    setState(() {
      _pressed = true;
    });
    await Future.delayed(Constants.buttonPressAnimationDuration);
    widget.onPressed();
    setState(() {
      _pressed = false;
    });
  }

  double buttonPosition() {
    if (_pressed) {
      return 0;
    } else {
      return Constants.buttonDepth;
    }
  }
}
