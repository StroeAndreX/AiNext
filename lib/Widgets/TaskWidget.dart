import 'dart:async';

import 'package:AiOrganization/Core/AppLocalizations.dart';
import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Models/Task.dart';
import 'package:AiOrganization/Redux/Actions/CollectionActions.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:AiOrganization/Redux/ViewModels/CollectionsVM.dart';
import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Styles/TextStylesConstants.dart';
import 'package:AiOrganization/Widgets/CustomAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redux/redux.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class TaskWidget extends StatefulWidget {
  final String taskName;
  final String totalDuration;

  final Collection collection;
  final Task task;

  final PanelController panelController;
  final Function(Task) function;

  TaskWidget(
      {Key key,
      this.taskName,
      this.totalDuration,
      this.task,
      this.collection,
      this.panelController,
      this.function})
      : super(key: key);

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Dismissible(
      onDismissed: (value) => {
        store.dispatch(
            RemoveTaskAction(this.widget.collection, this.widget.task))
      },
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
      key: Key(widget.task.id.toString()),
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
              onTap: () => widget.function(widget.task),
              // () {
              //   widget.panelController.open();
              // },
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.getProportionateScreenWidth(18),
                    vertical: SizeConfig.getProportionateScreenHeight(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        StoreConnector<AppState, CollectionsVM>(
                          converter: (Store<AppState> store) =>
                              CollectionsVM.create(store),
                          builder: (BuildContext context,
                                  CollectionsVM collectionsVM) =>
                              GestureDetector(
                            onTap: () {
                              widget.task.isCompleted
                                  ? collectionsVM.unsetCompleteTask(
                                      widget.collection, widget.task)
                                  : collectionsVM.setCompleteTask(
                                      widget.collection, widget.task);
                            },
                            child: Icon(
                                widget.task.isCompleted
                                    ? Icons.check_circle_outline_rounded
                                    : Icons.check_box_outline_blank_outlined,
                                color: (widget.task.colorLabel ==
                                        Colors.transparent)
                                    ? ColorsConfig.primary
                                    : widget.task.colorLabel,
                                size:
                                    SizeConfig.getProportionateScreenWidth(34)),
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width:
                                  SizeConfig.getProportionateScreenWidth(200),
                              child: Text(widget.taskName, style: taskStyle),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                (widget.task.dateTime != -1 &&
                                        widget.task.dateTime != null)
                                    ? Row(
                                        children: [
                                          Icon(Icons.schedule_rounded,
                                              size: 14,
                                              color:
                                                  ColorsConfig.textFieldBorder),
                                          Text("08:00 - 12:00",
                                              style: taskDetailsStyle),
                                          SizedBox(width: 10),
                                        ],
                                      )
                                    : SizedBox(),
                                Icon(Icons.file_copy_outlined,
                                    size: 14,
                                    color: ColorsConfig.textFieldBorder),
                                Text(
                                    widget.task.notes.length.toString() +
                                        " Notes",
                                    style: taskDetailsStyle),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    Icon(
                      Icons.edit_location_outlined,
                      color: (widget.task.colorLabel == Colors.transparent)
                          ? ColorsConfig.primary
                          : widget.task.colorLabel,
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
