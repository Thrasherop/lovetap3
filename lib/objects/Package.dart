import 'package:flutter/cupertino.dart';
import 'package:lovetap3/misc/Config.dart';
import 'package:vibration/vibration.dart';

import '../misc/functions.dart';


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
      Plays the current _timingArray on this device.

      This is done by passing the timingArray
      into Vibration.vibrate() as the pattern parameter.

     */


    log4Bug(2, "Package.play() has been enteered");

    // makes sure that none of the timings is longer than 10 seconds.
    for (int i = 0; i < timingArray.length; i++){
      if (timingArray[i] > 30000){
        // if it is longer than 30 seconds, its probably a glitch
        // If its not a glitch, it should be limited anyways
        timingArray[1] = 1; // super short; not noticeable
      } else if (timingArray[i] > 15000){
        // if its over 15 seconds, but less than 30, it is
        // probably an intentional troll. Thus, we limit it
        // to 2 seconds.
        timingArray[i] = 2000;
      }
    }


    log4Bug(2, "Package.play() is passing the timing array to Vibration.vibrate()");
    // Vibration.vibrate(duration: 199);
    stamp(".play() is playing $timingArray"); // keep this log
    Vibration.vibrate(pattern: timingArray);
    log4Bug(2, "Package.play(): Vibration.vibrate() has returned. ");
  }

}