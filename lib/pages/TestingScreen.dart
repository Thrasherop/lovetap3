import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lovetap3/enums/PriorityEnum.dart';
import 'package:lovetap3/interfaces/MyAuthenticator.dart';
import 'package:lovetap3/interfaces/MyFirebaseInterface.dart';
import 'package:lovetap3/interfaces/MyFileInterface.dart';
import 'package:lovetap3/objects/ConnectionObject.dart';
import 'package:lovetap3/objects/MyNullObject.dart';

import '../misc/Config.dart';
import '../misc/MyBuffer.dart';
import '../misc/Settings.dart';
import '../objects/OutgoingPackage.dart';
import '../misc/functions.dart';

import 'package:logger/logger.dart';



class TestingScreen extends StatefulWidget {
  const TestingScreen({Key? key}) : super(key: key);

  @override
  State<TestingScreen> createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen> {

  void actionbtn1() async {
    stamp("Testing screen: Action button call");

    stamp("Calling save settings");
    Settings.saveAll();

  }

  void actionBtn2() async {
    stamp("action button 2: ");


    // stamp("Calling setPriority at low:");
    // stamp("setpriotity result: ${await MyFirebaseInterface.setPriority(PriorityEnum.LOW)}");

    stamp("Loading settings");
    Settings.initialize();
    stamp("Settings loaded");
  }

  void actionBtn3() async {
    stamp("Action button 3");

    stamp("checking settings value");
    stamp("${Settings.getSetting("messagePriority")}");
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
              ElevatedButton(onPressed: actionBtn3, child: Text("Action button 3")),


            ],
          ),
        ),
      ),
    );
  }
}
