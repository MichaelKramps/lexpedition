import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/constants.dart';

class GenericButton extends StatefulWidget {
  final Color primaryButtonColor;
  final Color primaryButtonShadow;
  final Color textColor;
  final String buttonText;
  final void Function() onPressed;

  GenericButton(
      {super.key,
      required this.primaryButtonColor,
      required this.primaryButtonShadow,
      required this.buttonText,
      required this.onPressed,
      this.textColor = Colors.white});

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
                              fontFamily: Constants.buttonUIFont,
                              fontSize: Constants.smallFont,
                              color: widget.textColor))),
                ))
          ]))),
    );
  }

  double calculateButtonWidth() {
    if (widget.buttonText.length < 10) {
      return widget.buttonText.length * 18;
    } else if (widget.buttonText.length < 16) {
      return widget.buttonText.length * 17;
    } else if (widget.buttonText.length < 20) {
      return widget.buttonText.length * 16;
    } else {
      return widget.buttonText.length * 15;
    }
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
