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
        FirebaseDatabase.instance.ref('partyCode/' + partyCode);
    connection = this;
  }

  PartyDatabaseConnection.joinParty({required String partyCode}) {
    this.isPartyLeader = false;
    this.partyCode = partyCode;
    DatabaseReference reference =
        FirebaseDatabase.instance.ref('partyCode/' + partyCode);
    this.databaseReference = reference;
    this.addOneToParty(reference);
    connection = this;
  }

  static Future<bool> canJoinParty(String code) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref('partyCode/' + code);

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

  void updateMyPuzzle(LetterGrid letterGrid) async {
    if (connectionExists()) {
      if (isPartyLeader) {
        await databaseReference
            ?.update({"letterGridA": letterGrid.getReEncodedGrid(), 'updated': getFormattedDate()});
      } else {
        await databaseReference
            ?.update({"letterGrid": letterGrid.getReEncodedGrid(), 'updated': getFormattedDate()});
      }
    }
  }

  void listenForPuzzle(Function(LetterGrid) callback) async {
    this.listener = databaseReference
        ?.child('letterGridA')
        .onValue
        .listen((DatabaseEvent event) {
      final data = event.snapshot.children;
      callback(LetterGrid(createEncodedGrid(data), 6));
    });
  }

  List<String?> createEncodedGrid(Iterable<DataSnapshot> data) {
    List<String?> encodedGrid = [
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
    ];

    for (DataSnapshot snapshot in data) {
      int index = int.parse(snapshot.key ?? "-1");
      String value = snapshot.value as String;

      if (index >= 0) {
        encodedGrid[index] = value;
      }
    }

    return encodedGrid;
  }
}
