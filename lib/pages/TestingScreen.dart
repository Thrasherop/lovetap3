import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
import '../interfaces/SettingManager.dart';
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
    // stamp("Testing screen: Action button call");
    //
    // stamp("Calling save settings");
    // Settings.saveAll();

    // await Firebase.initializeApp();
    stamp("Initiating artificial test crash via FirebaseCrashlytics....");
    FirebaseCrashlytics.instance.crash();

  }

  void actionBtn2() async {
    stamp("action button 2: ");


    // stamp("Calling setPriority at low:");
    // stamp("setpriotity result: ${await MyFirebaseInterface.setPriority(PriorityEnum.LOW)}");

    stamp("Loading settings");
    SettingManager.initialize();
    stamp("Settings loaded");
  }

  void actionBtn3() async {
    stamp("Action button 3");

    stamp("checking settings value");
    stamp("${SettingManager.getSetting("messagePriority")}");
  }

  @override
  Widget build(BuildContext context) {

    // Some dummy data
    List<ConnectionObject> connections = [];
    connections.add(ConnectionObject.explicit("JoshuaKopaunik@gmail.com", "JoshuaKopaunik@gmail.com", false));
    connections.add(ConnectionObject.explicit("222", "222", false));
    connections.add(ConnectionObject.explicit("333", "333", true));




    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Text("testing screen"),
              ElevatedButton(onPressed: actionbtn1, child: Text("Action Button 1")),
              ElevatedButton(onPressed: actionBtn2, child: Text("Action Button 2")),
              ElevatedButton(onPressed: actionBtn3, child: Text("Action button 3")),

              // Text("tesgin screen"),

              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xfffc03ca),
                        Color(0xff690254),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter email',
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Request connection
                          },
                          child: Text('Request'),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: connections.length,
                            itemBuilder: (context, index) {
                              ConnectionObject connection = connections[index];
                              return Card(
                                color: Color.lerp(
                                  Color(0xfffc03ca),
                                  Color(0xff690254),
                                  0.5,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          connection.getTargetEmail(),
                                          style: TextStyle(
                                            color: Color(0xff00ff00), // Bright green
                                          ),
                                        ),
                                      ),
                                      if (!connection.isActive()) ...[
                                        TextButton(
                                          onPressed: () {
                                            // Accept connection
                                          },
                                          child: Text(
                                            'Accept',
                                            style: TextStyle(
                                              color: Color(0xff006400), // Dark green
                                            ),
                                          ),
                                        ),
                                      ],
                                      TextButton(
                                        onPressed: () {
                                          // Delete connection
                                        },
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(
                                            color: Color(0xff006400), // Dark green
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
