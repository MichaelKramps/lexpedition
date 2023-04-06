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
      body: Padding(
        padding: const EdgeInsets.all(100.0),
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () =>
                  GoRouter.of(context).push('/lexpedition/oneplayer') , 
                child: Text('Single Player Lexpedition'),
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0)
                )),
                SizedBox(width: Constants.smallFont),
              ElevatedButton(
                onPressed: () =>
                  GoRouter.of(context).push('/lexpedition/twoplayer'), 
                child: Text('Two Player Lexpedition'),
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0)
                )),
                SizedBox(width: Constants.smallFont),
              ElevatedButton(
                onPressed: () =>
                  GoRouter.of(context).push('/lexpedition/backlog'), 
                child: Text('Older Lexpeditions'),
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0)
                )),
                SizedBox(width: Constants.smallFont),
              ElevatedButton(
                  onPressed: () => 
                    GoRouter.of(context).pop(), 
                  child: Text('Back'),
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0)
                ))
            ],)
        ),
      )
    );
  }
}