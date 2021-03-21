import 'package:AiOrganization/Screens/Calendar/CalendarHeader.dart';
import 'package:AiOrganization/Screens/Calendar/CalendarTaskTabs.dart';
import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        CalendarHeader(),
        CalendarTaskTabs(),
      ],
    ));
  }
}
