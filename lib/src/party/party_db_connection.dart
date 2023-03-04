import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:lexpedition/src/game_data/blast_direction.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';

class PartyDatabaseConnection {
  bool isPartyLeader = true;
  String partyCode = '';
  DatabaseReference? databaseReference;
  StreamSubscription? listener;

  static PartyDatabaseConnection connection =
      PartyDatabaseConnection.nullConstructor();

  factory PartyDatabaseConnection() {
    return connection;
  }

  PartyDatabaseConnection.nullConstructor() {
    this.isPartyLeader = true;
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

  void loadPuzzleForPlayers(
      {required List<String?> gridCodeListA,
      List<String?>? gridCodeListB}) async {
    if (connectionExists()) {
      if (isPartyLeader) {
        await databaseReference?.update({
          'letterGridA': {
            'gridString': gridCodeListA.join(','),
            'guesses': '',
            'letterGridB': gridCodeListB?.join(',')
          },
          'letterGridB': {'gridString': gridCodeListB?.join(','), 'guesses': ''}
        });
      }
    }
  }

  void updateMyPuzzle({required LetterGrid letterGrid, int? blastIndex}) async {
    if (connectionExists()) {
      if (isPartyLeader) {
        await databaseReference?.update({
          'letterGridA': {
            'gridString': letterGrid.getGridStringForDatabase(),
            'guesses': letterGrid.guesses.join(','),
            'blastIndex': blastIndex,
            'blastDirection': letterGrid.blastDirection.index
          },
          'updated': getFormattedDate()
        });
      } else {
        await databaseReference?.update({
          'letterGridB': {
            'gridString': letterGrid.getGridStringForDatabase(),
            'guesses': letterGrid.guesses.join(','),
            'blastIndex': blastIndex,
            'blastDirection': letterGrid.blastDirection.index
          },
          'updated': getFormattedDate()
        });
      }
    }
  }

  void listenForPuzzle(
      Function(
              {LetterGrid? myLetterGrid,
              required LetterGrid theirLetterGrid,
              int? blastIndex})
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

        String? myGridString = null;
        try {
          myGridString =
            event.snapshot.child('letterGridB').value as String?;
        } catch (e) {}
        
        int? blastIndex = null;
        try {
          blastIndex = event.snapshot.child('blastIndex') as int?;
        } catch (e) {}

        int? blastDirectionIndex = null;
        try {
          blastDirectionIndex = event.snapshot.child('blastDirection') as int?;
        } catch (e) {}

        final BlastDirection? blastDirection =
            determineBlastDirection(blastDirectionIndex);

        final LetterGrid theirLetterGrid = LetterGrid.fromLiveDatabase(
            letterTiles: theirGridString.split(','),
            guesses: guesses.split(','),
            blastDirection: blastDirection);
        final LetterGrid? myLetterGrid = myGridString == null
            ? null
            : LetterGrid.fromLiveDatabase(
                letterTiles: myGridString.split(','), guesses: []);

        callback(
            theirLetterGrid: theirLetterGrid,
            myLetterGrid: myLetterGrid,
            blastIndex: blastIndex);
      } catch (e) {}
    });
  }
}
