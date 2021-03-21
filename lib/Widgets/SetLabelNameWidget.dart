import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Redux/Actions/TaskActions.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:AiOrganization/Redux/ViewModels/CollectionsVM.dart';
import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class SetLabelNameWidget extends StatefulWidget {
  final Function(String) setLabelName;

  const SetLabelNameWidget({Key key, this.setLabelName}) : super(key: key);

  @override
  _SetLabelNameWidgetState createState() => _SetLabelNameWidgetState();
}

class _SetLabelNameWidgetState extends State<SetLabelNameWidget> {
  TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: SizeConfig.blockSizeVertical < 7 ? 54 : 55,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black38)),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: StoreConnector<AppState, CollectionsVM>(
            converter: (Store<AppState> store) => CollectionsVM.create(store),
            builder: (BuildContext context, CollectionsVM collectionsVM) =>
                Center(
              child: TextField(
                controller: _controller,
                onSubmitted: (value) {
                  widget.setLabelName(value);

                  setState(() {
                    _controller.clear();
                  });
                },
                decoration: InputDecoration(
                  hintText: "LabelName",
                  hintStyle: TextStyle(fontSize: 14.0, color: Colors.black38),
                  border: InputBorder.none,
                  labelStyle: TextStyle(
                      fontSize: 14.0, color: ColorsConfig.primaryText),
                  // icon: Icon(
                  //   Icons.add,
                  //   color: ColorsConfig.primary,
                  // ),
                ),
              ),
            ),
          ),
        ));
  }
}
