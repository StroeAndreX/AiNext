import 'package:AiOrganization/Core/Firebase/AuthService.dart';
import 'package:AiOrganization/Models/Account.dart';
import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Redux/Actions/AccountActions.dart';
import 'package:AiOrganization/main.dart';
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
          .then((value) {
        Account createdAccount = store.state.account.copyWith(
          uid: value.uid,
          displayName: action.displayName,
          email: value.email,
          photoUrl: value.photoURL ?? "",
        );

        _authService.updateAccountDefaultInfo(displayName: action.displayName);

        store.dispatch(UpdateAccountState(createdAccount));
      });
    };
  }

  Middleware<AppState> signInWithGoogle(AppState state) {
    return (Store<AppState> store, action, NextDispatcher next) async {
      next(action);

      await _authService.signInWithGoogle().then((value) {
        Account signedInAccount = store.state.account.copyWith(
          uid: value.user.uid,
          displayName: value.user.displayName,
          email: value.user.email,
          photoUrl: value.user.photoURL ?? "",
        );

        store.dispatch(UpdateAccountState(signedInAccount));
      });
    };
  }

  Middleware<AppState> signInWithEmail(AppState state) {
    return (Store<AppState> store, action, NextDispatcher next) async {
      next(action);

      await _authService.signIn(action.email, action.password).then((value) {
        if (value != null) {
          Account signedInAccount = store.state.account.copyWith(
            uid: value.uid,
            displayName: value.displayName,
            email: value.email,
            photoUrl: value.photoURL ?? "",
          );

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
