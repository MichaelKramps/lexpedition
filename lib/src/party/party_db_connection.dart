import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';

class PartyDatabaseConnection {
  bool isPartyLeader = false;
  String partyCode = '';
  DatabaseReference? databaseReference;
  StreamSubscription? listener;

  static PartyDatabaseConnection connection =
      PartyDatabaseConnection.nullConstructor();

  factory PartyDatabaseConnection() {
    return connection;
  }

  PartyDatabaseConnection.nullConstructor() {
    this.isPartyLeader = false;
    this.partyCode = '';
    this.databaseReference = null;
  }

  PartyDatabaseConnection.startParty({required String partyCode}) {
    this.isPartyLeader = true;
    this.partyCode = partyCode;
    this.databaseReference =
        FirebaseDatabase.instance.ref('party/' + partyCode);
    connection = this;
  }

  PartyDatabaseConnection.joinParty({required String partyCode}) {
    this.isPartyLeader = false;
    this.partyCode = partyCode;
    DatabaseReference reference =
        FirebaseDatabase.instance.ref('party/' + partyCode);
    this.databaseReference = reference;
    this.addOneToParty(reference);
    connection = this;
  }

  bool isNull() {
    if (this.databaseReference == null) {
      return true;
    }
    return false;
  }

  static Future<bool> canJoinParty(String partyCode) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref('party/' + partyCode);

    int numberJoined = await PartyDatabaseConnection.getNumberJoined(reference);

    if (numberJoined >= 0 && numberJoined < 2) {
      return true;
    } else {
      return false;
    }
  }

  static Future<int> getNumberJoined(DatabaseReference reference) async {
    DataSnapshot snapshot = await reference.child('joined').get();
    try {
      int numberJoined = snapshot.value as int;
      return numberJoined;
    } catch (e) {
      return -1;
    }
  }

  void addOneToParty(DatabaseReference? reference) async {
    if (reference != null) {
      reference.update({
        'joined': await PartyDatabaseConnection.getNumberJoined(reference) + 1
      });
    }
  }

  void takeOneFromParty(DatabaseReference? reference) async {
    if (reference != null) {
      reference.update({
        'joined': await PartyDatabaseConnection.getNumberJoined(reference) - 1
      });
    }
  }

  void leaveParty() async {
    if (this.isPartyLeader) {
      this.databaseReference?.remove();
    } else {
      this.takeOneFromParty(this.databaseReference);
      listener?.cancel();
    }
    connection = PartyDatabaseConnection.nullConstructor();
    this.isPartyLeader = false;
    this.partyCode = '';
    this.databaseReference = null;
  }

  void createPartyEntry() async {
    await databaseReference?.set({'joined': 1, 'updated': getFormattedDate()});
  }

  String getFormattedDate() {
    DateTime dateTime = DateTime.now();
    String formattedDate = dateTime.year.toString() +
        '/' +
        dateTime.month.toString() +
        '/' +
        dateTime.day.toString();
    return formattedDate;
  }

  bool connectionExists() {
    if (databaseReference != null) {
      return true;
    }
    return false;
  }

  void loadPuzzleForPlayerTwo(List<String?> gridCodeList) async {
    if (connectionExists()) {
      if (isPartyLeader) {
        await databaseReference?.update({
          'letterGridA': {'letterGridB': gridCodeList.join(',')}
        });
      }
    }
  }

  void updateMyPuzzle(LetterGrid letterGrid) async {
    if (connectionExists()) {
      if (isPartyLeader) {
        await databaseReference?.update({
          'letterGridA': {
            'gridString': letterGrid.getGridStringForDatabase(),
            'guesses': letterGrid.guesses.join(',')
          },
          'updated': getFormattedDate()
        });
      } else {
        await databaseReference?.update({
          'letterGridB': {
            'gridString': letterGrid.getGridStringForDatabase(),
            'guesses': letterGrid.guesses.join(',')
          },
          'updated': getFormattedDate()
        });
      }
    }
  }

  void listenForPuzzle(
      Function({LetterGrid? myLetterGrid, required LetterGrid theirLetterGrid})
          callback) async {
    String gridToListenFor = isPartyLeader ? 'letterGridB' : 'letterGridA';

    this.listener = databaseReference
        ?.child(gridToListenFor)
        .onValue
        .listen((DatabaseEvent event) {
      try {
        final String theirGridString =
            event.snapshot.child('gridString').value as String;
        final String guesses = event.snapshot.child('guesses').value as String;
        final String? myGridString =
            event.snapshot.child('letterGridB').value as String?;
        
        final LetterGrid theirLetterGrid = LetterGrid.fromLiveDatabase(
                theirGridString.split(','), guesses.split(','));
        final LetterGrid? myLetterGrid =
            myGridString == null ? null : LetterGrid.fromLiveDatabase(myGridString.split(','), []);

        callback(
            theirLetterGrid: theirLetterGrid,
            myLetterGrid: myLetterGrid);
      } catch (e) {
        // not sure how to handle yet
      }
    });
  }
}
