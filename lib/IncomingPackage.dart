import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:lovetap3/config.dart';
import 'package:lovetap3/package.dart';

class IncomingPackage extends Package {

  @protected
  RemoteMessage _packet;


  IncomingPackage(this._packet) : super(){

    // Gets the pattern and parses it
    String rawPattern = _packet.data[Config.DATA_MAP].toString();
    List<String> patternStr = rawPattern.split(Config.PATTERN_DELIMETER);

    // Converts all the values from String to int
    for (var element in patternStr) {

      if (element == ""){
        continue;
      }

      timingArray.add(int.parse(element));
    }

    print("Created new IncomingPackage");
  }

}