import 'package:AiOrganization/Core/Firebase/CollectionsDB.dart';
import 'package:AiOrganization/Core/Search.dart';
import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Models/Task.dart';
import 'package:AiOrganization/Redux/Actions/ActivitiesActions.dart';
import 'package:AiOrganization/Redux/Actions/CollectionActions.dart';
import 'package:AiOrganization/Redux/Actions/TaskActions.dart';
import 'package:AiOrganization/Redux/Reducers/TaskReducers.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

Reducer<List<Collection>> collectionsReducers =
    combineReducers<List<Collection>>([
  TypedReducer<List<Collection>, NewCollectionAction>(newCollectionReducer),
  TypedReducer<List<Collection>, NewEmptyCollectionAction>(
      newEmptyCollectionReducer),
  TypedReducer<List<Collection>, AddNewTaskToCollection>(
      addTaskToCollectionReducer),

  TypedReducer<List<Collection>, RemoveCollectionAction>(
      removeCollectionReducer),
  TypedReducer<List<Collection>, RemoveTaskAction>(removeTaskReducer),
  TypedReducer<List<Collection>, SetCompleteTaskAction>(setCompleteTaskReducer),
  TypedReducer<List<Collection>, UnSetCompleteTaskAction>(
      unsetCompleteTaskReducer),

  /// [COLLECTION CUSTOMIZATION]
  TypedReducer<List<Collection>, CustomizeCollectionNameAction>(
      customiozeCollectionNameReducer),
  TypedReducer<List<Collection>, CustomizeCollectionColorAction>(
      customiozeCollectionColorReducer),
  TypedReducer<List<Collection>, CustomizeCollectionIconAction>(
      customiozeCollectionIconReducer),

  //// [TASKS]
  TypedReducer<List<Collection>, CustomizeTaskNameAction>(
      customizeTaskNameReducer),
  TypedReducer<List<Collection>, CustomizeTaskDateTimeAction>(
      customizeTaskDateTimeReducer),
  TypedReducer<List<Collection>, CustomizeTaskLabelAction>(
      customizeTaskLabelReducer),
  TypedReducer<List<Collection>, CustomizeTaskNotesAction>(
      customizeTaskNotesReducer),
  TypedReducer<List<Collection>, LoadedItemsAction>(loadItemsReducer),

  /// [Firebase implementation]
  TypedReducer<List<Collection>, SetCollectionUID>(setCollectionUID),
  TypedReducer<List<Collection>, InsertNewCollection>(insertNewCollection),
  TypedReducer<List<Collection>, ModifyCollection>(modifyCollectionReducer),
  TypedReducer<List<Collection>, NewTaskState>(newTaskState),
  TypedReducer<List<Collection>, InsertNewTask>(insertNewTaskReducer),
  TypedReducer<List<Collection>, RemoveLocalTaskAction>(removeLocalTaskReducer),
]);

/// [Create a new Collection With InitTask and add into the store]
List<Collection> newCollectionReducer(
    List<Collection> collections, NewCollectionAction action) {
  /// Action @par - The New Collection name
  /// Action @par - The CollectionType
  /// Action @par - The task

  /// Create the new collection
  Collection newCollection = Collection(
      id: Search.returnNewCollectionID(),
      title: action.collectionName,
      tasks: []..add(action.task),
      iconData: Icons.calendar_today_outlined,
      collectionType: action.collectionType ?? CollectionType.CREATED,
      color: Colors.orange);

  /// [Firestore] Register the new collection on server
  CollectionsDB().createNewCollection(newCollection);

  /// Create new Collection and add the first @Task
  return []
    ..addAll(collections)
    ..add(newCollection);
}

/// [Create a new Empty Collection and add into the store]
List<Collection> newEmptyCollectionReducer(
    List<Collection> collections, NewEmptyCollectionAction action) {
  /// Action @par - The New Collection name

  /// Create the new collection
  Collection newCollection = Collection(
      id: Search.returnNewCollectionID(),
      title: action.collectionName,
      tasks: [],
      iconData: Icons.menu_open,
      collectionType: CollectionType.CREATED,
      color: ColorsConfig.primary);

  /// [Firestore] Register the new collection on server
  CollectionsDB().createNewCollection(newCollection);

  /// Add the created collection into the list
  return []
    ..addAll(collections)
    ..add(newCollection);
}

