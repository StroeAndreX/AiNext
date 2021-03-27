import 'package:AiOrganization/Core/Search.dart';
import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Models/Task.dart';
import 'package:AiOrganization/Redux/Actions/CollectionActions.dart';
import 'package:AiOrganization/Redux/Actions/TaskActions.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionsDBListeners {
  CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('Collection');

  /// [Read in-real-time the tasks in the collection]
  Future<void> listenToCollectionCalendarTasks(String collectionName) async {
    /// TODO: Check if we already have the id --- Reducing the reading

    /// Collection uid
    String collectionUID;
    Collection loadedCollection;

    ///  Check if the collection Calendar is already loadedInApp
    List<Collection> collectionsInStore = store.state.collections;
    int collectionExist = collectionsInStore
        .indexWhere((collection) => collection.title == collectionName);

    if (collectionExist == -1 /*  [Collection doesnt exist]  */) {
      //Query the collection
      QuerySnapshot _calendarCollectionQuery = await _collectionReference
          .where("title", isEqualTo: collectionName)
          .where("collectionType", isEqualTo: 0)
          .where("accountUID", isEqualTo: store.state.account.uid)
          .get();

      /// Alter the fetch data
      Map<String, dynamic> collectionData =
          _calendarCollectionQuery.docs.first.data();
      collectionData['uid'] = _calendarCollectionQuery.docs.first.id;
      collectionData['id'] = Search.returnNewCollectionID();

      collectionUID = _calendarCollectionQuery.docs.first.id;

      // Init the collection
      loadedCollection = Collection.fromMap(collectionData, []);

      /// store the connection into the store
      store.dispatch(InsertNewCollection(loadedCollection));
    } else {
      loadedCollection = collectionsInStore
          .firstWhere((collection) => collection.title == collectionName);
    }

    /// Query the tasks
    CollectionReference collectionTasksReference =
        _collectionReference.doc(collectionUID).collection('Tasks');

    /// Listen to each task stored in the queried Collection
    collectionTasksReference.snapshots().listen((tasks) {
      int tasksLength = tasks.docs.length;
      int tasksChangesLength = tasks.docChanges.length;

      if (tasksChangesLength > tasksLength) {
        Map<String, dynamic> removedTaskData =
            tasks.docChanges.first.doc.data();

        Task altTask = Task.fromMap(removedTaskData);

        print("Remove this...");
        store.dispatch(RemoveTaskAction(loadedCollection, altTask));
      }

      if (tasks.docs.isEmpty) {
        print("No elements in the list");
        return;
      }

      int taskExist;
      tasks.docs.forEach((task) {
        // Init the task
        Task newTask = new Task.fromMap(task.data());

        /// Is the new State Docs already in list?
        taskExist =
            loadedCollection.tasks.indexWhere((task) => task.id == newTask.id);

        if (taskExist == -1) {
          store.dispatch(InsertNewTask(loadedCollection, newTask));
        } else {
          store.dispatch(NewTaskState(newTask, loadedCollection));
        }
      });
    });
  }

  /// [Read in-real-time all tasks in the collectionss]
  Future<void> listenToCollectionTasks(Collection collection) async {
    /// TODO: Check if we already have the id --- Reducing the reading

    /// Query the tasks
    CollectionReference collectionTasksReference =
        _collectionReference.doc(collection.uid).collection('Tasks');

    /// Listen to each task stored in the queried Collection
    collectionTasksReference.snapshots().listen((tasks) {
      int tasksLength = tasks.docs.length;
      int tasksChangesLength = tasks.docChanges.length;

      bool found = false;
      tasks.docChanges.forEach((docChanged) {
        tasks.docs.forEach((doc) {
          if (doc.data()['id'] == docChanged.doc.data()['id']) {
            found = true;
            return;
          }
        });

        print("Found: " + found.toString());
      });

      print("tasksLength: " + tasksLength.toString());
      print("tasksChangesLength: " + tasksChangesLength.toString());

      if (!found) {
        Map<String, dynamic> removedTaskData =
            tasks.docChanges.first.doc.data();

        Task altTask = Task.fromMap(removedTaskData);

        print("Remove this..." + altTask.toString());
        store.dispatch(RemoveLocalTaskAction(collection, altTask));
      }

      if (tasks.docs.isEmpty) {
        print("No elements in the list");
        return;
      }

      int taskExist;
      tasks.docs.forEach((task) {
        // Init the task
        Task newTask = new Task.fromMap(task.data());

        /// Is the new State Docs already in list?
        taskExist =
            collection.tasks.indexWhere((task) => task.id == newTask.id);

        if (taskExist == -1) {
          store.dispatch(InsertNewTask(collection, newTask));
        } else {
          store.dispatch(NewTaskState(newTask, collection));
        }
      });
    });
  }

  /// [Read in-real-time all the collections]
  Future<void> listenToCollections() async {
    /// TODO: Check if we already have the id --- Reducing the reading
    /// Listen to each task stored in the queried Collection

    Query _collectionsQuery =
        _collectionReference.where('collectionType', isEqualTo: 1);

    _collectionsQuery.snapshots().listen((collections) {
      int collectionsLength = collections.docs.length;
      int collectionsChangesLength = collections.docChanges.length;

      if (collectionsChangesLength > collectionsLength) {
        Map<String, dynamic> removedCollectionData =
            collections.docChanges.first.doc.data();

        Collection altCollection =
            Collection.fromMap(removedCollectionData, []);
        altCollection.copyWith(uid: collections.docChanges.first.doc.id);

        print("Remove this...");
        store.dispatch(RemoveCollectionAction(altCollection));
      }

      if (collections.docs.isEmpty) {
        print("No elements in the list");
        return;
      }

      int collectionExist;
      collections.docs.forEach((collection) {
        // Init the task
        Collection newCollection = Collection.fromMap(collection.data(), []);
        newCollection = newCollection.copyWith(uid: collection.id);

        /// Is the new State Docs already in list?
        collectionExist = store.state.collections
            .indexWhere((collection) => collection.id == newCollection.id);

        if (collectionExist == -1) {
          store.dispatch(InsertNewCollection(newCollection));
        } else {
          store.dispatch(ModifyCollection(newCollection));
        }
      });
    });
  }
}
