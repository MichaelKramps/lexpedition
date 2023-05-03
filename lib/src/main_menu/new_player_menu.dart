import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/constants.dart';

class NewPlayerMenu extends StatefulWidget {
  const NewPlayerMenu({super.key});

  @override
  State<NewPlayerMenu> createState() => _NewPlayerMenuState();
}

class _NewPlayerMenuState extends State<NewPlayerMenu> {
  bool _showTutorialBox = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showTutorialBox = true;
                  });
                },
                child: const Text('Tutorial'),
              ),
              SizedBox(width: Constants.smallFont),
              ElevatedButton(
                onPressed: () => GoRouter.of(context).push('/settings'),
                child: const Text('Settings'),
              )
            ],
          ),
        ),
        Visibility(
          visible: _showTutorialBox,
          child: AlertDialog(
              content: Text('Which Tutorial path will you take?'),
              actions: [
                ElevatedButton(
                  child: const Text('Full Tutorial'),
                  onPressed: () {},
                ),
                ElevatedButton(
                  child: const Text('Quick Tutorial'),
                  onPressed: () {},
                ),
                ElevatedButton(
                  child: const Text('Skip Tutorial'),
                  onPressed: () {},
                ),
                ElevatedButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    setState(() {
                      _showTutorialBox = false;
                    });
                  },
                ),
              ]),
        )
      ],
    );
  }
}
