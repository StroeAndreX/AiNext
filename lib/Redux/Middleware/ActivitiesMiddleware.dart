import 'dart:async';
import 'dart:convert';

import 'package:AiOrganization/Models/Activity.dart';
import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Models/SubActivity.dart';
import 'package:AiOrganization/Models/Task.dart';
import 'package:AiOrganization/Redux/Actions/ActivitiesActions.dart';
import 'package:AiOrganization/Redux/Actions/CollectionActions.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Middleware<AppState>> appStateMiddleware([
  AppState state = const AppState(activities: []),
]) {
  final loadItems = _loadFromPrefs(state);
  final saveItems = _saveToPrefs(state);

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
    TypedMiddleware<AppState, GetItemsAction>(loadItems),
  ];
}

Middleware<AppState> _loadFromPrefs(AppState state) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    await loadFromPrefs().then((state) =>
        store.dispatch(LoadedItemsAction(state.activities, state.collections)));
  };
}

Middleware<AppState> _saveToPrefs(AppState state) {
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
  var collectionsJSON = jsonEncode(collections.map((e) => e.toMap()).toList());

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
