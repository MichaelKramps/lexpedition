import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/game_data/game_column.dart';
import 'package:lexpedition/src/game_widgets/game_instance_widget.dart';
import 'package:lexpedition/src/game_widgets/observer_game_instance_widget.dart';

class TwoPlayerPlaySessionScreen extends StatefulWidget {
  final LetterGrid? myLetterGrid;
  final LetterGrid? theirLetterGrid;
  final Function(int, int) playerWon;

  const TwoPlayerPlaySessionScreen(
      {super.key, required this.myLetterGrid, required this.theirLetterGrid, required this.playerWon});

  @override
  State<TwoPlayerPlaySessionScreen> createState() =>
      _TwoPlayerPlaySessionScreenState();
}

class _TwoPlayerPlaySessionScreenState
    extends State<TwoPlayerPlaySessionScreen> {
  bool _showingMyGrid = true;
  bool _duringCelebration = false;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(ignoring: _duringCelebration, child: determineStack());
  }

  Widget determineStack() {
    if (!_duringCelebration) {
      return determineVisibleGrid();
    } else {
      return determineVisibleGrid();
    }
  }

  Widget determineVisibleGrid() {
    if (widget.myLetterGrid != null && _showingMyGrid) {
      return GameInstanceWidget(
          letterGrid: widget.myLetterGrid as LetterGrid,
          playerWon: widget.playerWon,
          leftColumn: GameColumn.blankColumn,
          rightColumn: GameColumn.twoPlayerRightColumn,
          twoPlayerPlaySessionStateManager: TwoPlayerPlaySessionStateManager(
              twoPlayerState: this, theirLetterGrid: widget.theirLetterGrid));
    } else if (widget.theirLetterGrid != null) {
      return ObserverGameInstanceWidget(
          twoPlayerPlaySessionStateManager: TwoPlayerPlaySessionStateManager(
              twoPlayerState: this, theirLetterGrid: widget.theirLetterGrid),
          leftColumn: GameColumn.blankColumn,
          rightColumn: GameColumn.twoPlayerRightColumn);
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Text('Waiting for your partner to start a game...')],
      );
    }
  }

  void toggleScreen() {
    setState(() {
      _showingMyGrid = _showingMyGrid ? false : true;
    });
  }
}

class TwoPlayerPlaySessionStateManager {
  _TwoPlayerPlaySessionScreenState twoPlayerState;
  LetterGrid? theirLetterGrid;

  TwoPlayerPlaySessionStateManager(
      {required this.twoPlayerState, this.theirLetterGrid});

  void toggleScreen() {
    twoPlayerState.toggleScreen();
  }

  LetterGrid? getTheirLetterGrid() {
    return theirLetterGrid;
  }
}
