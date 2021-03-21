import 'package:AiOrganization/Models/Activity.dart';
import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Models/SubActivity.dart';
import 'package:AiOrganization/Models/Task.dart';
import 'package:AiOrganization/Redux/Store.dart';

class Search {
  /// [Return Indexed]
  static int returnCollectionIndex(Collection collection) {
    return store.state.collections
        .indexWhere((collectionInList) => collectionInList.id == collection.id);
  }

  static int returnTaskIndex(Collection collection, Task task) {
    return store.state.collections
        .elementAt(returnCollectionIndex(collection))
        .tasks
        .indexWhere((taskInList) => taskInList.id == task.id);
  }

  static int returnActivityIndex(Activity activity) {
    return store.state.activities
        .indexWhere((activityInList) => activityInList.id == activity.id);
  }

  static int returnSubActivityIndex(
      Activity activity, SubActivity subActivity) {
    return store.state.activities
        .elementAt(returnActivityIndex(activity))
        .subActivities
        .indexWhere(
            (subActivityInList) => subActivityInList.id == subActivity.id);
  }

  //// [Return Last ID]
  static int returnLastCollectionID() {
    return store.state.collections.last.id;
  }

  static int returnLastTaskID(Collection collection) {
    return store.state.collections
        .elementAt(returnCollectionIndex(collection))
        .tasks
        .last
        .id;
  }

  static int returnLastActivityID() {
    return store.state.activities.last.id;
  }

  static int returnLastSubActivityID(Activity activity) {
    return store.state.activities
        .elementAt(returnActivityIndex(activity))
        .subActivities
        .last
        .id;
  }

  //// [Return a new ID]
  static int returnNewCollectionID() {
    List<Collection> collections = store.state.collections;
    return (collections.isNotEmpty) ? returnLastCollectionID() + 1 : 1;
  }

  static int returnNewActivityID() {
    List<Activity> activities = store.state.activities;
    return (activities.isNotEmpty) ? returnLastActivityID() + 1 : 1;
  }

  static int returnNewTaskID(Collection collection) {
    List<Task> tasks = collection.tasks;
    return (tasks.isNotEmpty) ? returnLastTaskID(collection) + 1 : 1;
  }

  static int returnNewSubActivityID(Activity activity) {
    List<SubActivity> subActivities = activity.subActivities;
    return (subActivities.isNotEmpty)
        ? returnLastSubActivityID(activity) + 1
        : 1;
  }
}
