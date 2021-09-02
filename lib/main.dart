import 'package:books/screens/home.dart';
import 'package:books/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/app_localization.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  static void setLocal(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocation(locale);
  }
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;
  SharedPreferences pref;
  bool _log=false;
  void setLocation(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }
   @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        pref = value;
        print('==== '+pref.getKeys().toString());
        if (pref.containsKey('id')) _log = true;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.green,
        primaryColorLight: Colors.grey,
        accentColor: Colors.green[100],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      supportedLocales: [
              Locale('ar', 'SA'),
             // Locale('en', 'UK'),
            ],
            locale: _locale,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              // Check if the current device locale is supported
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale.languageCode) {
                  return supportedLocale;
                }
              }
              // If the locale of the device is not supported, use the first one
              // from the list (English, in this case).
              return supportedLocales.first;
            },
      home: _log?
      MyHomePage(ind: 0):Login()
      //Wrapper().handleAuth(),
    );
  }
}