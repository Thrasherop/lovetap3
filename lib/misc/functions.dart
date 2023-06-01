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
    if (kDebugMode) {
     logger.i("stamp: $str");
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

    if (kDebugMode) {
      logger.e(str);
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

    if (kDebugMode){
      logger.wtf(str);
    }
}