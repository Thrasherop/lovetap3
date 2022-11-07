import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lovetap3/MyAuthenticator.dart';

import '../Config.dart';
import '../MyBuffer.dart';
import '../OutgoingPackage.dart';
import '../functions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late OutgoingPackage curPackage = OutgoingPackage.PlaceHolder();
  String _selectedDestination = Config.DESTINATION_OPTIONS[0].value;

  void _press(TapDownDetails event){
    /*
      This method is called when the button is pressed. It
      then processes it by first initializing a valid Package
      object (if curPackage is invalid), then by calling
      curPackage.press()
     */

    // Create a new package if the current one has timed out
    // This is why we need Packages of PlaceHolder type
    if (curPackage.isPlaceHolder() || curPackage.hasTimedOut()){
      curPackage = OutgoingPackage();
    }

    curPackage.press();
  }

  void _release(TapUpDetails event){

    /*
      This registers when the tap button is released. This
      merely calls curPackage.release()
     */

    curPackage.release();
  }

  void _destinationChanged(newValue){

    if (newValue is String){
      setState(() {
        print("New target destination is $newValue");

        // Updates target in buffer
        MyBuffer.currentTargetDestination = newValue;

        _selectedDestination = newValue;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.accessible_forward),
            Text("LoveTap"),
            Icon(Icons.menu)
          ]
        ),
        centerTitle: false,
        backgroundColor: Config.mainColor,
        elevation: 0.0,
      ),


      // WillPopScope prevents back presses
      body: WillPopScope(
        onWillPop: () async {
          stamp("Back press on home screen detected");
          final scaffold = ScaffoldMessenger.of(context);
          scaffold.showSnackBar(
              SnackBar(
                content: const Text('This is the home screen. To log out, go to settings.'),
                duration: Duration(milliseconds: Config.SNACKBAR_TIMEOUT),
              ));
          return false;
        },


        // Actual UI
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [

                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/testing");
                  },
                  child: Text("Go to testing screen"),
                ),

                TextButton(
                    onPressed: () async {
                      await MyAuthenticator.signOut(context: context);
                      Navigator.pushReplacementNamed(context, "/loading");
                      },
                    child: Text("Sign out")
                ),


                DropdownButton(
                  items: Config.DESTINATION_OPTIONS,
                  onChanged: _destinationChanged,
                  value: _selectedDestination,
                ),

                InkWell(
                  onTapDown: _press,
                  onTapUp: _release,

                  splashColor: Config.accent,
                  highlightColor: Colors.transparent, // This disables the white overlay on presses
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Ink(
                    width: 300,
                    height: 300,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Config.mainColor,
                    ),
                    child: Center(
                        child: Text(
                          "Tap Here",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Config.mainColor[600],
                            fontSize: 25,
                          ),
                        )
                    ),
                  )
                ),
              ],
            ),
          )
        ),
      )
    );
  }
}



