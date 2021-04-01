import 'package:AiOrganization/Models/Task.dart';
import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Styles/TextStylesConstants.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class CustomizeTaskDateButton extends StatefulWidget {
  final Task task;
  final Function(bool, double) setSelectDate;

  const CustomizeTaskDateButton({Key key, this.task, this.setSelectDate})
      : super(key: key);

  @override
  _CustomizeTaskDateButtonState createState() =>
      _CustomizeTaskDateButtonState();
}

class _CustomizeTaskDateButtonState extends State<CustomizeTaskDateButton> {
  /// Call a variable that store the given task -- needed in case of update
  Task loadedTask;

  @override
  void initState() {
    loadedTask = widget.task;

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loadedTask = widget.task;

    return Container(
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.getProportionateScreenHeight(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Time", style: messageStyle),
          GestureDetector(
            onTap: () => widget.setSelectDate(
                true, SizeConfig.getProportionateScreenHeight(375)),
            child: Row(
              children: [
                Text(
                    loadedTask.dateTime == -1
                        ? "No date setted"
                        : DateFormat('yyyy/MM/dd kk:mm').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                loadedTask.dateTime)),
                    style: taskStyle),
                Icon(Icons.arrow_forward_ios_rounded,
                    color: ColorsConfig.primary,
                    size: SizeConfig.getProportionateScreenHeight(18)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
