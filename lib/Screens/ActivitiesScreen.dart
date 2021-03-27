import 'dart:async';

import 'package:AiOrganization/Core/Firebase/ActivitiesListeners/ActivitiesDBListeners.dart';
import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:AiOrganization/Redux/ViewModels/ActivitiesVM.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Widgets/ActivityTabWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Activities extends StatefulWidget {
  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<Widget> activities() {
    List<Widget> widgets = [];
    store.state.activities.forEach((activity) {
      widgets.add(ActivityTabWidget(
        activity: activity,
      ));
      widgets.add(SizedBox(height: 10));
    });

    return widgets;
  }

  Future cleanPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    cleanPref();

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.getProportionateScreenWidth(42), vertical: 42),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("My Activities",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                          color: Colors.deepPurpleAccent[100]))),
              Container(
                  width: 60,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.more_horiz_outlined,
                      color: Colors.deepPurpleAccent[100]))
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: StoreConnector<AppState, ActivitiesVM>(
                converter: (Store<AppState> store) =>
                    ActivitiesVM.create(store),
                builder: (BuildContext context, ActivitiesVM activitiesVM) =>
                    Column(
                  children: activities(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
