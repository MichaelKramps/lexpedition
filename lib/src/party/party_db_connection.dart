import 'package:firebase_database/firebase_database.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';

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

  PartyDatabaseConnection.fromPartyCode(
      {required String partyCode, required bool isPartyLeader}) {
    this.isPartyLeader = isPartyLeader;
    this.databaseReference =
        FirebaseDatabase.instance.ref('partyCode/' + partyCode);
    connection = this;
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
          ?.set({"letterGridA": letterGrid.encodedTiles});
      } else {
        await databaseReference
          ?.set({"letterGrid": letterGrid.encodedTiles});
      }
    }
  }
}
