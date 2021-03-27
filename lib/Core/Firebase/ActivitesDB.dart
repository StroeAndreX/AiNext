import 'package:AiOrganization/Core/Search.dart';
import 'package:AiOrganization/Models/Activity.dart';
import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Models/SubActivity.dart';
import 'package:AiOrganization/Models/Task.dart';
import 'package:AiOrganization/Redux/Actions/ActivitiesActions.dart';
import 'package:AiOrganization/Redux/Actions/CollectionActions.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivitiesDB {
  CollectionReference _activitiesReference =
      FirebaseFirestore.instance.collection('Activities');

  /// [Create the a document for the created Activity]
  Future<void> createNewActivity(Activity activity) async {
    /// Call all the data of the activity into a simple Map
    Map<String, dynamic> activityFirestore = activity.toMapFirestore();
    activityFirestore['accountUID'] = store.state.account.uid;

    /// Create ActivityDocument and set the init Data
    DocumentReference createdActivityDocument =
        await _activitiesReference.add(activityFirestore);

    /// Create a subDocument contianing all the SubActivities
    CollectionReference _subActivitiesReference = _activitiesReference
        .doc(createdActivityDocument.id)
        .collection('SubActivities');

    activity.subActivities.forEach((subActivity) async {
      await _subActivitiesReference.add(subActivity.toMap());
    });

    /// New State for the collection into the store
    store.dispatch(SetActivityUID(activity, createdActivityDocument.id));
  }

  /// [Insert new SubActivity into the subDocument @SubActivities of the activityDocument on firestore]
  Future<void> addNewSubActivities(
      Activity activity, List<SubActivity> recentAdded) async {
    /// [Checker] ---> Ensure the existance of the Activity into the firestore document:: If it has the [@uid] setted, then exists on firestore
    if (activity.uid != null && activity.uid.trim() != "") {
      /// Call the subDocument contianing all the SubActivities
      CollectionReference _subActivitiesReference =
          _activitiesReference.doc(activity.uid).collection('SubActivities');

      /// Insert all the new tasks into the subDocument SubActivity
      recentAdded.forEach((task) async {
        await _subActivitiesReference.add(task.toMap());
      });
    } else {
      createNewActivity(activity);
    }
  }

  /// [Insert new SubActivities into the subDocument @SubActivities of the activitiyDocument on firestore]
  Future<void> addNewSubActivity(
      Activity activity, SubActivity newSubActivity) async {
    /// [Checker] ---> Ensure the existance of the Activity into the firestore document:: If it has the [@uid] setted, then exists on firestore
    if (activity.uid != null && activity.uid.trim() != "") {
      /// Call the subDocument contianing all the SubActivities
      CollectionReference _subActivitiesReference =
          _activitiesReference.doc(activity.uid).collection('SubActivities');

      /// Insert the new task into the subDocument SubActivity
      await _subActivitiesReference.add(newSubActivity.toMap());
    } else {
      createNewActivity(activity);
    }
  }

  /// [Modify a given SubActivity]
  Future<void> modfiySubActivity(
      Activity activity, SubActivity modifiedSubActivity) async {
    /// Call the subCollection on the firestore so it can access the query
    CollectionReference _subActivitiesReference =
        _activitiesReference.doc(activity.uid).collection('SubActivities');

    /// Query the SubActivity that has id == X
    QuerySnapshot queriedTask = await _subActivitiesReference
        .where("id", isEqualTo: modifiedSubActivity.id)
        .get();

    // Get the UID of SubActivity
    String taskUID = queriedTask.docs.first.id;

    /// Send to server
    await _subActivitiesReference
        .doc(taskUID)
        .update(modifiedSubActivity.toMap());
  }

  /// [Modify Activity]
  Future<void> modfiyActivity(Activity activity) async {
    /// [Checker] ---> Ensure the existance of the Activity into the firestore document:: If it has the [@uid] setted, then exists on firestore
    if (activity.uid != null && activity.uid.trim() != "") {
      await _activitiesReference
          .doc(activity.uid)
          .update(activity.toMapFirestore());
    } else {
      createNewActivity(activity);
    }
  }

  /// [Remove Activity]
  Future<void> removeActivity(Activity activity) async {
    /// [Checker] ---> Ensure the existance of the Collection into the firestore document:: If it has the [@uid] setted, then exists on firestore
    if (activity.uid != null && activity.uid.trim() != "") {
      await _activitiesReference.doc(activity.uid).delete();
    }
  }

  /// [Remove SubActivity]
  Future<void> removeSubActivity(
      Activity activity, SubActivity subActivity) async {
    /// [Checker] ---> Ensure the existance of the Activity into the firestore document:: If it has the [@uid] setted, then exists on firestore
    if (activity.uid != null && activity.uid.trim() != "") {
      /// Call the subCollection on the firestore so it can access the query
      CollectionReference _subActivitiesReference =
          _activitiesReference.doc(activity.uid).collection('SubActivities');

      /// Query the SubActivity that has id == X
      QuerySnapshot queriedTask = await _subActivitiesReference
          .where("id", isEqualTo: subActivity.id)
          .get();

      // Get the UID of SubActivity
      String taskUID = queriedTask.docs.first.id;

      /// Send to server
      await _subActivitiesReference.doc(taskUID).delete();
    }
  }
}
