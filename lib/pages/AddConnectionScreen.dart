import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

    Fluttertoast.showToast(
        msg: "Sending your request...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: SettingManager.colorArray[1],
        fontSize: 16.0,
        backgroundColor: SettingManager.colorArray[2],
    );


    // validate that it is a gmail email
    String email = emailInput.text;
    String nickname = nicknameInput.text;
    if (!email.contains("@gmail.com")){
      stampE("Input email was NOT a gmail email");
      // TODO: Make better validation here
      return;
    } else if (nickname.length <= 1){
      stampE("Input nickname was empty");
      // TODO: make this fail more gracefully
      return;
    }

    // send request
    Map<String, String> data = await MyFirebaseInterface.requestConnection(email);
    if (data["status"] != "200"){
      stampE("Request connection failed: Received !200");
      return;
    } else {

      // Check if the context is working. If not, return
      if (!context.mounted) return;
      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: SettingManager.colorArray[4],
          // title: Text("The dialog title"),
          content: Text(
              "Your connection request has been sent. It may take a few seconds to arrive. \n\n"
                  "This contact has been added to your account, but they won't recieve your taps until they accept",
            style: TextStyle(
              color: SettingManager.colorArray[2],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  stamp("Okay button pressed");

                  // Close the dialog
                  Navigator.pop(context);
                },
                child: Text("Okay")
            ),
          ],
        ),
      );

    }


    // Add the connection locally
    // ConnectionObject newConnection = ConnectionObject.explicit(data["connectionID"]!, data["targetUid"]!, data["targetEmail"]!, true);
    ConnectionObject newConnection = ConnectionObject.explicit(data["connectionID"]!, data["targetEmail"]!, nickname, true, true);
    MyFileInterface.addConnection(newConnection);

    // clear the text
    emailInput.text = "";
    nicknameInput.text = "";

    // this closes the keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(

          backgroundColor: SettingManager.colorArray[1] ,
          resizeToAvoidBottomInset: false, // prevents overflow

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
                            style: TextStyle(
                              color: SettingManager.colorArray[2],
                            ),
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
                            style: TextStyle(
                              color: SettingManager.colorArray[2],
                            ),
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
