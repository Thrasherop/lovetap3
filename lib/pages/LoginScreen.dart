
import 'package:flutter/material.dart';
import 'package:lovetap3/interfaces/SettingManager.dart';
import 'package:lovetap3/misc/MyBuffer.dart';
import 'package:lovetap3/mini_widgets/GoogleSignInButton.dart';

import 'package:lovetap3/interfaces/MyAuthenticator.dart';
import 'package:lovetap3/misc/functions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  int _numClicks = 0;

  void demoLogin(){
    stamp("Demo login attempt detected. Processing");

    // Set the setting then switch to homescreen
    SettingManager.updateValue("demoMode", true);

    // Navigator.pushReplacementNamed(context, "/loading");
    Navigator.popAndPushNamed(context, "/loading");
  }

  @override
  Widget build(BuildContext context) {

    // puts a function to handle a press of the sign in button
    // GoogleSignInButton widget shouldn't have functional code like
    // this, but it needs to be able to do this function. Hence,
    // We put it in MyBuffer
    MyBuffer.signinFunction = () async {

        await MyAuthenticator.signInWithGoogle(context: context);

        if (await MyAuthenticator.checkSignedIn()) {
          stamp("User login successful. Redirecting to /");

          // Navigator.pushReplacementNamed(context, "/loading");
          Navigator.popAndPushNamed(context, "/loading");

        } else {
          stamp("User login failed. Doing nothing");
          return;
        }
      };

    /*
      This is the UI scaffold for the LoginScreen
      It also holds the WillPopScope, which prevents
      the user from pushing back and going into an
      invalid state
     */
    return Scaffold(
      body: WillPopScope(
        /*
          WillPopScope prevents the user from using any back button.
          It will also notify the user that they must sign in
         */
        onWillPop: () async {
          stamp("Login abort attempt");
          // notify user that they must login
          final scaffold = ScaffoldMessenger.of(context);
          scaffold.showSnackBar(
              SnackBar(
                content: const Text('You must sign in to use LoveTap'),
              ));
          return false;
        },

      // Actual UI
      child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 80,),
                OutlinedButton(

                  onPressed: (){
                    _numClicks++;
                    if (_numClicks >= 10){
                      demoLogin();
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(width: 5.0, color: Colors.transparent),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30), // Image border
                    child: SizedBox.fromSize(
                      size: Size.fromRadius(100), // Image radius
                      child: Image.asset('assets/logo-foreground.png'),
                    ),
                  ),
                ),
                SizedBox(height: 130,),
                Text("Sign in with google"),
                GoogleSignInButton()
              ],
            ),
          )
        ),
        ),
      );
  }
}
