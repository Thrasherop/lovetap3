import 'dart:io'; // This is for sleep
import 'dart:math';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lovetap3/pages/ConnectionFailedScreen.dart';
import 'package:lovetap3/pages/ConnectionManagementScreen.dart';
import 'package:lovetap3/pages/HomeScreen.dart';
import 'package:lovetap3/pages/LoadingScreen.dart';
import 'package:lovetap3/pages/LoginScreen.dart';
import 'package:lovetap3/pages/TestingScreen.dart';

import 'package:vibration/vibration.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_api_availability/google_api_availability.dart';

import 'package:lovetap3/Config.dart';
import 'package:lovetap3/Package.dart';
import 'package:lovetap3/IncomingPackage.dart';
import 'package:lovetap3/OutgoingPackage.dart';
import 'package:lovetap3/MyFirebaseInterface.dart';
import 'package:lovetap3/MyBuffer.dart';
import 'package:lovetap3/MyAuthenticator.dart';

Future<void> main() async {
  /*
    This is the entry point that runs MyApp;
   */

  // This starts the app via routing information
  runApp(MaterialApp(
    initialRoute: "/loading",
    routes: {
      "/loading":(context) =>LoadingScreen(),
      "/home": (context) => HomeScreen(),
      Config.CONNECTION_FAILED_SCREEN:(context) => ConnectionFailedScreen(),
      "/login": (context) => LoginScreen(),
      "/testing": (context) => TestingScreen(),
      "/connection_management": (context) => ConnectionManagementScreen(),
    },
  ));

}

@Deprecated("this is the old LoveTap widget. Don't use lol")
class LoveTap extends StatelessWidget {

  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();


  LoveTap({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(

        /*
          This code (inside the FutureBuilder) is to deal with the loading of the FirebaseApp _fbApp
          This allows us to have a short loading screen while it loads, for example.
         */
        future: _fbApp,
        builder: (context, snapshot){
          if (snapshot.hasError){
            // runs if there was an error initializing FirebaseApp _fbApp
            print("You have an error! ${snapshot.error.toString()}");
            return const Text("Something went wrong");
          } else if (snapshot.hasData){

            // Registers message handlers
            //TODO: the getToken() needs to be handled by a Future
            // MyBuffer.currentToken = FirebaseMessaging.instance.getToken(); //await // This needs to be called before calling listeners. See https://github.com/firebase/flutterfire/issues/6011

            FirebaseMessaging.instance.getToken().then((value) => MyBuffer.currentToken = value);

            FirebaseMessaging.onBackgroundMessage(MyFirebaseInterface.backgroundHandler);
            FirebaseMessaging.onMessage.listen(MyFirebaseInterface.foregroundHandler);


            // It worked, so we return the MyHomePage normally
            return const MyHomePage(title: 'Flutter Demo Home Page');
          } else {
            // This is when it is still loading, so for now we just show a loading screen
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

        }
      )
      // const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0; // Holds the counter for the demo page
  late OutgoingPackage curPackage = OutgoingPackage.PlaceHolder();
  String _selectedDestination = Config.DESTINATION_OPTIONS[0].value;


  bool _isSigningIn = false;
  bool _isSigningOut = false;

  void _incrementCounter() async {

    // Test code for the realtime database. This merely updates the test child with a random number
    DatabaseReference _testRef = FirebaseDatabase.instance.ref().child("test");
    _testRef.set("Hello world ${Random().nextInt(100)}");

    final fcmToken = await FirebaseMessaging.instance.getToken();
    print("FirebaseMessaging token: $fcmToken");

    // Vibration.vibrate(pattern: [100, 1000, 100, 1000]);

    Vibration.vibrate(pattern: [1000, 100, 1000]);

    setState(() {

      _counter++;

    });
  }

  void _actionButton(){
    // Nothing to do here atm

  }

  void _minorActionButton() async {
    print("minor button pressed");

    setState(() {
      _isSigningIn = true;
    });

    User? user = await MyAuthenticator.signInWithGoogle(context: context);

    print(user?.email);

    setState(() {
      _isSigningIn = false;
    });

    if (user != null) {
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) =>
      //         UserInfoScreen(
      //           user: user,
      //         ),
      //   ),
      // );
      print("user != null");
    } else {
      print("User == null");
    }

    print("afterwards");
  }

  void _microActionButton() async {
    setState(() {
      _isSigningOut = true;
    });

    await MyAuthenticator.signOut(context: context);
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null){
      print("signout failed");
    } else {
      print("signout succeeded");
    }

    setState(() {
      _isSigningOut = false;
    });
  }

  void _press(PointerDownEvent event){
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

  void _release(PointerUpEvent event){

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

    // This is prebuilt crap from
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),

            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            Listener(
              /*
                This listener contains the main pressing button.
                This listener listens for pointer down and pointerUp. This
                is to track the length of a tap.
               */
              onPointerDown: _press,
              onPointerUp: _release,

              child: Container(
                height: 100.0,
                width: 100.0,
                child: FloatingActionButton(
                  onPressed: _actionButton,
                  child: const Icon(Icons.accessibility_sharp),
                ),
              ),
            ),
            DropdownButton(
                items: Config.DESTINATION_OPTIONS,
                onChanged: _destinationChanged,
                value: _selectedDestination,

            ),
            ElevatedButton(
                onPressed: _minorActionButton,
                child: Text("Sign in: ${_isSigningIn.toString()}"),
            ),
            ElevatedButton(
              onPressed: _microActionButton,
              child: Text("Sign out: ${_isSigningOut.toString()}"),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }



}

