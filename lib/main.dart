/// Welcome to Pindery, an amazing party app.
/// Visit [github.com/AEEooTo/pindery/README.md] for more information.
///

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'theme.dart';
import 'home_page/home_page.dart';
import 'first_actions/welcome.dart';

void main() {
  // Overriding https://github.com/flutter/flutter/issues/13736 for better
  // visual effect at the cost of performance.
  MaterialPageRoute.debugEnableFadingRoutes = true; // ignore: deprecated_member_use
  runApp(new Pindery());
  }

class Pindery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: pinderySupportedLocales,
      title: 'Pindery',
      theme: pinderyTheme,
      home: new PinderyHomePage(),
      routes: <String, WidgetBuilder>{
        '/welcome-page': (BuildContext context) => new WelcomePage(),
        //'/home-page': (BuildContext context) => new HomePage(),
      },
    );
  }
}

List<Locale> pinderySupportedLocales = [
  const Locale('en', ''), // English
];
