import 'dart:async';

import 'package:AiOrganization/Core/Firebase/ActivitiesListeners/ActivitiesDBListeners.dart';
import 'package:AiOrganization/Core/Search.dart';
import 'package:AiOrganization/Models/Activity.dart';
import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:AiOrganization/Redux/ViewModels/ActivitiesVM.dart';
import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Styles/TextStylesConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class SubActivitiesHeader extends StatefulWidget {
  final Activity activity;

  const SubActivitiesHeader({Key key, this.activity}) : super(key: key);

  @override
  _SubActivitiesHeaderState createState() => _SubActivitiesHeaderState();
}

class _SubActivitiesHeaderState extends State<SubActivitiesHeader> {
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

    if (store.state.account.isPremium)
      ActivitiesDBListeners().listenToSubActivtiesActivity(loadedActivity);

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

  /// [Put the watch on Start]ù
  void startWatch() {
    _watch.start();
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

  /// [Put the watch on Stop]
  void resetWatch() {
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
    return Container(
        height: SizeConfig.getProportionateScreenHeight(100),
        child: Stack(
          children: [
            Image.asset("assets/pictures/BigSur.png",
                width: SizeConfig.screenWidth, fit: BoxFit.fitWidth),
            Container(
                height: SizeConfig.getProportionateScreenHeight(145),
                color: ColorsConfig.primary.withOpacity(.5)),
            Container(
              height: SizeConfig.getProportionateScreenHeight(100),
              margin: EdgeInsets.only(
                  left: SizeConfig.getProportionateScreenWidth(10),
                  right: SizeConfig.getProportionateScreenWidth(30),
                  top: SizeConfig.getProportionateScreenHeight(30)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                      ),
                      Text("Activities", style: leadingStyle)
                    ],
                  ),
                  StoreConnector<AppState, ActivitiesVM>(
                      converter: (Store<AppState> store) =>
                          ActivitiesVM.create(store),
                      builder:
                          (BuildContext context, ActivitiesVM activitiesVM) {
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

                        return Row(
                          children: [
                            Text(totalDuration, style: leadingStyle),
                            GestureDetector(
                              onTap: () {
                                if (loadedActivity.isRunning)
                                  activitiesVM.stopActivity(loadedActivity);
                                //startWatch();
                                else {
                                  stateMilliseconds = stateMilliseconds +
                                      _watch.elapsedMilliseconds;
                                  activitiesVM.runActivity(loadedActivity);

                                  //resetWatch();
                                }
                              },
                              child: Icon(
                                  (!loadedActivity.isRunning)
                                      ? Icons.play_arrow_rounded
                                      : Icons.pause,
                                  color: Colors.white,
                                  size: SizeConfig.getProportionateScreenWidth(
                                      34)),
                            )
                          ],
                        );
                      }),
                ],
              ),
            )
          ],
        ));
  }
}
