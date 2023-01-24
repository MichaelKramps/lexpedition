import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ObstacleWidget extends StatelessWidget {
  final bool visible;

  const ObstacleWidget({super.key, required this.visible});

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: visible,
        child: Image.asset('assets/images/butterfly-icon.png',
            height: 80, width: 80));
  }
}
