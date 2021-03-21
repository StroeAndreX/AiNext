import 'package:AiOrganization/Core/Search.dart';
import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Models/Task.dart';
import 'package:AiOrganization/Redux/Actions/TaskActions.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Styles/TextStylesConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomizeTaskDate extends StatefulWidget {
  final Task task;
  final Collection collection;
  final Function(bool, double) returnToCustomize;

  const CustomizeTaskDate(
      {Key key, this.task, this.returnToCustomize, this.collection})
      : super(key: key);

  @override
  _CustomizeTaskDateState createState() => _CustomizeTaskDateState();
}

class _CustomizeTaskDateState extends State<CustomizeTaskDate> {
  /// Call a variable that store the loaded Task
  Task loadedTask;
  Collection loadedCollection;

  /// selectDate when clicked
  DateTime selectedDate;

  /// Disable timing
  bool disableDate = false;

  @override
  void initState() {
    loadedTask = widget.task;
    loadedCollection = widget.collection;

    // TODO: implement initState
    super.initState();
  }

  /// [Store the new DateTime for the loadedTask]
  void setDateTime() {
    widget.returnToCustomize(
        false, SizeConfig.getProportionateScreenHeight(600));

    if (!disableDate) {
      //(store.dispatch(CustomizeTaskAction());
      int dateTimeAsInt = selectedDate.millisecondsSinceEpoch;

      /// Dispatch
      store.dispatch(CustomizeTaskDateTimeAction(
          loadedCollection, loadedTask, dateTimeAsInt));
    } else {
      store.dispatch(
          CustomizeTaskDateTimeAction(loadedCollection, loadedTask, -1));
    }
  }

  @override
  Widget build(BuildContext context) {
    loadedCollection = store
        .state.collections[Search.returnCollectionIndex(widget.collection)];
    loadedTask = loadedCollection
        .tasks[Search.returnTaskIndex(loadedCollection, widget.task)];

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: () => widget.returnToCustomize(
                      false, SizeConfig.getProportionateScreenHeight(600)),
                  child: Text("Cancel", style: actionButtonStyle)),
              Text("Select Date", style: messageStyle),
              GestureDetector(
                  onTap: () => setDateTime(),
                  child: Text("Done", style: actionButtonStyle)),
            ],
          ),
          SizedBox(height: SizeConfig.getProportionateScreenHeight(10)),
          Divider(color: Colors.black12),
          SizedBox(height: SizeConfig.getProportionateScreenHeight(10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Disable", style: calendarStyle),
              Switch(
                  value: disableDate,
                  onChanged: (value) {
                    setState(() {
                      disableDate = value;
                    });
                  }),
            ],
          ),
          (!disableDate)
              ? Container(
                  height: SizeConfig.getProportionateScreenHeight(200),
                  child: CupertinoDatePicker(
                    use24hFormat: true,
                    mode: CupertinoDatePickerMode.dateAndTime,
                    onDateTimeChanged: (DateTime value) {
                      setState(() {
                        selectedDate = value;
                      });
                    },
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
