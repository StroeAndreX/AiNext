import 'package:AiOrganization/Models/Account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountDB {
  CollectionReference _userReference =
      FirebaseFirestore.instance.collection('Users');

  /// [Create the userDocument of the new registered Account/User]
  Future<void> createUserDocument(Account account) async {
    /// Create UserDocument and set the init Data
    await _userReference.doc(account.uid).set(account.toMapFirestore());

    /// Create a subDocument containing all the IDs for searching into Activites and Collections Document
    DocumentReference _userItemsReference = FirebaseFirestore.instance
        .collection('Users')
        .doc(account.uid)
        .collection('UserItems')
        .doc("-" + account.uid);

    // Init the List of IDs even tho is going to be empty
    _userItemsReference.set(account.toMapFirestoreSubDocument());
  }

  /// [Update the data of the Account/User]
  Future<void> updateUserDocument(Account account) async {
    /// Update the data of the document based on the userUID
    await _userReference.doc(account.uid).update(account.toMapFirestore());
  }

  /// [Update the data of the Account/User Items]
  Future<void> updateUserItemsDocument(Account account) async {
    /// Get the path of the subDocument
    DocumentReference _userItemsReference = FirebaseFirestore.instance
        .collection('Users')
        .doc(account.uid)
        .collection('UserItems')
        .doc("-" + account.uid);

    /// Update the data of the document based on the userUID
    await _userReference
        .doc(account.uid)
        .update(account.toMapFirestoreSubDocument());
  }

  Future<DocumentSnapshot> queryTheUserAccount(Account account) async {
    /// Get the information into the firestore document by giving the currentUID
    DocumentSnapshot documentReference =
        await _userReference.doc(account.uid).get();

    return documentReference;
  }
}
