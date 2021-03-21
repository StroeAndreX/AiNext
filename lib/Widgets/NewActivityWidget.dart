import 'package:AiOrganization/Models/Activity.dart';
import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Models/Task.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:AiOrganization/Redux/ViewModels/ActivitiesVM.dart';
import 'package:AiOrganization/Screens/CollectionTasks/CollectionTasksScreen.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class NewActivityWidget extends StatefulWidget {
  bool isActivity;
  Activity activity;

  NewActivityWidget({this.isActivity = true, this.activity});
  @override
  _NewActivityWidgetState createState() => _NewActivityWidgetState();
}

class _NewActivityWidgetState extends State<NewActivityWidget> {
  TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ActivitiesVM>(
      converter: (Store<AppState> store) => ActivitiesVM.create(store),
      builder: (BuildContext context, ActivitiesVM activitiesVM) =>
          GestureDetector(
              child: Container(
        height: SizeConfig.blockSizeVertical < 7 ? 54 : 60,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ColorsConfig.textFieldBorder)),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: TextField(
              controller: _controller,
              onSubmitted: (value) {
                if (widget.isActivity) {
                  activitiesVM.newActivity(value);
                } else {
                  activitiesVM.newSubActivity(widget.activity, value);
                }

                setState(() {
                  value = "";
                  _controller.clear();
                });
              },
              decoration: InputDecoration(
                hintText: "New Activity",
                hintStyle: TextStyle(fontSize: 14.0, color: Colors.black54),
                border: InputBorder.none,
                labelStyle:
                    TextStyle(fontSize: 14.0, color: ColorsConfig.primaryText),
                icon: Icon(
                  Icons.add,
                  color: ColorsConfig.primary,
                ),
              ),
            ),
          ),
        ),
      )),
    );
  }
}
