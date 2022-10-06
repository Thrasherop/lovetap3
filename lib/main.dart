import 'dart:io'; // This is for sleep

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

import 'package:lovetap3/package.dart';


void main() {
  /*
    This is the entry point that runs MyApp;
   */
  runApp(const LoveTap());
}

class LoveTap extends StatelessWidget {
  const LoveTap({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  late Package curPackage = Package.PlaceHolder();

  void _incrementCounter() async {

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
      curPackage = Package();
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}

