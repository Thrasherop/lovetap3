import 'package:flutter/material.dart';
import 'package:lovetap3/pages/AddConnectionScreen.dart';
import 'package:lovetap3/pages/ConnectionFailedScreen.dart';
import 'package:lovetap3/pages/ConnectionManagementScreen.dart';
import 'package:lovetap3/pages/HomeScreen.dart';
import 'package:lovetap3/pages/LoadingScreen.dart';
import 'package:lovetap3/pages/LogSubmissionScreen.dart';
import 'package:lovetap3/pages/LoginScreen.dart';
import 'package:lovetap3/pages/SettingsScreen.dart';
import 'package:lovetap3/pages/TestingScreen.dart';


Future<void> main() async {
  /*
    This is the entry point that runs MyApp;
   */

  // This starts the app via routing information
  runApp(MaterialApp(
    initialRoute: "/loading",
    routes: {
      "/loading":(context) =>LoadingScreen(),
      "/home": (context) => HomeScreen(),
      "/connection_failed":(context) => ConnectionFailedScreen(),
      "/login": (context) => LoginScreen(),
      "/testing": (context) => TestingScreen(),
      "/connection_management": (context) => ConnectionManagementScreen(),
      "/settings": (context) => SettingsScreen(),
      "/LogSubmission": (context) => LogSubmissionScreen(),
      "/add_connection": (context) => AddConnectionScreen(),
    },
  ));
}
