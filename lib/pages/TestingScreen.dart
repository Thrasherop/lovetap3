import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lovetap3/MyAuthenticator.dart';
import 'package:lovetap3/interfaces/MyFileInterface.dart';

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
    // print(FirebaseFunctions.instanceFor(region: "us-central1").httpsCallable("testing").call());

    // HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('testing');
    // final results = await callable();

    test();

    HttpsCallable callable = FirebaseFunctions.instanceFor(region: "us-central1").httpsCallable("testing", options: HttpsCallableOptions(timeout: Duration(seconds: 5)));
    final result = await callable();

    stamp("result from function.testing is $result, data: ${result.data}");

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

            ],
          ),
        ),
      ),
    );
  }
}
