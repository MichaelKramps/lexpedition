import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexpedition/src/game_data/constants.dart';
import 'package:lexpedition/src/user_interface/basic_user_interface_button.dart';

class MoreMenu extends StatefulWidget {
  const MoreMenu({super.key});

  @override
  State<MoreMenu> createState() => _MoreMenuState();
}

class _MoreMenuState extends State<MoreMenu> {
  bool _showTutorialBox = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
        children: [
          SizedBox.expand(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).push('/buildpuzzle');
                  },
                  child: const Text('Puzzle Builder'),
                ),
                SizedBox(width: Constants.smallFont),
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
                ),
                SizedBox(width: Constants.smallFont),
                ElevatedButton(
                    onPressed: () => GoRouter.of(context).pop(), child: Text('Back'))
              ],
            ),
          ),
          Visibility(
            visible: _showTutorialBox,
            child: AlertDialog(
                content: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                  Text(
                    'Which tutorial will you play?',
                    style: TextStyle(fontSize: Constants.mediumFont),
                  ),
                  SizedBox(height: 24),
                  Row(children: [
                    BasicUserInterfaceButton(
                      buttonText: 'Full Tutorial',
                      onPressed: () {
                        GoRouter.of(context).push('/tutorial/full');
                      },
                    ),
                    SizedBox(width: 16),
                    BasicUserInterfaceButton(
                      buttonText: 'Quick Tutorial',
                      onPressed: () {
                        GoRouter.of(context).push('/tutorial/quick');
                      },
                    )
                  ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BasicUserInterfaceButton(
                        buttonText: 'Cancel',
                        onPressed: () {
                          setState(() {
                            _showTutorialBox = false;
                          });
                        },
                      ),
                    ]
                  )
              ]
          )),
        )
        ],
        
      ),
    );
  }
}
