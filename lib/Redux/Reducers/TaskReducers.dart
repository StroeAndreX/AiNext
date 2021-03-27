import 'package:AiOrganization/Core/Firebase/CollectionsDB.dart';
import 'package:AiOrganization/Core/Search.dart';
import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Models/Task.dart';
import 'package:AiOrganization/Redux/Actions/CollectionActions.dart';
import 'package:AiOrganization/Redux/Actions/TaskActions.dart';
import 'package:AiOrganization/Redux/Store.dart';

/// [Customize the DateTime of the Task]
List<Collection> customizeTaskDateTimeReducer(
    List<Collection> collections, CustomizeTaskDateTimeAction action) {
  /// Action @par - The Collection
  /// Action @par - The Task
  /// Action @par - The Time as int

  /// Call the  parameter Collection into a new variabile to alterate
  Collection altCollection = action.collection;

  /// Cal the parameter Task into a new variable to alter
  Task altTask = action.task;

  /// Alter the task object
  altTask = altTask.copyWith(dateTime: action.dateTime);

  /// Call all the tasks in the collections and re-insert the loadedTask
  List<Task> altTasks = altCollection.tasks;
  altTasks[Search.returnTaskIndex(altCollection, altTask)] = altTask;

  altCollection = altCollection.copyWith(tasks: altTasks);
  collections[Search.returnCollectionIndex(altCollection)] = altCollection;

  /// [Firestore]
  if (store.state.account.isPremium)
    CollectionsDB().modfiyTasks(altCollection, altTask);

  /// Save into the store
  return collections;
}

/// [Customize the Label of the Task]
List<Collection> customizeTaskLabelReducer(
    List<Collection> collections, CustomizeTaskLabelAction action) {
  /// Action @par - The Collection
  /// Action @par - The Task
  /// Action @par - The Label Name
  /// Action @par - The Label Color

  /// Call the  parameter Collection into a new variabile to alterate
  Collection altCollection = action.collection;

  /// Cal the parameter Task into a new variable to alter
  Task altTask = action.task;

  /// Alter the task object
  altTask =
      altTask.copyWith(colorLabel: action.colorLabel, label: action.labelName);

  /// Call all the tasks in the collections and re-insert the loadedTask
  List<Task> altTasks = altCollection.tasks;
  altTasks[Search.returnTaskIndex(altCollection, altTask)] = altTask;

  altCollection = altCollection.copyWith(tasks: altTasks);
  collections[Search.returnCollectionIndex(altCollection)] = altCollection;

  /// [Firestore]
  if (store.state.account.isPremium)
    CollectionsDB().modfiyTasks(altCollection, altTask);

  /// Save into the store
  return collections;
}

/// [Customize the Notes of the Task]
List<Collection> customizeTaskNotesReducer(
    List<Collection> collections, CustomizeTaskNotesAction action) {
  /// Action @par - The Collection
  /// Action @par - The Task
  /// Action @par - The Label Name
  /// Action @par - The Label Color

  /// Call the  parameter Collection into a new variabile to alterate
  Collection altCollection = action.collection;

  /// Cal the parameter Task into a new variable to alter
  Task altTask = action.task;

  /// Alter the task object
  List<String> altNotes = altTask.notes;
  altNotes.add(action.note);
  altTask = altTask.copyWith(notes: altNotes);

  /// Call all the tasks in the collections and re-insert the loadedTask
  List<Task> altTasks = altCollection.tasks;
  altTasks[Search.returnTaskIndex(altCollection, altTask)] = altTask;

  altCollection = altCollection.copyWith(tasks: altTasks);
  collections[Search.returnCollectionIndex(altCollection)] = altCollection;

  /// [Firestore]
  if (store.state.account.isPremium)
    CollectionsDB().modfiyTasks(altCollection, altTask);

  /// Save into the store
  return collections;
}

/// [Customize the Title of the Task]
List<Collection> customizeTaskNameReducer(
    List<Collection> collections, CustomizeTaskNameAction action) {
  /// Action @par - The Collection
  /// Action @par - The Task
  /// Action @par - The Label Name
  /// Action @par - The Label Color

  /// Call the  parameter Collection into a new variabile to alterate
  Collection altCollection = action.collection;

  /// Cal the parameter Task into a new variable to alter
  Task altTask = action.task;

  /// Alter the task object

  altTask = altTask.copyWith(title: action.taskName);

  /// Call all the tasks in the collections and re-insert the loadedTask
  List<Task> altTasks = altCollection.tasks;
  altTasks[Search.returnTaskIndex(altCollection, altTask)] = altTask;

  altCollection = altCollection.copyWith(tasks: altTasks);
  collections[Search.returnCollectionIndex(altCollection)] = altCollection;

  /// [Firestore]
  if (store.state.account.isPremium)
    CollectionsDB().modfiyTasks(altCollection, altTask);

  /// Save into the store
  return collections;
}

List<Collection> insertNewTaskReducer(
    List<Collection> collections, InsertNewTask action) {
  Task newTaskState = action.task;
  Collection altCollection = action.collection;

  altCollection.tasks.add(action.task);

  collections[Search.returnCollectionIndex(altCollection)] = altCollection;

  return collections;
}
