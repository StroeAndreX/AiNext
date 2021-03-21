import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Models/Task.dart';
import 'package:AiOrganization/Redux/Actions/CollectionActions.dart';
import 'package:AiOrganization/Redux/Actions/TaskActions.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:flutter/material.dart';

class IconCircle extends StatefulWidget {
  final IconData icon;
  final bool isSelected;

  final Collection collection;
  final Task task;

  const IconCircle(
      {Key key, this.icon, this.isSelected, this.collection, this.task})
      : super(key: key);

  @override
  _ColorCircleState createState() => _ColorCircleState();
}

class _ColorCircleState extends State<IconCircle> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        store.dispatch(
            CustomizeCollectionIconAction(widget.collection, widget.icon))

        // store.dispatch(CustomizeTaskLabelAction(
        // widget.collection, widget.task, widget.color, ""))
      },
      child: Container(
          padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(10)),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: (widget.isSelected)
                  ? ColorsConfig.primaryLight
                  : Colors.black12,
              border: Border.all(
                  color: Colors.black.withOpacity(0.2),
                  width: (widget.isSelected) ? 2 : 0)),
          child: Center(
              child: Icon(widget.icon,
                  color: (widget.isSelected)
                      ? ColorsConfig.primary
                      : Colors.black))),
    );
  }
}
