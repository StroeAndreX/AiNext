import 'package:AiOrganization/Models/Activity.dart';
import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Models/SubActivity.dart';
import 'package:AiOrganization/Redux/Actions/ActivitiesActions.dart';
import 'package:redux/redux.dart';

class ActivitiesVM {
  final List<Activity> activities;
  final Function(String) newActivity;
  final Function(Activity, String) newSubActivity;
  final Function(Activity) runActivity;
  final Function(Activity) stopActivity;
  final Function(SubActivity, Activity) runSubActivity;
  final Function(SubActivity, Activity) stopSubActivity;

  ActivitiesVM(
      {this.activities,
      this.newActivity,
      this.newSubActivity,
      this.runActivity,
      this.stopActivity,
      this.runSubActivity,
      this.stopSubActivity});

  factory ActivitiesVM.create(Store<AppState> store) {
    _addNewActivity(String taskName) {
      store.dispatch(NewActivityAction(taskName));
    }

    _addNewSubActivity(Activity activity, String subActivityName) {
      store.dispatch(AddSubActivityAction(activity, subActivityName));
    }

    _runActivity(Activity activity) {
      store.dispatch(RunActivityAction(activity));
    }

    _stopActivity(Activity activity) {
      store.dispatch(StopActivityAction(activity));
    }

    _runSubActivity(SubActivity subActivity, Activity activity) {
      store.dispatch(RunSubActivityAction(subActivity, activity));
    }

    _stopSubActivity(SubActivity subActivity, Activity activity) {
      store.dispatch(StopSubActivityAction(subActivity, activity));
    }

    return ActivitiesVM(
        activities: store.state.activities,
        newActivity: _addNewActivity,
        newSubActivity: _addNewSubActivity,
        runActivity: _runActivity,
        stopActivity: _stopActivity,
        stopSubActivity: _stopSubActivity,
        runSubActivity: _runSubActivity);
  }
}
