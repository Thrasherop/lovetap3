import 'package:flutter/foundation.dart';

void stamp(String str){
  /*
    This is a central print function. This implements both
    the kDebugMode check, and includes the time. Finally,
    it also has the string "stamp" for easy searching
   */
 if (kDebugMode) {
     print("stamp @ ${DateTime.now()}: $str");
  };
}