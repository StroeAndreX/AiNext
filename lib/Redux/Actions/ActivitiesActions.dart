import 'package:AiOrganization/Models/Activity.dart';
import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Models/SubActivity.dart';

class NewActivityAction {
  String activityName;

  NewActivityAction(this.activityName);
}

class AddSubActivityAction {
  final Activity activity;
  final String subActivityName;

  AddSubActivityAction(this.activity, this.subActivityName);
}

class CustomizeActivityAction {
  final Activity activity;
  final String newActivityName;

  CustomizeActivityAction(this.activity, {this.newActivityName});
}

class RunActivityAction {
  final Activity activity;

  RunActivityAction(this.activity);
}

class StopActivityAction {
  final Activity activity;

  StopActivityAction(this.activity);
}

class RunSubActivityAction {
  final Activity activity;
  final SubActivity subActivity;

  RunSubActivityAction(this.subActivity, this.activity);
}

class StopSubActivityAction {
  final Activity activity;
  final SubActivity subActivity;

  StopSubActivityAction(this.subActivity, this.activity);
}

class RemoveActivityAction {
  final Activity activity;

  RemoveActivityAction(this.activity);
}

class RemoveSubActivityAction {
  final Activity activity;
  final SubActivity subActivity;

  RemoveSubActivityAction(this.activity, this.subActivity);
}

class GetActivitiesAction {}

class GetItemsAction {}
