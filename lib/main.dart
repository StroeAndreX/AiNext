import 'package:AiOrganization/Core/AppLocalizations.dart';
import 'package:AiOrganization/Core/LanguageConstants.dart';
import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Redux/Actions/ActivitiesActions.dart';
import 'package:AiOrganization/Screens/ActivitiesScreen.dart';
import 'package:AiOrganization/Screens/InitScreen.dart';
import 'package:AiOrganization/VoiceAssistant/VoiceTT.dart';
import 'package:AiOrganization/Widgets/NewActivityWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:redux/redux.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Redux/Store.dart';

FirebaseAnalytics analytics;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Analytics
  analytics = FirebaseAnalytics();
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// Firebase Init
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  bool isThemeDark = false;
  // Dynamic languages
  Locale _locale;
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  //
  /// Huge challenge and test in firebase listeners and management [Dangerous] --> Could cost a lot of money
  //

  ///
  /// [Firestore implementation management] --> TODO: Ultra Optimization using In-App checking and avoiding useless writings or readings || Phase 6 of AiOrganziation [The Ultra optimization]
  ///

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            print("is Error");
            return Scaffold();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return StoreProvider<AppState>(
              store: store,
              child: MaterialApp(
                locale: _locale,
                debugShowCheckedModeBanner: false,
                supportedLocales: [
                  Locale('it', 'IT'),
                  Locale('en', 'EN'),
                ],
                localizationsDelegates: [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                localeResolutionCallback:
                    (Locale locale, Iterable<Locale> supportedLocales) {
                  if (locale == null) {
                    debugPrint("*language locale is null!!!");
                    return supportedLocales.last;
                  }

                  for (Locale supportedLocale in supportedLocales) {
                    if (supportedLocale.languageCode == locale.languageCode ||
                        supportedLocale.countryCode == locale.countryCode) {
                      return supportedLocale;
                    }
                  }

                  return supportedLocales.first;
                },
                navigatorObservers: [
                  FirebaseAnalyticsObserver(analytics: analytics)
                ],
                theme: ThemeData(dividerColor: Colors.transparent),
                home: StoreBuilder<AppState>(
                  onInit: (store) async {
                    await store.dispatch(GetItemsAction());
                  },
                  builder: (BuildContext context, Store<AppState> store) {
                    return InitScreen();
                  },
                ),
              ),
            );
          }
          return MaterialApp(
              home:
                  Scaffold(body: Center(child: Text("Waiting for firebase"))));
        });
  }
}
