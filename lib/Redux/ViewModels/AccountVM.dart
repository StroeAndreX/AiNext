import 'package:AiOrganization/Models/Account.dart';
import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Redux/Actions/AccountActions.dart';

import 'package:redux/redux.dart';

class AccountVM {
  final Account account;
  final Future Function(String, String, String) createNewAccount;
  final Future Function(String, String) signInWithEmail;
  final Future Function() signInWithGoogle;
  final Function({String displayName, String photoURL})
      updateAccountDefaultInfo;
  final Function(Account) updateAccountState;
  final Function signOut;

  AccountVM({
    this.signOut,
    this.account,
    this.updateAccountDefaultInfo,
    this.createNewAccount,
    this.signInWithEmail,
    this.signInWithGoogle,
    this.updateAccountState,
  });

  factory AccountVM.create(Store<AppState> store) {
    _createNewAccount(String email, String password, String name) async {
      await store.dispatch(CreateAccountAction(email, password, name));
    }

    _signInWithEmail(String email, String password) async {
      await store.dispatch(SignInWithEmailAction(email, password));
    }

    _signInWithGoogle() async {
      await store.dispatch(SignInWithGoogleAction());
    }

    _updateAccountDefaultInfo({String displayName, String photoURL}) async {
      await store.dispatch(UpdateDefaultAccountInfo(
          displayName: displayName, photoURL: photoURL));
    }

    _updateAccountState(Account account) {
      store.dispatch(UpdateAccountState(account));
    }

    _signOut() async {
      await store.dispatch(SignOutAction());
    }

    return AccountVM(
        account: store.state.account,
        createNewAccount: _createNewAccount,
        updateAccountDefaultInfo: _updateAccountDefaultInfo,
        signInWithGoogle: _signInWithGoogle,
        signInWithEmail: _signInWithEmail,
        signOut: _signOut,
        updateAccountState: _updateAccountState);
  }
}
