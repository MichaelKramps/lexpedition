library lexpedition.partyGlobals;

import 'package:firebase_database/firebase_database.dart';
import 'package:lexpedition/src/game_data/letter_grid.dart';

String partyCode = '';
bool isPartyLeader = false;
int mode = 1; //represents # of active players/boards
DatabaseReference databaseReference =
    FirebaseDatabase.instance.ref('partyCode/');

// db data should look something like this {
//   partyCode: 'ABCD1234',
//   letterGridA: ['a010', null, 'e120', ...],
//   letterGridB: null
// }

void updatePartyCode ({required String partyCode, required bool isPartyLeader}) {
  partyCode = partyCode;
  isPartyLeader = isPartyLeader;
  databaseReference = FirebaseDatabase.instance.ref('partyCode/' + partyCode);
}

void updateMode (int playerMode) {
  mode = playerMode;
}

void createParty () async {
  if (partyCode.length > 0) {
    await databaseReference.set({'letterGridA': null, 'letterGridB': null});
  }
}

void updateGridA (LetterGrid letterGrid) async {
  await databaseReference.update({'letterGridA': letterGrid});
}

void updateGridB (LetterGrid letterGrid) async {
  await databaseReference.update({'letterGridB': letterGrid});
}
