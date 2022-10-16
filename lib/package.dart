import 'package:flutter/cupertino.dart';
import 'package:lovetap3/config.dart';
import 'package:vibration/vibration.dart';


class Package {

  // Keeps track of the timing arrays
  @protected
  List<int> timingArray = []; // Array of timings. This is in ms


  @Deprecated("Use the .play() method instead")
  void _chirp(){

    /*
      This merely plays the current _timingArray on the same
      device that made the pattern.
     */

    Vibration.vibrate(pattern: timingArray);
  }
  
  void play(){
    
    /*
      This method plays the current _timingArray on
      this device
     */
    // Vibration.vibrate(duration: 199);
    print(".play() is playing $timingArray");
    Vibration.vibrate(pattern: timingArray);
  }

}