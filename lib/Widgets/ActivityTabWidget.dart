import 'dart:async';

import 'package:AiOrganization/Core/Search.dart';
import 'package:AiOrganization/Models/Activity.dart';
import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Models/SubActivity.dart';
import 'package:AiOrganization/Redux/Actions/ActivitiesActions.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:AiOrganization/Redux/ViewModels/ActivitiesVM.dart';
import 'package:AiOrganization/Screens/SubActivities/SubActivitiesScreen.dart';
import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Styles/TextStylesConstants.dart';
import 'package:AiOrganization/Widgets/CustomAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redux/redux.dart';

class ActivityTabWidget extends StatefulWidget {
  final Activity activity;
  final SubActivity subActivity;

  const ActivityTabWidget({Key key, this.activity, this.subActivity})
      : super(key: key);

  @override
  _ActivityTabWidgetState createState() => _ActivityTabWidgetState();
}

class _ActivityTabWidgetState extends State<ActivityTabWidget> {
  /// Declare a new variable Activity to store the given Activity;
  Activity loadedActivity;

  /// Declare Stopwatch and other useful variables for the timer
  Stopwatch _watch = new Stopwatch();
  Timer timer;
  int stateMilliseconds = 0;
  String durationSinceLastStart = "00:00:00";
  String totalDuration = '00:00:00';

  @override
  void initState() {
    loadedActivity =
        store.state.activities[Search.returnActivityIndex(widget.activity)];

    calculateActivityTotalDuration();
    // TODO: implement initState
    super.initState();
  }

  /// [Calculate the TotalDuration everytime the screen is displayed or everytime the watch is set onRunning]
  void calculateActivityTotalDuration() {
    if (loadedActivity.isRunning) {
      /// Reload the activity to be 100% sure it has the latest data
      loadedActivity =
          store.state.activities[Search.returnActivityIndex(widget.activity)];

      /// Calculate the duration between the currentTime and the time since it was put on [@isRunning = true]
      int secondsPastSinceLastStart = DateTime.now().millisecondsSinceEpoch -
          loadedActivity.dateWhenStarted.millisecondsSinceEpoch;

      /// Merge the current @totalDuration with the new calculated duration since @lastTimeWhenPutOnRunning
      stateMilliseconds =
          secondsPastSinceLastStart + loadedActivity.totalDuration;

      /// Convert into a commonn hour-reading string
      totalDuration = transformMilliSeconds(stateMilliseconds);
    } else {
      /// Load the current @totalDuration of the activity
      stateMilliseconds = loadedActivity.totalDuration;

      /// Convert into a commonn hour-reading string
      totalDuration = transformMilliSeconds(loadedActivity.totalDuration);
    }
  }

  /// [Put the watch on Start]
  void startWatch() {
    /// Put the watch on running
    _watch.start();

    /// Update the state of the screen every 100Mls
    timer = Timer.periodic(Duration(milliseconds: 100), updateTime);
  }

  /// [Update state of the screen in real-time]
  updateTime(Timer timer) {
    /// Calculate the duration and keep updated onScreen
    var timeSoFar = stateMilliseconds + _watch.elapsedMilliseconds;

    /// Update the state of the screen every 100Mls
    if (_watch.isRunning) {
      if (!mounted) return;
      setState(() {
        totalDuration = transformMilliSeconds(timeSoFar);
        durationSinceLastStart =
            transformMilliSeconds(_watch.elapsedMilliseconds);
      });
    }
  }

  /// [Message for deleting activity]
  Future<bool> _warningMessage() async {
    return await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.4),
      barrierLabel: "",
      transitionDuration: Duration(milliseconds: 270),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedValue = Curves.easeOutBack.transform(animation.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, -curvedValue * 200, 0.0),
          child: Opacity(
            opacity: 1,
            child: child,
          ),
        );
      },
      pageBuilder: (BuildContext context, anim1, anim2) => CustomAlertDialog(
        title:
            "Do you really want to delete this task? The action is irreversible",
        actions: [
          CustomAlertDialogButton(
            text: "Yes",
            onTap: () => Navigator.of(context).pop(true),
            textColor: Colors.red,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
          ),
          CustomAlertDialogButton(
            text: "No",
            textColor: ColorsConfig.background,
            backgroudColor: ColorsConfig.primary,
            onTap: () => Navigator.of(context).pop(false),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
        ],
      ),
    );
  }

  /// [Put the watch on Stop]
  void resetWatch() {
    /// Stop Watch
    _watch.stop();
    _watch.reset();
  }

  /// [Convert the @totalDuration in a commong hour-reading string]
  transformMilliSeconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();

    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    ColorsConfig().init(context);

    return Dismissible(
      key: Key(widget.activity.id.toString()),
      onDismissed: (value) =>
          {store.dispatch(RemoveActivityAction(loadedActivity))},
      confirmDismiss: (DismissDirection direction) => _warningMessage(),
      background: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.delete_forever_rounded, color: Colors.white))),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  blurRadius: 6,
                  color: Colors.black.withOpacity(0.05),
                  offset: Offset(0, 5),
                  spreadRadius: 3)
            ]),
        child: Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide.none,
            ),
            clipBehavior: Clip.none,
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              splashColor: Colors.black.withOpacity(0.05),
              highlightColor: Colors.black.withOpacity(0.05),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SubActivitiesScreen(
                            activity: loadedActivity,
                          )),
                );
              },
              child: StoreConnector<AppState, ActivitiesVM>(
                  converter: (Store<AppState> store) =>
                      ActivitiesVM.create(store),
                  builder: (BuildContext context, ActivitiesVM activitiesVM) {
                    // Keep the loadedActivity State and Data 100% updated and stored in the screen
                    loadedActivity = activitiesVM.activities[
                        Search.returnActivityIndex(widget.activity)];

                    /// Understand whether to automatically start the watch or not
                    if (loadedActivity.isRunning && !_watch.isRunning)
                      startWatch();
                    else if (!loadedActivity.isRunning && _watch.isRunning)
                      resetWatch();

                    /// Keep totalDuration data 100% Updated
                    calculateActivityTotalDuration();
                    return Container(
                      margin: EdgeInsets.symmetric(
                          horizontal:
                              SizeConfig.getProportionateScreenWidth(18),
                          vertical:
                              SizeConfig.getProportionateScreenHeight(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (loadedActivity.isRunning)
                                    activitiesVM.stopActivity(loadedActivity);
                                  else {
                                    stateMilliseconds = stateMilliseconds +
                                        _watch.elapsedMilliseconds;
                                    activitiesVM.runActivity(loadedActivity);
                                  }
                                },
                                child: Icon(
                                    (!_watch.isRunning)
                                        ? Icons.play_arrow_rounded
                                        : Icons.pause,
                                    color: ColorsConfig.primary,
                                    size:
                                        SizeConfig.getProportionateScreenWidth(
                                            34)),
                              ),
                              SizedBox(
                                  width: SizeConfig.getProportionateScreenWidth(
                                      10)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width:
                                        SizeConfig.getProportionateScreenWidth(
                                            200),
                                    child: Text(loadedActivity.title,
                                        //"1000 Emails - Promote OpenDocu so everyone can have a simple access to the killer version of the application",
                                        style: taskStyle),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Column(
                                children: [
                                  Text(totalDuration, style: taskStyle),
                                  Text(durationSinceLastStart,
                                      style: taskDetailsStyle),
                                ],
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: ColorsConfig.primary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
            )),
      ),
    );
  }
}
