import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lovetap3/enums/PriorityEnum.dart';
import 'package:lovetap3/objects/IncomingPackage.dart';
import 'package:lovetap3/objects/OutgoingPackage.dart';
import 'package:lovetap3/misc/functions.dart';


import 'package:lovetap3/misc/Config.dart';
import 'package:lovetap3/objects/ConnectionObject.dart';

import '../misc/MyBuffer.dart';
import 'MyFileInterface.dart';

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
          - Create foreground FCM
          - Create listener for a token refresh

       params::
          -- None

       return::
          - status: Future<bool> -> This returns true on success, false on failure
     */


    await Firebase.initializeApp();
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    // This needs to run. Don't know why, but messages might not get delivered if this isn't called
    // TODO: Figure out why this must be called. Foreground messages might not get delivered properly if it isn't
    await FirebaseMessaging.instance.getToken().then((value) {
      MyBuffer.currentToken = value;
      stamp("Token acquired: ${MyBuffer.currentToken}");
      newTokenReceived(MyBuffer.currentToken!);
    });

    // Register listeners
    FirebaseMessaging.onBackgroundMessage(MyFirebaseInterface.backgroundHandler);
    FirebaseMessaging.onMessage.listen(MyFirebaseInterface.foregroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(MyFirebaseInterface.foregroundHandler); // I added this to try and fight the "onMessage" not called bug.
    FirebaseMessaging.instance.onTokenRefresh.listen(MyFirebaseInterface.newTokenReceived);
    stamp("Firebase Messaging listeners initialized");


    return true;

  }

  static void getToken() async {

    /*
      Forces FCM to generate a token.

      params::
        -- None

      return::
        -- void

     */

    stamp("Token request fulfilled: ${await FirebaseMessaging.instance.getToken()}");
  }

  static Future<HttpsCallableResult> sendPackage(OutgoingPackage package) async {
    /*
      This uploads a package to the Firebase database.

      params::
        -- package: OutgoingPackage -> The package to be delivered

      return::
        -- Future<void> -> Contains no information
     */

    // Uploads package
    // final docUser = FirebaseFirestore.instance.collection("incoming").doc(Config.DEMO_USER_NAME).collection(Config.USER_SEND_COLLECTION);
    // await docUser.add(await package.getJson());

    stamp("Sending data: ${await package.getJson()}");

    HttpsCallable callable = FirebaseFunctions.instanceFor(region: "us-central1").httpsCallable("messageDeliverer", options: HttpsCallableOptions(timeout: Duration(seconds: 6)));
    // final result = await callable();
    final result = await callable.call(<String, dynamic>{
      // 'YOUR_PARAMETER_NAME': 'YOUR_PARAMETER_VALUE',
      "data": await package.getJson()
    });

    stamp("Package sent with resulting data being: $result Data: ${result.data}");

    return result;

  }

  static Future<HttpsCallableResult> submitRamLog(String explanation) async {

    stamp("Attempting to submit RAM log...");

    HttpsCallable callable = FirebaseFunctions.instanceFor(region: "us-central1").httpsCallable("submitLog", options: HttpsCallableOptions(timeout: Duration(seconds: 15)));
    final result = await callable.call(<String, dynamic>{
      "log": liveLog, // from functions
      "explanation": explanation,
    });

    stamp("RAM log string has been sent with result ${result.hashCode}");

    return result;
  }

  static Future<Map<String, String>> requestConnection(String targetEmail) async{

    /*
      Requests a connection with an email.

      Takes in a target email and calls the firebase function "requestConnection"
      using it. After the function call succeeds, it will package the relevant
      data and return that as a Map<String, String>.

      params::
        -- String targetEmail: the email of the target user

      return::
        -- Future<Map<String, String>>: Future of the relevant connection data

     */

    stamp("Requesting connection for $targetEmail");

    HttpsCallable callable = FirebaseFunctions.instanceFor(region: "us-central1").httpsCallable("requestConnection", options: HttpsCallableOptions(timeout: Duration(seconds: 10)));
    // final result = await callable();
    final result = await callable.call(<String, dynamic>{
      // 'YOUR_PARAMETER_NAME': 'YOUR_PARAMETER_VALUE',
      "data": {
        "target": targetEmail, //"ultraprim@gmail.com"
      }
    });

    // TODO: check that the request was successful

    stamp("Result: $result");
    stamp("The resulting data from requestConnection: ${result.data}");

    // Get the connectionID, targetUserID, and targetEmail and put it in a map
    Map<String, String> data = {
      "status":"200",
      "connectionID": result.data["data"]["connectionID"],
      // "targetUid": result.data["data"]["targetUid"],
      "targetEmail": result.data["data"]["targetEmail"]
    };

    if (result.data['status'] != 200){
      return {"status":"400"};
    }

    return data;
  }

  static Future<bool> acceptConnection(String connectionID) async {

    /*
      Accepts a connection.

      Takes in a connectionID string to accept. It calls the firebase
      function "acceptConnection" and passes in connectionID

      params::
        -- String connectionID: the connection ID to accept

      return::
        -- Future<bool>: Whether the operation succeeded

     */

    HttpsCallable callable = FirebaseFunctions.instanceFor(region: "us-central1").httpsCallable("acceptConnection", options: HttpsCallableOptions(timeout: Duration(seconds: 10)));
    // final result = await callable();
    final result = await callable.call(<String, dynamic>{
      "data": {
        "connectionID": connectionID,
      }
    });

    return true;
  }

  static void newTokenReceived(String newToken) async{

    /*
      Handler for new token generation.

      This method calls the Firebase function "updateToken", and passes
      in the newToken. Firebase will validate/authenticate and then
      update this user's primary token in the database.

      params::
        -- String newToken: the newly generated token

      return::
        -- None

     */


    stamp("New token received: $newToken");

    HttpsCallable callable = FirebaseFunctions.instanceFor(region: "us-central1").httpsCallable("updateToken", options: HttpsCallableOptions(timeout: Duration(seconds: 10)));
    // final result = await callable();
    final result = await callable.call(<String, dynamic>{
      // 'YOUR_PARAMETER_NAME': 'YOUR_PARAMETER_VALUE',
      "data": {
        "newToken": newToken,
      }
    });

    stamp("Token request update: ${result.data}");

  }

  static Future<void> backgroundHandler(RemoteMessage message) async {

    /*
      The callback function for a background FCM message. This
      requires us to initialize firebase first, and then we call
      _handleData.

      params::
        -- message: RemoteMessage -> Message to be parsed
     */

    await Firebase.initializeApp();

    stamp("Background handler called & Firebase initialized");

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

  static Future<HttpsCallableResult<dynamic>> setPriority(PriorityEnum newPriority) async {

    String newPriorityStr = "";

    if (newPriority == PriorityEnum.LOW){
      newPriorityStr = "normal";
    } else {
      // default to high
      newPriorityStr = "high";
    }

    stamp("Attempting to send priority: $newPriorityStr");

    HttpsCallable callable = FirebaseFunctions.instanceFor(region: "us-central1").httpsCallable("updateInfo", options: HttpsCallableOptions(timeout: Duration(seconds: 6)));
    final result = await callable.call(<String, dynamic>{
      "data": {
        "messagePriority": newPriorityStr,
      }
    });

    stamp("result: ${result.data}");

    return result;
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
      // String targetUser = message.data["senderUid"];

      stamp("Received connection request: $connectionID ");

      ConnectionObject newConnection = ConnectionObject.explicit(connectionID, message.data["senderEmail"], message.data["senderEmail"], false, false);
      MyFileInterface.addConnection(newConnection);

    }
    
    
    else {
      stamp("Incoming package did not have known pattern");
    }

    // attempts to update the screen in case this new data is pertinent
    try {
      stamp("Attempting updateScreenCallback. It is: ${MyBuffer.updateScreenCallback}");
      MyBuffer.updateScreenCallback[0]();
      stamp("updateScreenCallback complete");
    } catch (e){
      stamp("Failed to update screen after receiving notification: ${e.toString()}");
    }

  }

}