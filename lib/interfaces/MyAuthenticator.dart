import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lovetap3/misc/MyBuffer.dart';

import '../misc/functions.dart';

class MyAuthenticator {
  /*
    This class is used to handle logging the user in. Currently only
    supports using Google to authenticate.

    Attributes:
        None

    Methods:
        + checkSignedIn()
        + signOut()
        + signInWithGoogle()
        + customSnackBar()

   */

  static Future<bool> checkSignedIn() async {
    /*
      This method is used to check if the current device is logged
      in via Google. The returned future is a boolean. True if
      logged in, false if not.

      return::
          -- Future<bool> -> Whether the user is signed in

      This method is from the tutorial that is found
      here: https://blog.codemagic.io/firebase-authentication-google-sign-in-using-flutter/
     */

    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // stamp("User.uid: ${user.uid}, token: ${MyBuffer.currentToken}");
      MyBuffer.userID = user.uid;
      return true;
    } else {
      return false;
    }
  }

  static Future<void> signOut({required BuildContext context}) async {
    /*
      Makes the signout call for Google. Calling this will sign the
      user out. You should redirect the user to the login page or
      the /loading route after calling this

      params::
          -- context: BuildContext -> The context of the call

      return::
          -- Future<void> -> this contains no information

      This method is from the tutorial that is found
      here: https://blog.codemagic.io/firebase-authentication-google-sign-in-using-flutter/
     */
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        MyAuthenticator.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {

    /*

      Signs the user in via Google.

      params::
          -- context: BuildContext -> the context where the method is being called

      return::
          -- Future<User?> -> the user IF the sign in was successful

      This method is from the tutorial that is found
      here: https://blog.codemagic.io/firebase-authentication-google-sign-in-using-flutter/
     */

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();


    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
        await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            MyAuthenticator.customSnackBar(
              content:
              'The account already exists with a different credential.',
            ),
          );
        } else if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            MyAuthenticator.customSnackBar(
              content:
              'Error occurred while accessing credentials. Try again.',
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          MyAuthenticator.customSnackBar(
            content: 'Error occurred using Google Sign-In. Try again.',
          ),
        );
      }
    }
    } catch (e) {
      stamp("Error: ");
      stamp(e);
    }

    return user;
  }

  static SnackBar customSnackBar({required String content}) {

    /*
      Creates a snack-bar with the message

      This method is from the tutorial that is found
      here: https://blog.codemagic.io/firebase-authentication-google-sign-in-using-flutter/
     */

    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }
}