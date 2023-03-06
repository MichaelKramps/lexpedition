import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:lexpedition/src/game_data/game_column.dart';
import 'package:lexpedition/src/game_data/levels.dart';
import 'package:lexpedition/src/game_widgets/game_instance_widget.dart';
import 'package:lexpedition/src/game_widgets/observer_game_instance_widget.dart';
import 'package:lexpedition/src/party/party_db_connection.dart';

class TwoPlayerPlaySessionScreen extends StatefulWidget {
  final GameLevel gameLevel;
  final Function(int) playerWon;

  const TwoPlayerPlaySessionScreen(
      {super.key, required this.gameLevel, required this.playerWon});

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
    if (widget.gameLevel.isBlankLevel()) {
      String waitingText = PartyDatabaseConnection().isPartyLeader
          ? 'Loading puzzle...'
          : 'Waiting for your partner to start a game...';
      return SizedBox.expand(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Text(waitingText)],
      ));
    } else if (widget.gameLevel.getMyLetterGrid() != null && _showingMyGrid) {
      return GameInstanceWidget(
          gameLevel: widget.gameLevel,
          playerWon: widget.playerWon,
          leftColumn: GameColumn.blankColumn,
          rightColumn: GameColumn.twoPlayerRightColumn,
          twoPlayerPlaySessionStateManager: TwoPlayerPlaySessionStateManager(
              twoPlayerState: this,
              theirLetterGrid: widget.gameLevel.getTheirLetterGrid()));
    } else {
      return ObserverGameInstanceWidget(
          twoPlayerPlaySessionStateManager: TwoPlayerPlaySessionStateManager(
              twoPlayerState: this,
              theirLetterGrid: widget.gameLevel.getTheirLetterGrid()),
          leftColumn: GameColumn.blankColumn,
          rightColumn: GameColumn.twoPlayerRightColumn);
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
