import 'dart:io';

import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:AiOrganization/Screens/Activities/ActivitiesScreen.dart';
import 'package:AiOrganization/Screens/ActivitiesScreen.dart';
import 'package:AiOrganization/Screens/Calendar/CalendarScreen.dart';
import 'package:AiOrganization/Screens/Collections/CollectionsScreen.dart';
import 'package:AiOrganization/Screens/HomePage/HomePageScreen.dart';
import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/VoiceAssistant/VoiceTT.dart';
import 'package:AiOrganization/Widgets/BottomNavBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class InitScreen extends StatefulWidget {
  //final bool fromAuth;
  final List<NavigationItem> navItems = [
    NavigationItem(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      title: "Home",
    ),
    NavigationItem(
      icon: Icons.file_copy_outlined,
      selectedIcon: Icons.file_copy_rounded,
      title: "Collections",
    ),
    NavigationItem(
      icon: Icons.timer_outlined,
      selectedIcon: Icons.timer_rounded,
      title: "Activities",
    ),
    NavigationItem(
      icon: Icons.calendar_today_outlined,
      selectedIcon: Icons.calendar_today_rounded,
      title: "Calendar",
    ),
  ];
  @override
  _InitScreenState createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  int _currentScreen = 0;
  BottomNavBar bottomNavBar;

  //BottomNavBar Controller [Screens]
  Widget _getCurrentScreen() {
    switch (_currentScreen) {
      case 0:
        return SingleChildScrollView(child: HomePageScreen());
        break;
      case 1:
        return SingleChildScrollView(child: CollectionsScreen());
        break;
      case 2:
        return SingleChildScrollView(child: ActivitiesScreen());
        break;
      case 3:
        return CalendarScreen(); //MyHomePage(title: "Liz");
        break;

      default:
        return Center(child: Text("Something went wrong!"));
        break;
    }
  }

  void _onIndexChanged(index) {
    setState(() {
      _currentScreen = index;
    });
  }

  @override
  void initState() {
    bottomNavBar = BottomNavBar(
      items: widget.navItems,
      onIndexChanged: (index) => _onIndexChanged(index),
    );

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    ColorsConfig().init(context);

    return StoreConnector<AppState, dynamic>(
      converter: (Store<AppState> store) => null,
      builder: (BuildContext context, dynamic dyn) => Scaffold(
          resizeToAvoidBottomInset: true,
          bottomNavigationBar: bottomNavBar,
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Stack(
              children: [
                _getCurrentScreen(),
              ],
            ),
          )),
    );
  }
}
