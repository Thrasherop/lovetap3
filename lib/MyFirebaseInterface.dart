import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lovetap3/IncomingPackage.dart';
import 'package:lovetap3/OutgoingPackage.dart';
import 'package:lovetap3/functions.dart';


import 'package:lovetap3/Config.dart';

import 'MyBuffer.dart';

class MyFirebaseInterface {
  /*
    This class is for interfacing with Firebase.

    Attributes::
        - _fbApp: Future<FirebaseApp> -> a future containing the FirebaseApp instance

    Methods::
        + initialize()
        + backgroundHandler()
        + foregroundHandler()
        + sendPackage()
        - _handleData()
   */


  static final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  static Future<bool> initialize() async {
    /*
      This method does the required initialization for proper
      firebase usage. This includes:
          - Getting the token
          - Create background FCM listener
          - Create foreground FCM listener

       return::
          - status: Future<bool> -> This returns true on success, false on failure
     */

    try {
      FirebaseMessaging.instance.getToken().then((value) => MyBuffer.currentToken = value);

      FirebaseMessaging.onBackgroundMessage(MyFirebaseInterface.backgroundHandler);
      FirebaseMessaging.onMessage.listen(MyFirebaseInterface.foregroundHandler);
      stamp("Firebase initialized");

      return true;
    } catch (e){
      return false;
    }
  }

  static Future<void> backgroundHandler(RemoteMessage message) async {

    /*
      The callback function for a background FCM message. This
      requires us to initialize firebase first, and then we call
      _handleData.

      params::
        -- message: RemoteMessage -> Message to be parsed
     */

    stamp("background handler called");

    await Firebase.initializeApp();

    _handleData(message);

  }

  static void foregroundHandler(RemoteMessage message){
    /*
      The callback function for a foreground FCM message.
      This currently only passes the data to _handleData();

      params::
        -- message: RemoteMessage -> Message to be parsed
     */
     stamp("Foreground listener triggered");
     _handleData(message);
  }

  static Future<void> sendPackage(OutgoingPackage package) async {
    /*
      This uploads a package to the Firebase database.

      params::
        -- package: OutgoingPackage -> The package to be delivered

      return::
        -- Future<void> -> Contains no information
     */

    stamp("sending Package");

    // Uploads package
    final docUser = FirebaseFirestore.instance.collection("incoming").doc(Config.DEMO_USER_NAME).collection(Config.USER_SEND_COLLECTION);
    await docUser.add(package.getJson());

    stamp("Package sent");

  }

  static void _handleData(RemoteMessage message) {
    /*
      This function parses the message. This includes
      checking if it has data (key defined in Config.DATA_MAP).
      If it does contain the data, it will initialize a new
      IncomingPackage instance with said data. Finally,
      it will play the message.

      params::
         -- message: RemoteMessage -> the data message to parse
     */

    if (message.data.containsKey(Config.DATA_MAP)){

      // Creates IncomingPackage object
      IncomingPackage thisPackage = IncomingPackage(message);
      thisPackage.play();


    } else {
      stamp("Incoming package did not have pattern");
    }

  }

}