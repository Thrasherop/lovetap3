import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lovetap3/MyAuthenticator.dart';
import 'package:lovetap3/MyFirebaseInterface.dart';
import 'package:lovetap3/interfaces/MyFileInterface.dart';
import 'package:lovetap3/objects/ConnectionObject.dart';

import '../Config.dart';
import '../MyBuffer.dart';
import '../OutgoingPackage.dart';
import '../functions.dart';

import 'package:logger/logger.dart';



class TestingScreen extends StatefulWidget {
  const TestingScreen({Key? key}) : super(key: key);

  @override
  State<TestingScreen> createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen> {

  void actionbtn1() async {

    stamp("Testing screen: Action button call");
    
    // stamp("Calling MyFireBaseInterface.requestConnection: ${await MyFirebaseInterface.requestConnection("ultraprim@gmail.com")}");
    // FirebaseMessaging.instance.getToken().then((value) => stamp("Token: $value"));


    // await MyFileInterface.addConnection("connectionID", "userID", false);
    // await MyFileInterface.addConnection("connection 2", "user 2", true);

    // stamp("MyFileInterface.getConnections());


    // await MyFileInterface.addConnection(ConnectionObject.direct("connection4", "user3", false));
    //
    stamp("Connections: ${await MyFileInterface.getConnections()}");
    // stamp("Connections: ${(await MyFileInterface.getConnections())["connection3"]}");

  }

  void actionBtn2() async {
    stamp("actionBtn2 called");


    stamp("Calling MyFireBaseInterface.requestConnection: ${await MyFirebaseInterface.requestConnection("ultraprim@gmail.com")}");

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Text("testing screen"),
              ElevatedButton(onPressed: actionbtn1, child: Text("Action Button 1")),
              ElevatedButton(onPressed: actionBtn2, child: Text("Action Button 2")),

            ],
          ),
        ),
      ),
    );
  }
}
