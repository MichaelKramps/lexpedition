import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:game_template/src/game_data/letter_grid.dart';

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
        child: Image.asset('assets/images/spray.png', height: 80, width: 80));
  }

  void determineNewOffset() {
    setState(() {
      _offset = Offset(_offset.dx - 50, _offset.dy);
    });
  }
}