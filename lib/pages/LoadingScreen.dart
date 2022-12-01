import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lovetap3/interfaces/MyAuthenticator.dart';

import '../interfaces/MyFirebaseInterface.dart';
import 'package:lovetap3/misc/functions.dart';

import '../misc/Settings.dart';


/*
  This screen is used as a temporary display, and makes app
  initialization calls for MyFirebaseInterface. Additionally,
  it figures out whether to send the user to /login or /home.

  This widget is designed to be used as the initial route of the
  application.
 */


class LoadingScreen extends StatefulWidget {

  LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  // Gets futures started
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();


  void _initialize() async{
    /*
      This function initializes MyFirebaseInterface and checks if
      the user is logged in. If the user is not logged in, the login
      screen is pushed onto the navigator. If the user IS logged in,
      the screen is replaced with /home.

      For now, I've fixed this by just delaying the loading screen _initialize
      daemon by 300 ms instead of the 100ms before. this also shows a loading
      screen for a second, which is nice and makes it feel super fast
     */


    // Initialize MyFirebaseInterface
    await MyFirebaseInterface.initialize();
    stamp("Loading screen: Firebase initialized");


    // Goes to home if logged in, goes to /login if not
    bool signedIn = await MyAuthenticator.checkSignedIn();
    if (signedIn){
      // Initializes Settings first
      await Settings.initialize();
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      stamp("User not logged in; sending them to /login");
      Navigator.pushNamed(context, "/login");
    }
  }



  @override
  Widget build(BuildContext context) {


    // This calls _initilize with a 100ms delay. This delay
    // ensures that the UI below has a chance to render.
    // This is important since initialization can take a moment
    Future.delayed(Duration(milliseconds: 300), _initialize);


    // This is the LoadingScreen UI
    return Scaffold(

      /*
        TODO:
          Style this loading screen
       */

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Loading..."),
            CircularProgressIndicator()
          ],
        ),
      )
    );
  }
}
