import 'package:AiOrganization/Core/Firebase/ActivitesDB.dart';
import 'package:AiOrganization/Core/Search.dart';
import 'package:AiOrganization/Models/Activity.dart';
import 'package:AiOrganization/Models/SubActivity.dart';
import 'package:AiOrganization/Redux/Actions/ActivitiesActions.dart';
import 'package:AiOrganization/Redux/Actions/CollectionActions.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:redux/redux.dart';

Reducer<List<Activity>> activitiesReducers = combineReducers<List<Activity>>([
  TypedReducer<List<Activity>, NewActivityAction>(newActivityReducer),
  TypedReducer<List<Activity>, AddSubActivityAction>(addSubActivityReducer),
  TypedReducer<List<Activity>, LoadedItemsAction>(loadItemsReducer),
  TypedReducer<List<Activity>, RunActivityAction>(runActivityReducer),
  TypedReducer<List<Activity>, StopActivityAction>(stopActivityReducer),
  TypedReducer<List<Activity>, RunSubActivityAction>(runSubActivityReducer),
  TypedReducer<List<Activity>, StopSubActivityAction>(stopSubActivityReducer),
  TypedReducer<List<Activity>, RemoveSubActivityAction>(
      removeSubActivityReducer),
  TypedReducer<List<Activity>, RemoveActivityAction>(removeActivityReducer),
  TypedReducer<List<Activity>, CustomizeActivityAction>(
      customiozeActivityReducer),
  TypedReducer<List<Activity>, SetActivityUID>(setActivityUID),

  /// [Firebase implementation -> BadOptimization [TODO: Fix in the phase 6[Clean the project]]]
  TypedReducer<List<Activity>, InsertActivityAction>(insertNewActivity),
  TypedReducer<List<Activity>, ModifyActivityAction>(modifyActivity),
  TypedReducer<List<Activity>, InsertSubActivityAction>(
      insertNewSubActivityReducer),
  TypedReducer<List<Activity>, ModifySubActivityAction>(
      modifySubActivityReducer),
]);

/// [Create a new Activity and add into the store]
List<Activity> newActivityReducer(
    List<Activity> activities, NewActivityAction action) {
  /// Action @par - The activity
  /// Action @par - The activityName ---> Use to create new

  /// Call the newID for the new created activity
  int newID = Search.returnNewActivityID();

  /// Create the new Activity
  Activity newActivity = Activity(
      id: newID,
      title: (action.activityName.trim() != "" &&
              action.activityName.trim() != null)
          ? action.activityName
          : "New Activity " + newID.toString(),
      totalDuration: 0,
      dateWhenStarted: DateTime.now(),
      isRunning: false,
      subActivities: []);

  /// [Firestore implementation]
  if (store.state.account.isPremium)
    ActivitiesDB().createNewActivity(newActivity);

  return []
    ..addAll(activities)
    ..add(newActivity);
}

/// [Create a new SubActivity and add into the store]
List<Activity> addSubActivityReducer(
    List<Activity> activities, AddSubActivityAction action) {
  /// Action @par - The activity
  /// Action @par - The subActivityName ---> Use to create new

  /// Call the newID for the new created activity
  int newID = Search.returnNewSubActivityID(action.activity);

  /// Create the subActivity
  SubActivity subActivity = SubActivity(
      title: (action.subActivityName.trim() != "" &&
              action.subActivityName.trim() != null)
          ? action.subActivityName
          : "New SubActivity " + newID.toString(),
      totalDuration: 0,
      id: newID,
      dateWhenStarted: DateTime.now(),
      isRunning: false);

  /// Insert the new subActivity into the Activity Class
  Activity altActivity = action.activity;
  altActivity.subActivities.add(subActivity);
  activities[Search.returnActivityIndex(altActivity)] = altActivity;

  /// [Firestore implementation]
  if (store.state.account.isPremium)
    ActivitiesDB().addNewSubActivity(altActivity, subActivity);

  /// Save into the store
  return activities;
}

/// [Customize the Activity]
List<Activity> customiozeActivityReducer(
    List<Activity> activities, CustomizeActivityAction action) {
  /// Action @par - The activity
  /// Action @par - The new Activity name

  /// Call the  parameter Activity into a new variabile to alterate
  Activity altActivity = action.activity;

  /// Alter the activity object
  Activity alterActivity = altActivity.copyWith(title: action.newActivityName);
  activities[Search.returnActivityIndex(altActivity)] = alterActivity;

  /// [Firestore implementation]
  if (store.state.account.isPremium)
    ActivitiesDB().modfiyActivity(alterActivity);

  /// Save into the store
  return activities;
}

