import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lovetap3/myFirebaseInterface.dart';
import 'package:lovetap3/package.dart';
import 'package:lovetap3/config.dart';
import 'package:lovetap3/myBuffer.dart';


class OutgoingPackage extends Package {

  late DateTime _lastUpdate;
  late bool _isPressed;
  bool _hasTimedOut = false;

  bool _isPlaceHolder = false;

  OutgoingPackage() : super(){
    /*
      Default constructor.

      return:
          -- Package: Default, non-placeholder Package object
     */

    print("New Package has been constructed. NOTE: This does NOT call press(), but it does update _lastUpdate");
    _lastUpdate = DateTime.now();

  }

  OutgoingPackage.PlaceHolder() : super() {
    /*
      This type of Package is for when main.dart needs
      something inside its Package instance. It needs
      it to not be null for when presses occur
     */

    _isPlaceHolder = true;
    print("Package of nullable has been declared");
  }

  /*
    Getters
   */

  bool isPressed(){
    /*
      Simple getter to check if the package is currently being pressed

      return:
          -- Boolean: Whether the package is being pressed
     */

    return _isPressed;
  }

  bool hasTimedOut(){
    /*
      Simple getter to check if this package has timed out

      return:
          -- Boolean: whether the package has timed out
     */
    return _hasTimedOut;
  }

  bool isPlaceHolder(){
    /*
      This is a getter to check if this instance is a PlaceHolder
     */
    return _isPlaceHolder;
  }

  Map<String, String> getJson(){

    // Creates timingArray string
    String timingString = "";
    for (var element in timingArray) {
      timingString += "$element!!!";
    }
    print("Timing string: $timingString");



    return <String, String>{
      Config.DATA_MAP: timingString,
      Config.TARGET_MAP: MyBuffer.currentTargetDestination,
      Config.ORIGIN_MAP: MyBuffer.currentToken.toString(),
    };

  }


  /*
    Setters
   */

  void press(){
    /*
      Call this when the tap is pressed
     */

    // Updates lastUpdate to right now
    // _lastUpdate = DateTime.now();
    _cycleTimings();

    // Updates the _isPressed function
    _isPressed = true;
  }

  void release() {
    /*
      Call this when the tap is released
     */

    _cycleTimings();

    // Starts the delayed process to check for package completion
    Future.delayed(Duration(milliseconds:Config.PACKAGE_TIMEOUT), _packageTimeout);

    _isPressed = false;
  }


  /*
    Functional Methods
   */

  void _cycleTimings(){
    /*
      This method cycles the timings. This means
      taking the current time delta (now - lastUpdate)
      and appending it to the _timingArray. Then
      it updates _lastUpdate.
     */

    // Gets this timing array based on _lastUpdate
    // (this needs to happen before we change _lastUpdate)
    Duration timeDelta = DateTime.now().difference(_lastUpdate);
    timingArray.add(timeDelta.inMilliseconds);

    // Now we can update _lastUpdate
    _lastUpdate = DateTime.now();

  }

  void _packageTimeout(){
    /*
      This function is called when a package
     */

    Duration timeDelta = DateTime.now().difference(_lastUpdate);

    if (timeDelta.inMilliseconds > Config.PACKAGE_TIMEOUT){
      print("Package has timed out");
      _sendPackage();
      _hasTimedOut = true;
    } else {
      print("Daemon has finished without a timeout.");
      _hasTimedOut = false;
    }

  }

  void _sendPackage(){

    print("Package._sendPackage() has been called. The package is: ${timingArray.toString()}");

    MyFirebaseInterface.sendPackage(this);

    // play();
  }


}

