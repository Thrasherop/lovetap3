import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lovetap3/interfaces/MyFirebaseInterface.dart';
import 'package:lovetap3/objects/Package.dart';
import 'package:lovetap3/misc/Config.dart';
import 'package:lovetap3/misc/MyBuffer.dart';

import 'package:lovetap3/interfaces/MyAuthenticator.dart';
import 'package:lovetap3/misc/functions.dart';
import 'package:lovetap3/interfaces/MyFileInterface.dart';
import 'package:lovetap3/objects/ConnectionObject.dart';

class OutgoingPackage extends Package {

  /*
    This package represents outgoing packages
    that will send to Firebase.

    Attributes::
        - _lastUpdate: DateTime
        - _isPressed: bool
        - _hasTimedOut: bool
        _ _isPlaceHolder: bool

     Methods::
        + OutgoingPackage() -> Default constructor
   */

  late DateTime _lastUpdate;
  late bool _isPressed;
  bool _hasTimedOut = false;

  bool _isPlaceHolder = false;

  OutgoingPackage() : super(){
    /*
      Default constructor.

      return:
          -- OutgoingPackage: Default, non-placeholder Package object
     */

    stamp("New Package has been constructed. NOTE: This does NOT call press(), but it does update _lastUpdate");
    _lastUpdate = DateTime.now();

  }

  OutgoingPackage.PlaceHolder() : super() {
    /*
      This type of Package is for when main.dart needs
      something inside its Package instance. It needs
      it to not be null for when presses occur
     */

    _isPlaceHolder = true;
    stamp("Package of nullable has been declared");
  }

  /*
    Getters
   */

  bool isPressed(){
    /*
      Getter to check if the package is currently being pressed

      return:
          -- Boolean: Whether the package is being pressed
     */

    return _isPressed;
  }

  bool hasTimedOut(){
    /*
      Getter to check if this package has timed out

      return:
          -- Boolean: whether the package has timed out
     */
    return _hasTimedOut;
  }

  bool isPlaceHolder(){
    /*
      Getter to check if this instance is a PlaceHolder

      return::
          -- bool -> whether this instance is a PlaceHolder or not
     */
    return _isPlaceHolder;
  }

  Future<Map<String, String>> getJson() async {

    /*
      This method is used to compile the data of
      this OutgoingPackage into json to be sent
      to firebase

      return::
          -- Map<String, String> -> The data of this package
     */

    // Creates timingArray string
    String timingString = "";
    for (var element in timingArray) {
      timingString += "$element!!!";
    }
    stamp("Timing string: $timingString");



    // Get the target's Uid
    Map<String, ConnectionObject> connections = await MyFileInterface.getConnections();
    // connections.forEach((key, value) {
    //   stamp("Connection: ${value.getConnectionID()}");
    // });

    stamp("All connectiosn: ${connections.toString()}");

    if (!connections.containsKey(MyBuffer.currentTargetDestination)){
      stampE("Target connection does not exist in connection database");
      return {};
    }

    ConnectionObject thisConnection = connections[MyBuffer.currentTargetDestination]!;

    String currentUserId = FirebaseAuth.instance.currentUser!.uid;


    // Returns the map of the data
    return <String, String>{
      "pattern": timingString,
      "connectionID": thisConnection.getConnectionID(),
      "fromUid": currentUserId,
    };

  }

  /*
    Functional Methods (do-ers)
   */


  void press(){
    /*
      Call this when the tap is pressed.

      This will add the time delta
      to the timing array, and set _isPressed to true
     */

    // Updates lastUpdate to right now
    _cycleTimings();

    // Updates the _isPressed function
    _isPressed = true;
  }

  void release() {
    /*
      Call this when the tap is released.

      This will add the time delta
      to the timing array, and set _isPressed to false. It also creates
      a new _packageTimeout daemon with the delay of Config.PACKAGE_TIMEOUT
     */

    _cycleTimings();

    // Starts the delayed process to check for package completion
    Future.delayed(Duration(milliseconds:Config.PACKAGE_TIMEOUT), _packageTimeout);

    _isPressed = false;
  }


  void _cycleTimings(){
    /*
      This method cycles the timings.

      This means taking the current time delta (now - lastUpdate)
      and appending it to the _timingArray. Then it updates _lastUpdate.
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
      Checks if a package has timed out.

      Specifically, this is called 4 seconds after every release.
      If no update has happened in Config.PACKAGE_TIMEOUT time, then
      the package will send.
     */

    Duration timeDelta = DateTime.now().difference(_lastUpdate);

    if (timeDelta.inMilliseconds > Config.PACKAGE_TIMEOUT){
      stamp("Package has timed out");
      _sendPackage();
      _hasTimedOut = true;
    } else {
      stamp("Daemon has finished without a timeout.");
      _hasTimedOut = false;
    }

  }

  void _sendPackage(){
    /*
      Uploads this package object to Firebase.

      This is done through MyFirebaseInterface.sendPackage(this).
     */

    MyFirebaseInterface.sendPackage(this);

  }
}

