import 'package:AiOrganization/Core/Search.dart';
import 'package:AiOrganization/Models/Activity.dart';
import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Models/SubActivity.dart';
import 'package:AiOrganization/Models/Task.dart';
import 'package:AiOrganization/Redux/Actions/ActivitiesActions.dart';
import 'package:AiOrganization/Redux/Actions/CollectionActions.dart';
import 'package:AiOrganization/Redux/Actions/TaskActions.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivitiesDBListeners {
  CollectionReference _activitiesReference =
      FirebaseFirestore.instance.collection('Activities');

  /// [Read in-real-time all the activities]
  Future<void> listenToActivities() {
    Query _listenToUserActivities = _activitiesReference.where('accountUID',
        isEqualTo: store.state.account.uid);

    _listenToUserActivities.snapshots().listen((activities) {
      int allActivitiesLength = activities.docs.length;
      int allActivitiesChangesLength = activities.docChanges.length;

      print("Activities: " + activities.docs.length.toString());
      print(activities.toString());

      if (allActivitiesChangesLength > allActivitiesLength) {
        Map<String, dynamic> removedActivityData =
            activities.docChanges.first.doc.data();

        Activity altActivity = Activity.fromMap(removedActivityData, []);
        altActivity.copyWith(uid: activities.docChanges.first.doc.id);

        print("Remove this...");
        store.dispatch(RemoveActivityLocallyAction(altActivity));
      }

      if (activities.docs.isEmpty) return;

      int activityExist = -1;
      activities.docs.forEach((activity) {
        Activity newActivity = Activity.fromMap(activity.data(), []);
        newActivity = newActivity.copyWith(uid: activity.id);

        /// Check if the activity is already in the list
        activityExist = store.state.activities
            .indexWhere((activity) => activity.id == newActivity.id);

        /// Insert new activity
        if (activityExist == -1) {
          store.dispatch(InsertActivityAction(newActivity));
        } else {
          Activity activity = store.state.activities.elementAt(activityExist);

          newActivity =
              newActivity.copyWith(subActivities: activity.subActivities);
          print("Activities: " + newActivity.toString());
          store.dispatch(ModifyActivityAction(newActivity));
        }
      });
    });
  }

  /// [Read in-real-time all the subActivities of the activity]
  Future<void> listenToSubActivtiesActivity(Activity activity) {
    Query _listenToUserSubActivities =
        _activitiesReference.doc(activity.uid).collection('SubActivities');

    Activity updatedActivity =
        store.state.activities[Search.returnActivityIndex(activity)];

    _listenToUserSubActivities.snapshots().listen((subActivities) {
      updatedActivity =
          store.state.activities[Search.returnActivityIndex(activity)];

      bool found = false;
      subActivities.docChanges.forEach((docChanged) {
        subActivities.docs.forEach((doc) {
          if (doc.data()['id'] == docChanged.doc.data()['id']) {
            found = true;
            return;
          }
        });
      });

      if (!found) {
        Map<String, dynamic> removedSubActivityData =
            subActivities.docChanges.first.doc.data();

        SubActivity altSubActivity =
            SubActivity.fromMap(removedSubActivityData);

        store.dispatch(
            RemoveSubActivityLocallyAction(updatedActivity, altSubActivity));
      }

      if (subActivities.docs.isEmpty) return;

      int subActivityExist = -1;
      subActivities.docs.forEach((subActivity) {
        SubActivity newSubActivity = SubActivity.fromMap(subActivity.data());
        //newSubActivity = newSubActivity.copyWith(uid: activity.id);

        /// Check if the activity is already in the list
        subActivityExist = updatedActivity.subActivities.indexWhere(
            (subActivityList) => newSubActivity.id == subActivityList.id);

        /// Insert new activity
        if (subActivityExist == -1) {
          store.dispatch(
              InsertSubActivityAction(updatedActivity, newSubActivity));
        } else {
          store.dispatch(
              ModifySubActivityAction(updatedActivity, newSubActivity));
        }
      });
    });
  }
}
