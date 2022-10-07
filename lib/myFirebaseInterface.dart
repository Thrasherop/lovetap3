import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:vibration/vibration.dart';

import 'package:lovetap3/config.dart';

class MyFirebaseInterface {

  static Future<void> createBackgroundHandler(RemoteMessage message) async {

    print("background handler called");

    await Firebase.initializeApp();

    _handleData(message);

    print("Data is: ${message.data}");

    print("Handling a background message: ${message.messageId}");

  }

  static void foregroundHandler(RemoteMessage message){
     print("Foreground listener triggered");
     _handleData(message);
     print("Called _handleData");
  }

  static void _handleData(RemoteMessage message) {
    if (message.data.containsKey(Config.DATA_MAP)){
      Vibration.vibrate(duration: int.parse(message.data[Config.DATA_MAP]));
    }
  }

}