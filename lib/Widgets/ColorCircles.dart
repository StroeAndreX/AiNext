import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Models/Task.dart';
import 'package:AiOrganization/Redux/Actions/TaskActions.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:flutter/material.dart';

class ColorCircle extends StatefulWidget {
  final Color color;
  final bool isSelected;

  final Collection collection;
  final Task task;

  const ColorCircle(
      {Key key, this.color, this.isSelected, this.collection, this.task})
      : super(key: key);

  @override
  _ColorCircleState createState() => _ColorCircleState();
}

class _ColorCircleState extends State<ColorCircle> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        store.dispatch(CustomizeTaskLabelAction(
            widget.collection, widget.task, widget.color, ""))
      },
      child: Container(
        padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(10)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: widget.color,
            border: Border.all(
                color: Colors.black.withOpacity(0.2),
                width: (widget.isSelected) ? 2 : 0)),
      ),
    );
  }
}
