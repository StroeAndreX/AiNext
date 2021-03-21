import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Redux/Middleware/ActivitiesMiddleware.dart';
import 'package:AiOrganization/Redux/Reducers/AppStateReducer.dart';
import 'package:redux/redux.dart';

//import 'package:redux_dev_tools/redux_dev_tools.dart';

final Store<AppState> store = Store<AppState>(
  appStateReducer,
  initialState: AppState.initialState(),
  middleware: appStateMiddleware(),
);
