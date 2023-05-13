import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lovetap3/interfaces/SettingManager.dart';

import '../misc/functions.dart';

class AddConnectionScreen extends StatefulWidget {
  const AddConnectionScreen({Key? key}) : super(key: key);

  @override
  State<AddConnectionScreen> createState() => _AddConnectionScreenState();
}

class _AddConnectionScreenState extends State<AddConnectionScreen> {

  final emailInput = TextEditingController();
  final nicknameInput = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(

          backgroundColor: SettingManager.colorArray[1] ,

          body: SafeArea(

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  SizedBox(height: 200),
                  Container(

                    alignment: Alignment.center,

                    child: SizedBox(
                      height: 300,
                      width: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Request a connection with a user by inputting their email and giving them a nickname",
                            style: TextStyle(
                              fontSize: 20,
                              color: SettingManager.colorArray[2]
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height:50),
                          TextField(
                            controller: nicknameInput,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Nickname (e.g. John)",
                            ),
                          ),
                          TextField(
                            controller: emailInput,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Email",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 50,),
                  ElevatedButton(
                      onPressed: (){stamp("Request called");}, child: Text("Request")
                  ),
                ],
              )

          )
      ),
    );
  }
}