/// [Add a new Task into the Collection]
List<Collection> addTaskToCollectionReducer(
    List<Collection> collections, AddNewTaskToCollection action) {
  /// Action @par - The Collection
  /// Action @par - The Task ---> Need to store into the given collection

  // Call the parameter Collection into a new variable to alter
  Collection altCollection = action.collection;

  /// Insert the new task into the collection
  altCollection.tasks.add(action.task);

  // alter the collections in the store and then return them
  collections[Search.returnCollectionIndex(altCollection)] = altCollection;

  /// [Firestore] Register this new task on server
  if (store.state.account.isPremium)
    CollectionsDB().addNewTask(altCollection, action.task);

  /// Save into the store
  return collections;
}

/// [Remove a Collection from the list]
List<Collection> removeCollectionReducer(
    List<Collection> collections, RemoveCollectionAction action) {
  /// Action @par - The Collection

  /// Firebase issue: Need to find the colleciton by id
  Collection collectionToRemove = collections
      .firstWhere((collection) => collection.id == action.collection.id);

  // Remove collection from list
  collections.remove(collectionToRemove);

  /// [Firestore]
  if (store.state.account.isPremium)
    CollectionsDB().removeCollection(action.collection);

  return collections;
}

/// [Remove a Task from the list]
List<Collection> removeTaskReducer(
    List<Collection> collections, RemoveTaskAction action) {
  /// Action @par - The Collection
  /// Action @par - The Task ---> Need to be deleted

  // Call the parameter Collection into a new variable to alter
  Collection altCollection = action.collection;

  // Call the list of Tasks from the given Collection
  List<Task> tasks = altCollection.tasks;

  /// Remove the given task from the list
  tasks.removeWhere((task) => task == action.task);

  /// Save the new state of the list of tasks into the Collection Object
  altCollection = altCollection.copyWith(tasks: tasks);

  // Insert the altCollection to collections List
  collections[Search.returnCollectionIndex(altCollection)] = altCollection;

  /// [Firestore]
  if (store.state.account.isPremium)
    CollectionsDB().removeTask(altCollection, action.task);

  /// Save into the store
  return collections;
}

/// [Remove a Task from the list --- ONLY LOCAL]
List<Collection> removeLocalTaskReducer(
    List<Collection> collections, RemoveLocalTaskAction action) {
  /// Action @par - The Collection
  /// Action @par - The Task ---> Need to be deleted

  // Call the parameter Collection into a new variable to alter
  Collection altCollection = action.collection;

  // Call the list of Tasks from the given Collection
  List<Task> tasks = altCollection.tasks;

  /// Firebase issue:
  Task removeTask = tasks.firstWhere((element) => element.id == action.task.id);

  /// Remove the given task from the list
  tasks.removeWhere((task) => task == removeTask);

  /// Save the new state of the list of tasks into the Collection Object
  altCollection = altCollection.copyWith(tasks: tasks);

  // Insert the altCollection to collections List
  collections[Search.returnCollectionIndex(altCollection)] = altCollection;

  /// Save into the store
  return collections;
}

/// [Customize the CollectionName]
List<Collection> customiozeCollectionNameReducer(
    List<Collection> collections, CustomizeCollectionNameAction action) {
  /// Action @par - The Collections
  /// Action @par - The new Collection name

  /// Call the  parameter Collection into a new variabile to alterate
  Collection altCollection = action.collection;

  /// Alter the collection object
  altCollection = altCollection.copyWith(title: action.newCollectionName);
  collections[Search.returnCollectionIndex(altCollection)] = altCollection;

  /// [Firestore]
  if (store.state.account.isPremium)
    CollectionsDB().modfiyCollection(altCollection);

  /// Save into the store
  return collections;
}

/// [Customize the Collection Color]
List<Collection> customiozeCollectionColorReducer(
    List<Collection> collections, CustomizeCollectionColorAction action) {
  /// Action @par - The Collection
  /// Action @par - The new Collection color

  /// Call the  parameter Collection into a new variabile to alterate
  Collection altCollection = action.collection;

  /// Alter the collection object
  altCollection = altCollection.copyWith(color: action.color);
  collections[Search.returnCollectionIndex(altCollection)] = altCollection;

  /// [Firestore]
  if (store.state.account.isPremium)
    CollectionsDB().modfiyCollection(altCollection);

  /// Save into the store
  return collections;
}

