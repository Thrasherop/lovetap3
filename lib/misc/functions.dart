import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(
      methodCount: 3,
      colors: true
  ),
);

void stamp(Object str){
  /*
    This is a central print function. This implements both
    the kDebugMode check, and includes the time. Finally,
    it also has the string "stamp" for easy searching
   */
 if (kDebugMode) {
     // print("stamp @ ${DateTime.now()}: $str");
     // log("test");
   logger.i("$str");

  };
}

void stampE(Object str){
  if (kDebugMode) {
    logger.e(str);
  }
}

void stampWTF(Object str){
  if (kDebugMode){
    logger.wtf(str);
  }
}