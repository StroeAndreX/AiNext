import 'package:AiOrganization/Models/Account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountDB {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference _userReference =
      FirebaseFirestore.instance.collection('Users');

  Future<void> createUserDocument(Account account) async {
    await _userReference.doc(account.uid).set(account.toMap());

    DocumentReference _userItemsReference = await FirebaseFirestore.instance
        .collection('Users')
        .doc(account.uid)
        .collection('UserItems')
        .doc("-" + account.uid);
  }
}
