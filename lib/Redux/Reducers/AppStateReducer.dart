import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Redux/Reducers/AccountReducers.dart';
import 'package:AiOrganization/Redux/Reducers/ActivitiesReducers.dart';
import 'package:AiOrganization/Redux/Reducers/CollectionsReducers.dart';

AppState appStateReducer(AppState state, action) {
  return AppState(
      activities: activitiesReducers(state.activities, action),
      collections: collectionsReducers(state.collections, action),
      account: accountReducers(state.account, action));
}
