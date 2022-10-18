import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lovetap3/MyAuthenticator.dart';

import '../Config.dart';
import '../functions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // WillPopScope prevents back presses
      body: WillPopScope(
        onWillPop: () async {
          stamp("Back press on home screen detected");
          final scaffold = ScaffoldMessenger.of(context);
          scaffold.showSnackBar(
              SnackBar(
                content: const Text('This is the home screen. To log out, go to settings.'),
                duration: Duration(milliseconds: Config.SNACKBAR_TIMEOUT),
              ));
          return false;
        },

        // Actual UI
        child: SafeArea(
          child: Column(
            children: [
              Text("home screen"),
              TextButton(
                  onPressed: () async {
                    await MyAuthenticator.signOut(context: context);
                    Navigator.pushReplacementNamed(context, "/loading");
                    },
                  child: Text("Sign out"))
            ],
          )
        ),
      )
    );
  }
}



