import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/constants.dart';

class PartyScreen extends StatelessWidget {
  const PartyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () =>
                  GoRouter.of(context).push('/party/join'),
              child: Text('Join Party')),
          SizedBox(width: Constants.smallFont),
          ElevatedButton(
              onPressed: () =>
                  GoRouter.of(context).push('/party/start'),
              child: Text('Start Party'))
        ]);
  }
}