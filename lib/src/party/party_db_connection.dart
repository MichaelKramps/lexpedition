import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';
import 'package:logging/logging.dart';

class PartyDatabaseConnection {
  bool isPartyLeader = false;
  DatabaseReference? databaseReference;

  static PartyDatabaseConnection connection =
      PartyDatabaseConnection.nullConstructor();

  factory PartyDatabaseConnection() {
    return connection;
  }

  PartyDatabaseConnection.nullConstructor() {
    this.isPartyLeader = false;
    this.databaseReference = null;
  }

  PartyDatabaseConnection.startParty({required String partyCode}) {
    this.isPartyLeader = true;
    this.databaseReference =
        FirebaseDatabase.instance.ref('partyCode/' + partyCode);
    connection = this;
  }

  PartyDatabaseConnection.joinParty({required String partyCode}) {
    this.isPartyLeader = false;
    this.databaseReference =
        FirebaseDatabase.instance.ref('partyCode/' + partyCode);
    connection = this;
  }

  void createPartyEntry() async {
    await databaseReference?.set({'joined': 1});
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
        await databaseReference?.set({"letterGridA": letterGrid.getReEncodedGrid()});
      } else {
        await databaseReference?.set({"letterGrid": letterGrid.getReEncodedGrid()});
      }
    }
  }

  void listenForPuzzle(Function(LetterGrid) callback) async {
    databaseReference
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