/// [Customize the Collection]
List<Collection> customiozeCollectionIconReducer(
    List<Collection> collections, CustomizeCollectionIconAction action) {
  /// Action @par - The Collection
  /// Action @par - The new Collection name

  /// Call the  parameter Collection into a new variabile to alterate
  Collection altCollection = action.collection;

  /// Alter the collection object
  altCollection = altCollection.copyWith(iconData: action.icon);
  collections[Search.returnCollectionIndex(altCollection)] = altCollection;

  /// [Firestore]
  if (store.state.account.isPremium)
    CollectionsDB().modfiyCollection(altCollection);

  /// Save into the store
  return collections;
}

/// [Set a Task from the Collection as @completed]
List<Collection> setCompleteTaskReducer(
    List<Collection> collections, SetCompleteTaskAction action) {
  /// Action @par - The Collection
  /// Action @par - The Taks

  /// Call the  parameter Collection into a new variabile to alterate
  Collection altCollection = action.collection;

  /// Call the List of tasks from the given collection
  List<Task> tasks = altCollection.tasks;

  /// Call the parameter Task into a new variable to alter
  Task altTask = action.task;
  altTask = altTask.copyWith(isCompleted: true);

  /// Save the new state of the Task into the list of Tasks
  tasks[Search.returnTaskIndex(altCollection, altTask)] = altTask;

  /// Save the new state of the list of tasks into the given collection
  Collection alterCollection = altCollection.copyWith(tasks: tasks);
  collections[Search.returnCollectionIndex(altCollection)] = alterCollection;

  /// [Firestore]
  if (store.state.account.isPremium)
    CollectionsDB().modfiyTasks(altCollection, altTask);

  /// Save into the store
  return collections;
}

/// [Set a Task from the Collection as @uncompleted]
List<Collection> unsetCompleteTaskReducer(
    List<Collection> collections, UnSetCompleteTaskAction action) {
  /// Action @par - The Collection
  /// Action @par - The Taks

  /// Call the  parameter Collection into a new variabile to alterate
  Collection altCollection = action.collection;

  /// Call the List of tasks from the given collection
  List<Task> tasks = altCollection.tasks;

  /// Call the parameter Task into a new variable to alter
  Task altTask = action.task;
  altTask = altTask.copyWith(isCompleted: false);

  /// Save the new state of the Task into the list of Tasks
  tasks[Search.returnTaskIndex(altCollection, altTask)] = altTask;

  /// Save the new state of the list of tasks into the given collection
  Collection alterCollection = altCollection.copyWith(tasks: tasks);
  collections[Search.returnCollectionIndex(altCollection)] = alterCollection;

  /// [Firestore]
  if (store.state.account.isPremium)
    CollectionsDB().modfiyTasks(altCollection, altTask);

  /// Save into the store
  return collections;
}

/// [Load -> Needed for saving system] Make it better
List<Collection> loadItemsReducer(
    List<Collection> collections, LoadedItemsAction action) {
  return action.collections;
}

/// [Set the Document UID of the collection --> Firebase implementation]
List<Collection> setCollectionUID(
    List<Collection> collections, SetCollectionUID action) {
  /// Action @par - The Collection
  /// Action @par - The uid

  print("This reducer should fawking work: " + action.uid);

  /// Call the  parameter Collection into a new variabile to alterate
  Collection altCollection = action.collection;

  /// Alter the collection object
  altCollection = altCollection.copyWith(uid: action.uid);
  collections[Search.returnCollectionIndex(altCollection)] = altCollection;

  /// Save into the store
  return collections;
}

/// [Firebase integration -- Other utilities]
List<Collection> insertNewCollection(
    List<Collection> collections, InsertNewCollection action) {
  Collection collection = action.collection;

  /// Add the created collection into the list
  return []
    ..addAll(collections)
    ..add(collection);
}

List<Collection> modifyCollectionReducer(
    List<Collection> collections, ModifyCollection action) {
  // Call the parameter Collection into a new variable to alter
  Collection altCollection = action.collection;

  // Insert the altCollection to collections List
  collections[Search.returnCollectionIndex(altCollection)] = altCollection;

  return collections;
}

List<Collection> newTaskState(
    List<Collection> collections, NewTaskState action) {
  Task newTaskState = action.task;
  Collection altCollection = action.collection;

  altCollection.tasks[Search.returnTaskIndex(altCollection, newTaskState)] =
      newTaskState;

  collections[Search.returnCollectionIndex(altCollection)] = altCollection;

  return collections;
}
