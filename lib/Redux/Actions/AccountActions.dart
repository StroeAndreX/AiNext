import 'package:AiOrganization/Models/Account.dart';

class UpdateAccountState {
  final Account account;

  UpdateAccountState(this.account);
}

class CreateAccountAction {
  final String email;
  final String password;

  final String displayName;

  CreateAccountAction(this.email, this.password, this.displayName);
}

class SignInWithEmailAction {
  final String email;
  final String password;

  SignInWithEmailAction(this.email, this.password);
}

class SignInWithGoogleAction {}

class UpdateDefaultAccountInfo {
  String displayName;
  String photoURL;

  UpdateDefaultAccountInfo({this.displayName, this.photoURL});
}

class SignOutAction {}
