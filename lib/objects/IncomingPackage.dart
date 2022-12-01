import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:lovetap3/misc/Config.dart';
import 'package:lovetap3/objects/Package.dart';

import '../misc/functions.dart';

class IncomingPackage extends Package {
  /*
    This class is for representing incoming
    packages of vibrations. It inherits from Package
    and adds the following functions

    Attributes::
        # _packet -> this is the RemoteMessage packet that coems from Firebase

     Methods::
        -- IncomingPackage() -> default constructor
   */

  @protected
  RemoteMessage _packet;


  IncomingPackage(this._packet) : super(){

    /*
      Default constructor. Takes in a RemoteMessage packet
      and parses it as an incoming package that will be able
      to be played on the local device.

      params::
          -- _packet: RemoteMessage -> the incoming packet
     */

    // Gets the pattern and parses it
    String rawPattern = _packet.data[Config.PACKAGE_DATA_MAP].toString();
    List<String> patternStr = rawPattern.split(Config.PATTERN_DELIMETER);

    // Converts all the values from String to int
    for (var element in patternStr) {
      if (element == ""){
        continue;
      }
      timingArray.add(int.parse(element));
    }

    stamp("Created new IncomingPackage");
  }

}