/// [Start the timer of a given Activity]
List<Activity> runActivityReducer(
    List<Activity> activities, RunActivityAction action) {
  /// Action @par - The activity

  /// Memorize the dateTime when you pressed the playButton
  DateTime newStartDateTime = DateTime.now();

  /// Alter the activity object so it has the new STATE - @isRunning and @startDateTime
  Activity altActivity = action.activity;
  altActivity =
      altActivity.copyWith(dateWhenStarted: newStartDateTime, isRunning: true);
  activities[Search.returnActivityIndex(altActivity)] = altActivity;

  /// [Firestore implementation]
  if (store.state.account.isPremium) ActivitiesDB().modfiyActivity(altActivity);

  /// Save into the store
  return activities;
}

/// [Pause the timer of a given Activity]
List<Activity> stopActivityReducer(
    List<Activity> activities, StopActivityAction action) {
  /// Action @par - The activity

  /// Calculate the duration between the @StartingDate and @StopDate
  int newTotalDuration = action.activity.totalDuration +
      (DateTime.now().millisecondsSinceEpoch -
          action.activity.dateWhenStarted.millisecondsSinceEpoch);

  /// Call the  parameter Activity into a new variabile to alterate
  Activity altActivity = action.activity;

  /// Alter the activity object so it has the new STATE - @isRunning and @totalDuration
  altActivity =
      altActivity.copyWith(totalDuration: newTotalDuration, isRunning: false);

  /// [THE CONNECTIONS] - When the main Activity is paused, all the subActivities have to automatically pause.
  altActivity.subActivities.forEach((subActivity) {
    store.dispatch(StopSubActivityAction(subActivity, altActivity));
  });

  /// Save the new state of the Activity object into the list of Activities
  activities[Search.returnActivityIndex(altActivity)] = altActivity;

  /// [Firestore implementation]
  if (store.state.account.isPremium) ActivitiesDB().modfiyActivity(altActivity);

  /// Save into the sotre
  return activities;
}

/// [Start the timer of a given SubActivity]
List<Activity> runSubActivityReducer(
    List<Activity> activities, RunSubActivityAction action) {
  /// Action @par - The activity
  /// Action @par - The subActivity

  /// Get the dateTime when you pressed the playButton
  DateTime newStartDateTime = DateTime.now();

  /// Call the  parameter SubActivity into a new variabile to alterate
  SubActivity altSubActivity = action.subActivity;

  /// Call the  parameter Activity into a new variabile to alterate
  Activity altActivity = action.activity;

  /// Alter the subActivity object so it has the new STATE - @isRunning and @DateWhenStarted
  altSubActivity = altSubActivity.copyWith(
      dateWhenStarted: newStartDateTime, isRunning: true);

  /// Save the new state of the SubActivity Object into the list of SubActivities
  altActivity.subActivities[
          Search.returnSubActivityIndex(altActivity, altSubActivity)] =
      altSubActivity;

  /// [THE CONNECTIONS] - When a subActivity is call to start the timer it has to automatically play the @mainActivity
  if (!altActivity.isRunning) {
    altActivity = altActivity.copyWith(
        dateWhenStarted: newStartDateTime,
        isRunning: true,
        subActivities: altActivity.subActivities);

    /// [Firestore implementation]
    if (store.state.account.isPremium)
      ActivitiesDB().modfiyActivity(altActivity);
  } else {
    altActivity =
        altActivity.copyWith(subActivities: altActivity.subActivities);
  }

  /// Save the new state of the Activity Object into the list of Activities
  activities[Search.returnActivityIndex(altActivity)] = altActivity;

  /// [Firestore implementation]
  if (store.state.account.isPremium)
    ActivitiesDB().modfiySubActivity(altActivity, altSubActivity);

  /// Save into the sotre
  return activities;
}

