import 'package:flutter/cupertino.dart';
import 'package:lovetap3/Config.dart';
import 'package:vibration/vibration.dart';


class Package {
  /*
    This is the base class for a Package. A Package is
    an object that contains a timingArray. This can be
    inherited from to create a specific type of Package.

    Arributes::
        # timingArray

    Methods::
        - chirp() (@DEPRECATED)
        + play()
   */

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
      this device. This is done by passing the timingArray
      into Vibration.vibrate() as the pattern parameter.
     */
    // Vibration.vibrate(duration: 199);
    print(".play() is playing $timingArray");
    Vibration.vibrate(pattern: timingArray);
  }

}