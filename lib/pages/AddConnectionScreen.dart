import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lovetap3/interfaces/SettingManager.dart';

import '../interfaces/MyFileInterface.dart';
import '../interfaces/MyFirebaseInterface.dart';
import '../misc/functions.dart';
import '../objects/ConnectionObject.dart';

class AddConnectionScreen extends StatefulWidget {
  const AddConnectionScreen({Key? key}) : super(key: key);

  @override
  State<AddConnectionScreen> createState() => _AddConnectionScreenState();
}

class _AddConnectionScreenState extends State<AddConnectionScreen> {

  final emailInput = TextEditingController();
  final nicknameInput = TextEditingController();

  void _requestConnection() async {

    /*
        Requests a connection via email input.
    */

    stamp("Email input: ${emailInput.text}");

    // validate that it is a gmail email
    String email = emailInput.text;
    if (!email.contains("@gmail.com")){
      stampE("Input email was NOT a gmail email");
      // TODO: Make better validation here
    }

    // send request
    Map<String, String> data = await MyFirebaseInterface.requestConnection(email);
    if (data["status"] != "200"){
      stampE("Request connection failed: Received !200");
      return;
    }


    // Add the connection locally
    // ConnectionObject newConnection = ConnectionObject.explicit(data["connectionID"]!, data["targetUid"]!, data["targetEmail"]!, true);
    ConnectionObject newConnection = ConnectionObject.explicit(data["connectionID"]!, data["targetEmail"]!, true);
    MyFileInterface.addConnection(newConnection);

    emailInput.text = ""; // clear the text
    FocusManager.instance.primaryFocus?.unfocus(); // this closes the keyboard

    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(

          backgroundColor: SettingManager.colorArray[1] ,

          body: SafeArea(

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  SizedBox(height: 100),
                  Container(

                    alignment: Alignment.center,

                    child: SizedBox(
                      height: 400,
                      width: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Request a connection with a user by inputting their email and giving them a nickname",
                            style: GoogleFonts.getFont("Cormorant Garamond",
                              textStyle: TextStyle(
                                  fontSize: 30,
                                  color: SettingManager.colorArray[2],
                                  decoration: TextDecoration.none
                              ),
                              fontStyle: FontStyle.italic

                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height:50),
                          TextField(
                            controller: nicknameInput,
                            decoration: InputDecoration(
                              hintText: "Nickname (e.g. John)",
                              hintStyle: TextStyle(color: SettingManager.colorArray[2]),
                              enabledBorder: OutlineInputBorder(
                                // width: 0.0 produces a thin "hairline" border
                                borderRadius: BorderRadius.all(Radius.zero),
                                borderSide: BorderSide(color: SettingManager.colorArray[2]!, width: 0.0),
                              ),
                            ),
                          ),
                          TextField(
                            controller: emailInput,
                            decoration: InputDecoration(
                              hintText: "Email",
                              hintStyle: TextStyle(color: SettingManager.colorArray[2]),
                              enabledBorder: OutlineInputBorder(
                                // width: 0.0 produces a thin "hairline" border
                                borderRadius: BorderRadius.all(Radius.zero),
                                borderSide: BorderSide(color: SettingManager.colorArray[2]!, width: 0.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 50,),
                  ElevatedButton(
                    onPressed: _requestConnection,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SettingManager.colorArray[1],
                      side: BorderSide(
                        color: SettingManager.colorArray[3]!,
                        width: 1.0,
                      ),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.zero)),
                    ),
                    child: Text(
                      "Request connection",
                      style: TextStyle(
                        color: SettingManager.colorArray[2],
                      ),
                    ),
                  ),
                ],
              )
          )
      ),
    );
  }
}
