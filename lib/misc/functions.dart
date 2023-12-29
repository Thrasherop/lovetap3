import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// logger object
var logger = Logger(
  printer: PrettyPrinter(
      methodCount: 5,
      colors: true
  ),
);

String liveLog = "";
String debugStr ="💡 !!! --- stamp: \$\$\$ \n\n";

// This is the map of error messages to active bugs
// This is used for log4Bug()
Map<int, String> bugIdDescription = <int, String>{
  1: "Message not sending; long buz\n",
  2: "Background message not bibrating\n",
};

bool doDebug = true;
bool doPrint = true;

void stamp(Object str){
    /*
      This is a custom print function.

      This implements both the kDebugMode check, and includes the time. Finally,
      it also has the string "stamp" for easy searching.
     */


    // Add to RAM log
    String thisLog = debugStr.replaceAll("!!!", DateTime.now().toString()).replaceAll("---", "INFO").replaceAll("\$\$\$", "$str");
    liveLog += thisLog;

    // Add to Firebase Log
    FirebaseCrashlytics.instance.log("stamp: $thisLog");

    // Output if debug is active
    if (doDebug) {
     logger.i("stamp: $str");
    }

    if (doPrint){
      print("Stamp: $str");
    }
}

void stampE(Object str){
    /*
      This is a custom ERROR print function.

      This implements both the kDebugMode check, and includes the time. Finally,
      it also has the string "stamp" for easy searching.

     */

    // Add to RAM log
    String thisLog = debugStr.replaceAll("!!!", DateTime.now().toString()).replaceAll("---", "ERROR").replaceAll("\$\$\$", "$str");
    liveLog += thisLog;

    // Add to Firebase Log
    FirebaseCrashlytics.instance.log("stamp: $thisLog");

    // Output if debug is active

    if (doDebug) {
      logger.e(str);
    }

    if (doPrint){
      print("Stamp ERROR: $str");
    }
}

void stampWTF(Object str){

    /*
      This is a custom WTF print function.

      This implements both the kDebugMode check, and includes the time. Finally,
      it also has the string "stamp" for easy searching.
     */

    // Add to RAM log
    String thisLog = debugStr.replaceAll("!!!", DateTime.now().toString()).replaceAll("---", "WTF").replaceAll("\$\$\$", "$str");
    liveLog += thisLog;

    // Add to Firebase Log
    FirebaseCrashlytics.instance.log("stamp: $thisLog");

    // Output if debug is active

    if (doDebug){
      logger.wtf(str);
    }

    if (doPrint){
      print("StampWTF: $str");
    }
}

void log4Bug(int id, Object str){

  String? thisBugDescOpt = bugIdDescription[id];
  if (thisBugDescOpt == null){
    stampWTF("LOGGING ERROR: log4bug received id $id, but found no corrosponding id in bugIdDescription");
  }

  // Add to RAM log
  String thisLog = debugStr.replaceAll("!!!", DateTime.now().toString()).replaceAll("---", "INFO").replaceAll("\$\$\$", "log4bug $thisBugDescOpt: $str");
  liveLog += thisLog;

  // Add to Firebase Log
  FirebaseCrashlytics.instance.log("log4bug $thisBugDescOpt: $thisLog");

  // Output if debug is active
  // Don't print log4bug to console; it clouds everything up
  // if (kDebugMode) {
  //   logger.i("log4bug $thisBugDescOpt: $str");
  // }
  if (doPrint){
    print("Log4Bug $id -- $thisBugDescOpt: $str");
    logger.i("log4bug $thisBugDescOpt: $str");
  }

}