/// [Pause the timer of a given SubActivity]
List<Activity> stopSubActivityReducer(
    List<Activity> activities, StopSubActivityAction action) {
  /// Action @par - The activity
  /// Action @par - The subActivity

  if (action.subActivity.isRunning) {
    /// Calculate the duration between the @StartingDate and @StopDate
    int newTotalDuration = action.subActivity.totalDuration +
        (DateTime.now().millisecondsSinceEpoch -
            action.subActivity.dateWhenStarted.millisecondsSinceEpoch);

    /// Call the  parameter SubActivity into a new variabile to alterate
    SubActivity altSubActivity = action.subActivity;

    /// Call the  parameter Activity into a new variabile to alterate
    Activity altActivity = action.activity;

    /// Save the new state of the SubActivity Object into the list of SubActivities
    altSubActivity = altSubActivity.copyWith(
        totalDuration: newTotalDuration, isRunning: false);
    altActivity.subActivities[
            Search.returnSubActivityIndex(altActivity, altSubActivity)] =
        altSubActivity;

    /// Save the new state of the Activity Object into the list of Activities
    altActivity =
        altActivity.copyWith(subActivities: altActivity.subActivities);
    activities[Search.returnActivityIndex(altActivity)] = altActivity;

    /// [Firestore implementation]
    if (store.state.account.isPremium)
      ActivitiesDB().modfiySubActivity(altActivity, altSubActivity);
  }

  /// Save into the store
  return activities;
}

/// [Remove an Activity from the list --> Needed for @Firestore implementation]
List<Activity> removeActivityLocallyReducer(
    List<Activity> activities, RemoveActivityLocallyAction action) {
  /// Action @par - The activity

  // Remove activity from list
  activities.remove(action.activity);

  return activities;
}

/// [Remove an Activity from the list]
List<Activity> removeActivityReducer(
    List<Activity> activities, RemoveActivityAction action) {
  /// Action @par - The activity

  // Remove activity from list
  activities.remove(action.activity);

  /// [Firestore implementation]
  if (store.state.account.isPremium)
    ActivitiesDB().removeActivity(action.activity);

  return activities;
}

/// [Remove a subActivity from the list]
List<Activity> removeSubActivityReducer(
    List<Activity> activities, RemoveSubActivityAction action) {
  /// Action @par - The Activity
  /// Action @par - The subActivity

  // Call the list of SubActivities
  List<SubActivity> subActivities = action.activity.subActivities;

  // Remove the given subActivity
  subActivities.removeWhere((subActivity) => subActivity == action.subActivity);

  /// Call the  parameter Activity into a new variabile to alterate
  Activity altActivity = action.activity;

  ///Save the new state of the Activity Object into the list of Activities
  altActivity = altActivity.copyWith(subActivities: subActivities);

  // Insert the altActivity to collections List
  activities[Search.returnActivityIndex(altActivity)] = altActivity;

  /// [Firestore implementation]
  if (store.state.account.isPremium)
    ActivitiesDB().removeSubActivity(altActivity, action.subActivity);

  /// Return the new list of collections
  return activities;
}

/// [Load -> Needed for saving system]
List<Activity> loadItemsReducer(
    List<Activity> activities, LoadedItemsAction action) {
  return action.activities;
}

/// [Set the Document UID of the collection --> Firebase implementation]
List<Activity> setActivityUID(
    List<Activity> activities, SetActivityUID action) {
  /// Action @par - The Collection
  /// Action @par - The uid

  /// Call the  parameter Collection into a new variabile to alterate
  Activity altActivity = action.activity;

  /// Alter the collection object
  altActivity = altActivity.copyWith(uid: action.uid);
  activities[Search.returnActivityIndex(action.activity)] = altActivity;

  /// Save into the store
  return activities;
}

//
///// [Activities Implementation]
//

List<Activity> insertNewActivity(
    List<Activity> activities, InsertActivityAction action) {
  /// Add the fetched activity into the list [Obsolet as the ids might cause issues --> To fix in the phase 6]
  return []
    ..addAll(activities)
    ..add(action.activity);
}

List<Activity> modifyActivity(
    List<Activity> activities, ModifyActivityAction action) {
  Activity modifiedActivity = action.activity;

  activities[Search.returnActivityIndex(modifiedActivity)] = modifiedActivity;

  return activities;
}

List<Activity> insertNewSubActivityReducer(
    List<Activity> activities, InsertSubActivityAction action) {
  SubActivity newSubActivity = action.subActivity;
  Activity altActivity = action.activity;

  altActivity.subActivities.add(newSubActivity);

  activities[Search.returnActivityIndex(altActivity)] = altActivity;

  return activities;
}

List<Activity> modifySubActivityReducer(
    List<Activity> activities, ModifySubActivityAction action) {
  SubActivity subActivityState = action.subActivity;
  Activity altActivity = action.activity;

  altActivity.subActivities[
          Search.returnSubActivityIndex(action.activity, action.subActivity)] =
      subActivityState;

  activities[Search.returnActivityIndex(altActivity)] = altActivity;

  return activities;
}
