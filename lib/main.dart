import 'dart:io'; // This is for sleep
import 'dart:math';


import 'package:flutter/material.dart';

import 'package:vibration/vibration.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_api_availability/google_api_availability.dart';

import 'package:lovetap3/config.dart';
import 'package:lovetap3/package.dart';
import 'package:lovetap3/incomingPackage.dart';
import 'package:lovetap3/outgoingPackage.dart';
import 'package:lovetap3/myFirebaseInterface.dart';
import 'package:lovetap3/myBuffer.dart';

Future<void> main() async {
  /*
    This is the entry point that runs MyApp;
   */
  WidgetsFlutterBinding.ensureInitialized(); // This makes sure that bindings are initialized



  runApp(LoveTap());
}

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

            FirebaseMessaging.onBackgroundMessage(MyFirebaseInterface.createBackgroundHandler);
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

