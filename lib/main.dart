import 'dart:io'; // This is for sleep
import 'dart:math';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lovetap3/pages/ConnectionFailedScreen.dart';
import 'package:lovetap3/pages/ConnectionManagementScreen.dart';
import 'package:lovetap3/pages/HomeScreen.dart';
import 'package:lovetap3/pages/LoadingScreen.dart';
import 'package:lovetap3/pages/LoginScreen.dart';
import 'package:lovetap3/pages/TestingScreen.dart';

import 'package:vibration/vibration.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_api_availability/google_api_availability.dart';

import 'package:lovetap3/misc/Config.dart';
import 'package:lovetap3/objects/Package.dart';
import 'package:lovetap3/objects/IncomingPackage.dart';
import 'package:lovetap3/objects/OutgoingPackage.dart';
import 'package:lovetap3/interfaces/MyFirebaseInterface.dart';
import 'package:lovetap3/misc/MyBuffer.dart';
import 'package:lovetap3/interfaces/MyAuthenticator.dart';

import 'misc/functions.dart';

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
    },
  ));
}
