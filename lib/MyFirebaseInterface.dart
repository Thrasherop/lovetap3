import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lovetap3/IncomingPackage.dart';
import 'package:lovetap3/OutgoingPackage.dart';
import 'package:lovetap3/functions.dart';


import 'package:lovetap3/Config.dart';
import 'package:lovetap3/objects/ConnectionObject.dart';

import 'MyBuffer.dart';
import 'interfaces/MyFileInterface.dart';

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
      // This needs to run. Don't know why, but messages might not get delivered if this isn't called
      // TODO: Figure out why this must be called. Foreground messages might not get delivered properly if it isn't
      FirebaseMessaging.instance.getToken().then((value) {
        MyBuffer.currentToken = value;
        stamp("Token acquired: ${MyBuffer.currentToken}");
      });

      FirebaseMessaging.onBackgroundMessage(MyFirebaseInterface.backgroundHandler);
      FirebaseMessaging.onMessage.listen(MyFirebaseInterface.foregroundHandler);
      stamp("Firebase Messaging listeners initialized");

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

  static void foregroundHandler(RemoteMessage message) async{
    /*
      The callback function for a foreground FCM message.
      This currently only passes the data to _handleData();

      params::
        -- message: RemoteMessage -> Message to be parsed
     */
     stamp("Foreground listener triggered");
     await Firebase.initializeApp();
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

  static Future<bool> requestConnection(String targetEmail) async{

    stamp("Requesting connection for $targetEmail");

    HttpsCallable callable = FirebaseFunctions.instanceFor(region: "us-central1").httpsCallable("requestConnection", options: HttpsCallableOptions(timeout: Duration(seconds: 5)));
    // final result = await callable();
    final result = await callable.call(<String, dynamic>{
      // 'YOUR_PARAMETER_NAME': 'YOUR_PARAMETER_VALUE',
      "data": {
        "target": "ultraprim@gmail.com"
      }
    });

    stamp("Result: $result");
    stamp("data: ${result.data}");

    if (result.data['status'] != 200){
      return false;
    }

    return true;
  }

  static void _handleData(RemoteMessage message) {
    /*
      This function parses the message. This includes
      checking if it has data (key defined in Config.DATA_MAP).
      If it does contain the data, it will handle that data.

      This data may be:
       - an incoming package (in which case it will play that package)
       - a new connection request (in which case it will add that to the database)


      params::
         -- message: RemoteMessage -> the data message to parse
     */

    if (message.data.containsKey(Config.PACKAGE_DATA_MAP)){

      // Creates IncomingPackage object
      IncomingPackage thisPackage = IncomingPackage(message);
      thisPackage.play();


    } else if (message.data.containsKey("connectionID")){
      // connection request code
      stamp("connection request received");


      // Parse the data
      String connectionID = message.data["connectionID"];
      String targetUser = message.data["senderUid"];

      stamp("Received connection request: $connectionID $targetUser");

      ConnectionObject newConnection = ConnectionObject.explicit(connectionID, targetUser, message.data["senderEmail"] ,false);
      MyFileInterface.addConnection(newConnection);


    }
    
    
    else {
      stamp("Incoming package did not have known pattern");
    }

  }



}