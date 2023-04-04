import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';

import '../game_data/constants.dart';

class LexpeditionScreen extends StatelessWidget {
  const LexpeditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () =>
                GoRouter.of(context).push('/lexpedition/oneplayer'), 
              child: Text('Single Player Lexpedition')),
              SizedBox(width: Constants.smallFont),
            ElevatedButton(
              onPressed: () =>
                GoRouter.of(context).push('/lexpedition/twoplayer'), 
              child: Text('Two Player Lexpedition')),
              SizedBox(width: Constants.smallFont),
            ElevatedButton(
              onPressed: () =>
                GoRouter.of(context).push('/lexpedition/backlog'), 
              child: Text('Hisoric Lexpeditions')),
              SizedBox(width: Constants.smallFont),
            ElevatedButton(
                  onPressed: () => GoRouter.of(context).pop(), child: Text('Back'))
          ],)
      )
    );
  }
}