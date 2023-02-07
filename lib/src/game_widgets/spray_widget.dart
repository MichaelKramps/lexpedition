import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';

class SprayWidget extends StatefulWidget {
  final SprayDirection sprayDirection;
  final bool beginSprayAnimation;

  const SprayWidget(
      {super.key,
      required this.sprayDirection,
      required this.beginSprayAnimation});

  @override
  State<SprayWidget> createState() => _SprayWidgetState();
}

class _SprayWidgetState extends State<SprayWidget> {
  Offset _offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: widget.beginSprayAnimation,
        maintainAnimation: false,
        child: Image.asset('assets/images/blast.png',
            height: Constants.tileSize, width: Constants.tileSize));
  }

  void determineNewOffset() {
    setState(() {
      _offset = Offset(_offset.dx - 50, _offset.dy);
    });
  }
}
