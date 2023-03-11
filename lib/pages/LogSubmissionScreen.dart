import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lovetap3/interfaces/MyFirebaseInterface.dart';

import '../misc/Config.dart';

class LogSubmissionScreen extends StatefulWidget {
  const LogSubmissionScreen({Key? key}) : super(key: key);

  @override
  State<LogSubmissionScreen> createState() => _LogSubmissionScreenState();
}

class _LogSubmissionScreenState extends State<LogSubmissionScreen> {

  final textInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Config.primaryColor,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Please note: This will submit your app's logs, including message contents, target information, etc.",
                    style: TextStyle(
                        color: Config.secondaryColor,

                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Describe your bug here (optional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    controller: textInputController,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Config.secondaryColor,
                    ),
                    child: SizedBox(
                      width: 100,
                      child: Row(

                        children: [
                          Icon(Icons.bug_report, color: Config.primaryColor,),
                          Text(
                            'Submit',
                            style: TextStyle(color: Config.primaryColor),
                          ),
                        ],
                      ),
                    ),

                    onPressed: () {
                      MyFirebaseInterface.submitRamLog(textInputController.text);
                    },
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
