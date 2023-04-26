import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/user_interface/basic_user_interface_button.dart';

import '../game_data/constants.dart';

class LexpeditionScreen extends StatelessWidget {
  const LexpeditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage ("assets/images/Lex Mode Background.png"),
          fit: BoxFit.cover, 
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(100.0),
          child: SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BasicUserInterfaceButton(
                  onPressed: () {
                      GoRouter.of(context).push('/lexpedition/oneplayer');
                    },
                  buttonText: 'Single Player',
                ),
                BasicUserInterfaceButton(
                  onPressed: () {
                      GoRouter.of(context).push('/lexpedition/twoplayer');
                    },
                  buttonText: 'Two Player',
                ),
                BasicUserInterfaceButton(
                  onPressed: () {
                      GoRouter.of(context).push('/lexpedition/backlog');
                    },
                  buttonText: 'Classic',
                ),
                BasicUserInterfaceButton(
                  onPressed: () {
                      GoRouter.of(context).pop();
                    },
                  buttonText: 'Back',
                ),
              ],)
          ),
        ),
      ),
    );
  }
}