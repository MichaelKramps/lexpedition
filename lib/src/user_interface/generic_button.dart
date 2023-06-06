import 'package:flutter/material.dart';
import 'package:lexpedition/src/audio/audio_controller.dart';
import 'package:lexpedition/src/audio/sounds.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:provider/provider.dart';

class GenericButton extends StatefulWidget {
  final Color primaryButtonColor;
  final Color primaryButtonShadow;
  final Color textColor;
  final String buttonText;
  final double fontSize;
  final double? width;
  final bool muted;
  final void Function() onPressed;

  GenericButton(
      {super.key,
      required this.primaryButtonColor,
      required this.primaryButtonShadow,
      required this.buttonText,
      required this.onPressed,
      this.textColor = Colors.white,
      this.fontSize = Constants.smallFont,
      this.muted = false,
      this.width});

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
                              fontSize: widget.fontSize,
                              color: widget.textColor))),
                ))
          ]))),
    );
  }

  double calculateButtonWidth() {
    if (widget.width != null) {
      return widget.width!;
    }
    if (widget.fontSize == Constants.verySmallFont) {
      return calculateVerySmallFontButtonWidth();
    }
    return calculateSmallFontButtonWidth();
  }

  double calculateSmallFontButtonWidth() {
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

  double calculateVerySmallFontButtonWidth() {
    if (widget.buttonText.length < 10) {
      return widget.buttonText.length * 14;
    } else if (widget.buttonText.length < 16) {
      return widget.buttonText.length * 13;
    } else if (widget.buttonText.length < 20) {
      return widget.buttonText.length * 12;
    } else {
      return widget.buttonText.length * 11;
    }
  }

  void pressButton() async {
    setState(() {
      _pressed = true;
    });
    if (!widget.muted) {
      final audioController = context.read<AudioController>();
      await audioController.playSfx(SfxType.tapButton);
    }
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
