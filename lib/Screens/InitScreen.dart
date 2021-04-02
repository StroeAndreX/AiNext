import 'dart:convert';
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
import 'package:AiOrganization/VoiceAssistant/TextToSpeechAPI.dart';
import 'package:AiOrganization/VoiceAssistant/Voice.dart';
import 'package:AiOrganization/VoiceAssistant/VoiceTT.dart';
import 'package:AiOrganization/Widgets/BottomNavBar.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:path_provider/path_provider.dart';
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

    // getVoices().then((value) =>
    //     synthesizeText("Hi, I'm LiZ... your personal assistant!", ''));

    // TODO: implement initState
    super.initState();
  }

  //
  /// Initialized the LIZ Phase4: LZN0 - Only precreated messages as it's very [Dangerous] to leat user mess with her --> Could cost a lot of money
  //

  ///
  /// [LiZ Implementation] --> TODO: Ultra Optimization using In-App checking and avoiding useless writings or readings || Letting the user mess with LiZ || Phase 6 of AiOrganziation [The Ultra optimization]
  ///

  List<Voice> _voices = [];
  Voice _selectedVoice;
  AudioCache audioCache = AudioCache();
  AudioPlayer audioPlugin = AudioPlayer();

  Future<void> synthesizeText(String text, String name) async {
    print("Text: " + text);
    if (audioPlugin.state == AudioPlayerState.PLAYING) {
      await audioPlugin.stop();
    }
    final String audioContent = await TextToSpeechAPI().synthesizeText(
        text, _selectedVoice.name, _selectedVoice.languageCodes.first);
    if (audioContent == null) return;
    final bytes = Base64Decoder().convert(audioContent, 0, audioContent.length);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/wavenet.mp3');
    await file.writeAsBytes(bytes);
    await audioPlugin.play(file.path, isLocal: true);
  }

  Future<void> getVoices() async {
    final voices = await TextToSpeechAPI().getVoices();
    if (voices == null) return;
    setState(() {
      _selectedVoice = voices.firstWhere(
          (e) =>
              e.name == 'en-US-Wavenet-F' && e.languageCodes.first == 'en-US',
          orElse: () => Voice('en-US-Wavenet-F', 'FEMALE', ['en-US']));
      _voices = voices;
    });
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
