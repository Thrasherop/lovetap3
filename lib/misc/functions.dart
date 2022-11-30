import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// logger object
var logger = Logger(
  printer: PrettyPrinter(
      methodCount: 3,
      colors: true
  ),
);

void stamp(Object str){
  /*
    This is a custom print function.

    This implements both the kDebugMode check, and includes the time. Finally,
    it also has the string "stamp" for easy searching.
   */
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

  if (kDebugMode){
    logger.wtf(str);
  }
}