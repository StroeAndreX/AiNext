import 'dart:async';
import 'dart:convert';

import 'package:AiOrganization/Models/Activity.dart';
import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Models/SubActivity.dart';
import 'package:AiOrganization/Models/Task.dart';
import 'package:AiOrganization/Redux/Actions/AccountActions.dart';
import 'package:AiOrganization/Redux/Actions/ActivitiesActions.dart';
import 'package:AiOrganization/Redux/Actions/CollectionActions.dart';
import 'package:AiOrganization/Redux/Middleware/AccountMiddleware.dart';
import 'package:AiOrganization/Redux/Middleware/CoreSystemMiddleware.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Middleware<AppState>> appStateMiddleware([
  AppState state = const AppState(activities: []),
]) {
  CoreSystemMiddleware _coreSystemMiddleware = new CoreSystemMiddleware();
  AccountMiddleware _accountMiddleware = new AccountMiddleware();

  final loadItems = _coreSystemMiddleware.loadSystem(state);
  final saveItems = _coreSystemMiddleware.saveSystem(state);

  final createAccount = _accountMiddleware.createAccount(state);
  final signInWithGoogle = _accountMiddleware.signInWithGoogle(state);
  final signInWithEmail = _accountMiddleware.signInWithEmail(state);
  final signOutAccount = _accountMiddleware.signOutAccount(state);

  return [
    TypedMiddleware<AppState, NewActivityAction>(saveItems),
    TypedMiddleware<AppState, NewCollectionAction>(saveItems),
    TypedMiddleware<AppState, NewEmptyCollectionAction>(saveItems),
    TypedMiddleware<AppState, AddSubActivityAction>(saveItems),
    TypedMiddleware<AppState, AddNewTaskToCollection>(saveItems),
    TypedMiddleware<AppState, CustomizeActivityAction>(saveItems),
    TypedMiddleware<AppState, CustomizeCollectionNameAction>(saveItems),
    TypedMiddleware<AppState, RunActivityAction>(saveItems),
    TypedMiddleware<AppState, StopActivityAction>(saveItems),
    TypedMiddleware<AppState, RemoveActivityAction>(saveItems),
    TypedMiddleware<AppState, RemoveSubActivityAction>(saveItems),
    TypedMiddleware<AppState, RemoveCollectionAction>(saveItems),
    TypedMiddleware<AppState, RemoveTaskAction>(saveItems),
    TypedMiddleware<AppState, SetCompleteTaskAction>(saveItems),
    TypedMiddleware<AppState, UnSetCompleteTaskAction>(saveItems),
    TypedMiddleware<AppState, UnSetCompleteTaskAction>(saveItems),
    TypedMiddleware<AppState, UnSetCompleteTaskAction>(saveItems),

    //// [Account Middlewares]
    TypedMiddleware<AppState, CreateAccountAction>(createAccount),
    TypedMiddleware<AppState, SignInWithGoogleAction>(signInWithGoogle),
    TypedMiddleware<AppState, SignInWithEmailAction>(signInWithEmail),
    TypedMiddleware<AppState, SignOutAction>(signOutAccount),

    //// [Load from Prefs or Cloud - Middlewares]
    TypedMiddleware<AppState, GetItemsAction>(loadItems),
  ];
}
