import 'dart:convert';

import 'package:AiOrganization/Models/Account.dart';
import 'package:AiOrganization/Models/Activity.dart';
import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Models/SubActivity.dart';
import 'package:AiOrganization/Models/Task.dart';
import 'package:AiOrganization/Redux/Actions/AccountActions.dart';
import 'package:AiOrganization/Redux/Actions/CollectionActions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoreSystemMiddleware {
  Middleware<AppState> loadSystem(AppState state) {
    return (Store<AppState> store, action, NextDispatcher next) async {
      next(action);

      FirebaseAuth.instance.authStateChanges().listen((User user) async {
        if (user == null) {
          // If the user is going to be null then the application will be redirected in a "NoProfile Zone"
        } else {
          Account newAccountState = store.state.account.copyWith(
              email: user.email,
              displayName: user.displayName,
              uid: user.uid,
              photoUrl: user.photoURL);

          store.dispatch(UpdateAccountState(newAccountState));
        }
        //if (user != null) store.dispatch(GetAccountType(uid: user.uid));
      });

      await loadFromPrefs().then((state) => store
          .dispatch(LoadedItemsAction(state.activities, state.collections)));
    };
  }

  Middleware<AppState> saveSystem(AppState state) {
    return (Store<AppState> store, action, NextDispatcher next) {
      next(action);

      saveToPrefs(store.state);
    };
  }

  void saveToPrefs(AppState state) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<Activity> activities = state.activities;
    List<Collection> collections = state.collections;

    var activitiesJSON = jsonEncode(activities.map((e) => e.toMap()).toList());
    var collectionsJSON =
        jsonEncode(collections.map((e) => e.toMap()).toList());

    print("ActivitiesJSON: " + activitiesJSON);
    print("CollectionsJSON: " + collectionsJSON);

    //var string = json.encode(activitiesMap);
    await preferences.setString('activitiesState', activitiesJSON);
    await preferences.setString('collectionsState', collectionsJSON);
  }

  Future<AppState> loadFromPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var activitiesString = preferences.getString('activitiesState');
    var collectionsString = preferences.getString('collectionsState');

    if (activitiesString != null || collectionsString != null) {
      List<dynamic> activitiesJSON = jsonDecode(activitiesString);
      List<dynamic> collectionsJSON = jsonDecode(collectionsString);

      //Activities Data
      List<Activity> activities = (activitiesJSON).map((i) {
        List<dynamic> dynamicSubActivities = jsonDecode(i['subActivities']);
        List<SubActivity> subActivities =
            (dynamicSubActivities).map((i) => SubActivity.fromMap(i)).toList();

        return Activity.fromMap(i, subActivities);
      }).toList();

      /// Collections Data
      List<Collection> collections = (collectionsJSON).map((i) {
        List<dynamic> dynamicTask = jsonDecode(i['tasks']);
        List<Task> collectionTask =
            (dynamicTask).map((i) => Task.fromMap(i)).toList();

        return Collection.fromMap(i, collectionTask);
      }).toList();

      print("ActivitiesJSON: " + activitiesJSON.toString());
      print("CollectionsJSON: " + collectionsJSON.toString());

      //print("ActivitiesMiddleware: " + activities.toString());

      return AppState(
          activities: activities ?? [], collections: collections ?? []);
    }
    return AppState.initialState();
  }
}
