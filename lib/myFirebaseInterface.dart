import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lovetap3/incomingPackage.dart';
import 'package:lovetap3/outgoingPackage.dart';
import 'package:lovetap3/package.dart';

import 'package:vibration/vibration.dart';

import 'package:lovetap3/config.dart';

class MyFirebaseInterface {

  static Future<void> createBackgroundHandler(RemoteMessage message) async {

    print("background handler called");

    await Firebase.initializeApp();

    _handleData(message);

  }

  static void foregroundHandler(RemoteMessage message){
     print("Foreground listener triggered");
     _handleData(message);
     print("Called _handleData");
  }

  static void _handleData(RemoteMessage message) {



    if (message.data.containsKey(Config.DATA_MAP)){

      // Creates IncomingPackage object
      IncomingPackage thisPackage = IncomingPackage(message);
      thisPackage.play();


    } else {
      print("Incoming package did not have pattern");
    }

    // if (message.data.containsKey(Config.DATA_MAP)){
    //   Vibration.vibrate(duration: int.parse(message.data[Config.DATA_MAP]));
    // }
  }

  static Future<void> sendPackage(OutgoingPackage package) async {

    print("sending Package");

    final docUser = FirebaseFirestore.instance.collection("incoming").doc(Config.DEMO_USER_NAME).collection(Config.USER_SEND_COLLECTION);

    await docUser.add(package.getJson()); //set(package.getJson());

    print("Package sent");

  }

}