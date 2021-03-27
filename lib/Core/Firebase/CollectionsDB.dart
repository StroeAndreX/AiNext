import 'package:AiOrganization/Core/Search.dart';
import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Models/Task.dart';
import 'package:AiOrganization/Redux/Actions/CollectionActions.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionsDB {
  CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('Collection');

  /// [Create the a document for the created Collection]
  Future<void> createNewCollection(Collection collection) async {
    /// Call all the data of the collection into a simple Map
    Map<String, dynamic> collectionFirestore = collection.toMapFirestore();
    collectionFirestore['accountUID'] = store.state.account.uid;

    /// Create UserDocument and set the init Data
    DocumentReference createdCollectionDocument =
        await _collectionReference.add(collectionFirestore);

    /// Create a subDocument contianing all the Tasks
    CollectionReference _documentReference = _collectionReference
        .doc(createdCollectionDocument.id)
        .collection('Tasks');

    collection.tasks.forEach((task) async {
      await _documentReference.add(task.toMap());
    });

    /// New State for the collection into the store
    store.dispatch(SetCollectionUID(collection, createdCollectionDocument.id));
  }

  /// [Insert new Tasks into the subDocument @Tasks of the collectionDocument on firestore]
  Future<void> addNewTasks(
      Collection collection, List<Task> recentAdded) async {
    /// [Checker] ---> Ensure the existance of the Collection into the firestore document:: If it has the [@uid] setted, then exists on firestore
    if (collection.uid != null && collection.uid.trim() != "") {
      /// Call the subDocument contianing all the Tasks
      CollectionReference _documentReference =
          _collectionReference.doc(collection.uid).collection('Tasks');

      /// Insert all the new tasks into the subDocument Task
      recentAdded.forEach((task) async {
        await _documentReference.add(task.toMap());
      });
    } else {
      createNewCollection(collection);
    }
  }

  /// [Insert new Tasks into the subDocument @Tasks of the collectionDocument on firestore]
  Future<void> addNewTask(Collection collection, Task newTask) async {
    print("Wtf: " + collection.uid.toString());

    /// [Checker] ---> Ensure the existance of the Collection into the firestore document:: If it has the [@uid] setted, then exists on firestore
    if (collection.uid != null && collection.uid.trim() != "") {
      /// Call the subDocument contianing all the Tasks
      CollectionReference _documentReference =
          _collectionReference.doc(collection.uid).collection('Tasks');

      /// Insert the new task into the subDocument Task
      await _documentReference.add(newTask.toMap());
    } else {
      createNewCollection(collection);
    }
  }

  /// [Modify a given Task]
  Future<void> modfiyTasks(Collection collection, Task modifiedTask) async {
    /// Call the subCollection on the firestore so it can access the query
    CollectionReference _tasksCollectionFirestore =
        _collectionReference.doc(collection.uid).collection('Tasks');

    /// Query the task that has id == X
    QuerySnapshot queriedTask = await _tasksCollectionFirestore
        .where("id", isEqualTo: modifiedTask.id)
        .get();

    // Get the UID of taks
    String taskUID = queriedTask.docs.first.id;

    /// Send to server
    await _tasksCollectionFirestore.doc(taskUID).update(modifiedTask.toMap());
  }

  /// [Modify Collection]
  Future<void> modfiyCollection(Collection collection) async {
    /// [Checker] ---> Ensure the existance of the Collection into the firestore document:: If it has the [@uid] setted, then exists on firestore
    if (collection.uid != null && collection.uid.trim() != "") {
      await _collectionReference
          .doc(collection.uid)
          .update(collection.toMapFirestore());
    } else {
      createNewCollection(collection);
    }
  }

  /// [Remove Collection]
  Future<void> removeCollection(Collection collection) async {
    /// [Checker] ---> Ensure the existance of the Collection into the firestore document:: If it has the [@uid] setted, then exists on firestore
    if (collection.uid != null && collection.uid.trim() != "") {
      await _collectionReference.doc(collection.uid).delete();
    }
  }

  /// [Remove Task]
  Future<void> removeTask(Collection collection, Task removeTask) async {
    /// [Checker] ---> Ensure the existance of the Collection into the firestore document:: If it has the [@uid] setted, then exists on firestore
    if (collection.uid != null && collection.uid.trim() != "") {
      /// Call the subCollection on the firestore so it can access the query
      CollectionReference _tasksCollectionFirestore =
          _collectionReference.doc(collection.uid).collection('Tasks');

      /// Query the task that has id == X
      QuerySnapshot queriedTask = await _tasksCollectionFirestore
          .where("id", isEqualTo: removeTask.id)
          .get();

      // Get the UID of taks
      String taskUID = queriedTask.docs.first.id;

      /// Send to server
      await _tasksCollectionFirestore.doc(taskUID).delete();
    }
  }
}
