import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  /// [Creating account using Email & Password]
  Future<User> createAccount(String email, String password) async {
    User user;

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        //store.dispatch(UpdateErrorManagementState(weakPassword: true));
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        //store.dispatch(UpdateErrorManagementState(emailAlreadyInUse: true));
        print('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        //store.dispatch(UpdateErrorManagementState(invalidEmail: true));
        print('The email address is badly formatted.');
      } else {
        print(e.code);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  /// [Sign-In to an existing account using Email & Password]
  Future signIn(String email, String password) async {
    User user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //store.dispatch(LoginErrorsState(userNotFound: true));
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        //store.dispatch(LoginErrorsState(wrongPassword: true));
        print('Wrong password provided for that user.');
      }
    }

    return user;
  }

  /// [Check if there is an User signed-in or not]
  Future checkAuthState() async {
    auth.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  /// [Send Verification Email]
  Future emailVerification() async {
    User user = FirebaseAuth.instance.currentUser;

    if (!user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  /// [Code verification from Email]
  Future checkVerificationCode(String code) async {
    // Get the code from the email:
    try {
      await auth.checkActionCode(code);
      await auth.applyActionCode(code);

      // If successful, reload the user:
      auth.currentUser.reload();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-action-code') {
        print('The code is invalid.');
      }
    }
  }

  /// [Update default Info of the Auth Account]
  Future<User> updateAccountDefaultInfo(
      {String displayName, String photoUrl}) async {
    User _user = auth.currentUser;
    _user.updateProfile(
        displayName: displayName ?? _user.displayName,
        photoURL: photoUrl ?? _user.photoURL);

    await _user.reload();
    await _user.reload();
    await _user.reload();

    User reloadedUser = auth.currentUser;

    return reloadedUser;
  }

  /// [Code verification from Email]
  Future signOut() async {
    await auth.signOut();
  }

  static String generateVerificationCode({int digits = 6}) {
    final random = new Random();
    String code = "";
    for (int i = 0; i < digits; i++) {
      code += (random.nextInt(9) + 1).toString();
    }
    return code;
  }

  /// [Future Section: Google/Apple/Facebook]

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }
}
