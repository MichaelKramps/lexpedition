import 'package:firebase_database/firebase_database.dart';

class PartyDatabaseConnection {
  DatabaseReference? databaseReference;

  static PartyDatabaseConnection connection =
      PartyDatabaseConnection.nullConstructor();

  factory PartyDatabaseConnection() {
    return connection;
  }

  PartyDatabaseConnection.nullConstructor() {
    this.databaseReference = null;
  }

  PartyDatabaseConnection.fromPartyCode(String partyCode) {
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

  void createNewParty() async {
    if (connectionExists()) {
      await databaseReference?.set({
        "letterGridA": ['a010'],
        "letterGridB": null
      });
    }
  }
}
