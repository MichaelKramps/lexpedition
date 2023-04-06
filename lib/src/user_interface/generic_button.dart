import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:lexpedition/src/game_data/constants.dart';

class GenericButton extends StatefulWidget {

  Color primaryButtonColor;
  Color primaryButtonShadow;
  String buttonText;
  void Function() onPressed;

  GenericButton({
    super.key,
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
      width: Constants.buttonWidth,
      child: GestureDetector(
        onTap: () => pressButton(),
        child: Container(
          child: Stack(
            children:[
              Positioned(
                bottom: 0,
                child: Container(
                  height: Constants.bigFont,
                  width: Constants.buttonWidth,
                  decoration: BoxDecoration(
                    borderRadius: Constants.buttonBorderRadius,
                    color: widget.primaryButtonShadow
                  ),
              )),
              AnimatedPositioned(
                duration: Constants.buttonPressAnimationDuration,
                curve: Curves.decelerate,
                bottom: buttonPosition(),
                child: Container(
                  height: Constants.bigFont,
                  width: Constants.buttonWidth,
                  decoration: BoxDecoration(
                    borderRadius: Constants.buttonBorderRadius,
                    color: widget.primaryButtonColor
                  ),
                child: Center(
                  child: Text(
                    widget.buttonText, 
                    style: TextStyle(fontSize: Constants.smallFont, color: Colors.white)
                  )
                ),
              ))
            ]
          )
        )
      ),
    );
  }

  void pressButton() {
    setState(() {
      _pressed = !_pressed;
    });
    widget.onPressed;
  }

  double buttonPosition(){
    if (_pressed){
      return 0;
    } else {
      return 4;
    }
  }
}