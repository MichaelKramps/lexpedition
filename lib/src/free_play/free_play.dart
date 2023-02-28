import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FreePlay extends StatelessWidget {
  const FreePlay({super.key});

  @override
  Widget build(BuildContext context) {
    //Level level =
    //    freePlayLevels.elementAt(Random().nextInt(freePlayLevels.length));
    //return new PlaySessionScreen(level, '/freeplaywon');
    return Scaffold(
      body: SizedBox.expand(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).push('/freeplay/oneplayer');
              },
              child: Text('One Player')
            ),
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).push('/freeplay/twoplayer');
              },
              child: Text('Two Player')
            )
          ],
        )
      )
    );
  }
}
