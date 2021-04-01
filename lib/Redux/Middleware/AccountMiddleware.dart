import 'package:AiOrganization/Core/Firebase/AccountDB.dart';
import 'package:AiOrganization/Core/Firebase/AuthService.dart';
import 'package:AiOrganization/Models/Account.dart';
import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Redux/Actions/AccountActions.dart';
import 'package:AiOrganization/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';

class AccountMiddleware {
  AuthService _authService = new AuthService();

  /// [Create a new Account] :: TODO: Manage Errors
  Middleware<AppState> createAccount(AppState state) {
    return (Store<AppState> store, action, NextDispatcher next) async {
      next(action);

      await _authService
          .createAccount(action.email, action.password)
          .then((value) async {
        /// Initialize a new [object @Account] that contain the information of the created account on FirebaseAuth
        Account createdAccount = store.state.account.copyWith(
            uid: value.uid,
            displayName: action.displayName,
            email: value.email,
            photoUrl: value.photoURL ?? "",
            collectionsIDs: [],
            activitiesIDs: []);

        /// Update the FirebaseAuth user informations ---> Basically the [@displayName]
        _authService.updateAccountDefaultInfo(displayName: action.displayName);

        /// Create a new document into the firestore [@UsersDocument]
        await AccountDB().createUserDocument(createdAccount);

        /// Update the new information of the account into the [@AppState]
        store.dispatch(UpdateAccountState(createdAccount));
      });
    };
  }

  Middleware<AppState> signInWithGoogle(AppState state) {
    return (Store<AppState> store, action, NextDispatcher next) async {
      next(action);

      await _authService.signInWithGoogle().then((value) async {
        /// Initialize a new [object @Account] that contain the information of the created account on FirebaseAuth
        Account googleCreatedAccount = store.state.account.copyWith(
            uid: value.user.uid,
            displayName: value.user.displayName,
            email: value.user.email,
            photoUrl: value.user.photoURL ?? "",
            collectionsIDs: [],
            activitiesIDs: []);

        //// [Checker -- When signInWithGoogle check if the document on firestore exist or not by sending a query to the server]
        /// Get the account information from the store if the document exists
        DocumentSnapshot _documentSnapshot =
            await AccountDB().queryTheUserAccount(googleCreatedAccount);

        /// Here is the check for existance
        if (_documentSnapshot.exists) {
          /// Get the data from the documentSnapshot
          Map<String, dynamic> accountData = _documentSnapshot.data();

          /// Change AccountState
          googleCreatedAccount = googleCreatedAccount.copyWith(
              isPremium: accountData['isPremium'],
              activitiesCount: accountData['activitiesCount'],
              collectionCount: accountData['collectionCount']);
        } else {
          /// Create a new document into the firestore [@UsersDocument]
          await AccountDB().createUserDocument(googleCreatedAccount);
        }

        /// Update the new information of the account into the [@AppState]
        store.dispatch(UpdateAccountState(googleCreatedAccount));
      });
    };
  }

  Middleware<AppState> signInWithEmail(AppState state) {
    return (Store<AppState> store, action, NextDispatcher next) async {
      next(action);

      await _authService
          .signIn(action.email, action.password)
          .then((value) async {
        if (value != null) {
          /// Initialize a new [object @Account] that contain the information of the signedIn account on FirebaseAuth
          Account signedInAccount = store.state.account.copyWith(
              uid: value.uid,
              displayName: value.displayName,
              email: value.email,
              photoUrl: value.photoURL ?? "",
              collectionsIDs: [],
              activitiesIDs: []);

          /// Get the account information from the store if the document exists
          DocumentSnapshot _documentSnapshot =
              await AccountDB().queryTheUserAccount(signedInAccount);

          if (_documentSnapshot.exists) {
            /// Get the data from the documentSnapshot
            Map<String, dynamic> accountData = _documentSnapshot.data();

            /// Change AccountState
            signedInAccount = signedInAccount.copyWith(
                isPremium: accountData['isPremium'],
                activitiesCount: accountData['activitiesCount'],
                collectionCount: accountData['collectionCount']);
          }

          /// Update the new information of the account into the [@AppState]
          store.dispatch(UpdateAccountState(signedInAccount));
        }
      });
    };
  }

  /// [SignIn into an existing account] :: TODO: Manage Errors
  Middleware<AppState> signOutAccount(AppState state) {
    return (Store<AppState> store, action, NextDispatcher next) async {
      next(action);
      analytics.logEvent(
          name: 'LogOut', parameters: {"userId": store.state.account.uid});

      // Log out
      _authService.signOut();

      // Reset the account info
      store.dispatch(UpdateAccountState(Account()));

      // Analytics
      analytics.setUserId(null);
      analytics.setUserProperty(name: 'user_type', value: 'AccountType.NONE');
    };
  }
}
