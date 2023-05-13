import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lovetap3/misc/MyBuffer.dart';
import 'package:lovetap3/interfaces/MyFirebaseInterface.dart';
import 'package:lovetap3/interfaces/MyFileInterface.dart';
import 'package:lovetap3/objects/MyNullObject.dart';

import '../misc/Config.dart';
import '../misc/functions.dart';
import '../objects/ConnectionObject.dart';


class ConnectionManagementScreen extends StatefulWidget {
  const ConnectionManagementScreen({Key? key}) : super(key: key);

  @override
  State<ConnectionManagementScreen> createState() => _ConnectionManagementScreenState();
}

class _ConnectionManagementScreenState extends State<ConnectionManagementScreen> {

  final emailInput = TextEditingController();

  @override
  void dispose() {
    // Clean up the text input controller when the widget is disposed.
    emailInput.dispose();

    // Pop our updateScreen off the MyBuffer.updateScreenCallback stack
    if (MyBuffer.updateScreenCallback.isNotEmpty) {
      MyBuffer.updateScreenCallback.removeAt(0);
    }

    super.dispose();
  }

  void requestConnection() async {

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

  void acceptConnection(ConnectionObject connection) async {

    /*

        Accepts the connection.

        Takes in a connection object, and accepts the connection
        that matches the connectionID.

        params::
          -- ConnectionObject connection: the connection to accept (passes into MyFireBaseInterface.acceptConnection())

        return::
          -- void

      */

    stamp("Accepting ${connection.getConnectionID()}");

    bool success = await MyFileInterface.acceptConnection(connection.getConnectionID());
    stamp("Acceptance status: $success");
    stamp("Data: ${await MyFileInterface.getConnectionsString()}");

    stamp("Requested acceptance: ${await MyFirebaseInterface.acceptConnection(connection.getConnectionID())}");


    // Reload the screen to show changes
    setState(() {});

  }

  void deleteConnection(ConnectionObject connection) async {

    /*

        Deletes the connection.

        Takes in a connection object, and deletes the connection
        that matches the connectionID.

        params::
          -- ConnectionObject connection: the connection to accept (passes into MyFireBaseInterface.deleteConnection())

        return::
          -- void

      */

    stamp("Deleting ${connection.getConnectionID()}");

    bool success = await MyFileInterface.deleteConnection(connection.getConnectionID());
    stamp("Acceptance status: $success");

    // Reload the screen to show changes
    setState(() {});
  }

  void updateScreen(){
    /// Callback for updating the screen
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    /// build function

    // update callback
    MyBuffer.updateScreenCallback.insert(0, updateScreen);

    return Scaffold(
      body: SafeArea(
        child: Column(

          // Section to input email and request connection
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            Row (
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: emailInput,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter an email to request",
                    ),
                  ),
                ),

                ElevatedButton(
                    onPressed: requestConnection,
                    child: Text("REQUEST")
                )
              ],
            ),


            // Builder to load (and subsequently display) connections
            FutureBuilder(builder: (stx, snapshot){

                if (snapshot.hasData && snapshot.data != null){

                  Map<String, ConnectionObject> dataMap = snapshot.data ?? {};

                  // If there isn't data, say so
                  if (dataMap.isEmpty){
                    return Text("No connection data. Try requesting a connection with someone!");
                  }


                  /*
                    Convert it into a list, and order it: active first, then requests. Sorted by newest first
                   */
                  List<ConnectionObject> dataList= <ConnectionObject>[];
                  List<ConnectionObject> activeConnections = <ConnectionObject>[];

                  dataMap.forEach((key, value) {
                    if (value.isActive()){
                      // if it is active, we need to set it aside to insert last
                      activeConnections.add(value);
                    } else {
                      dataList.add(value);
                    }
                  });

                  // reverse the list so that recent connections are first
                  dataList = List.from(dataList.reversed);

                  // now we add the active ones to the front w/ newest first
                  for (ConnectionObject connection in activeConnections.reversed){
                    dataList.insert(0, connection);
                  }



                  // generate the list of widgets
                  List<Widget> widgetList = <Widget>[];
                  for (var element in dataList) {
                    Widget thisWidget = Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          element.getTargetEmail(),
                          style: TextStyle(),
                        ),

                        // Adds accept button if it's not active
                        element.isActive() ? SizedBox(height: 0, width: 0,) : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[800],
                          ),
                          onPressed: () {
                            acceptConnection(element);
                          },
                          child: Text("ACCEPT"),
                        ),

                        // Delete Button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[800],
                          ),
                          onPressed: (){
                            deleteConnection(element);
                          },
                          child: Text("DELETE"),
                        ),

                      ],
                    );

                    widgetList.add(thisWidget);
                  }

                  // This is the actual list box
                  return Material(
                    child: SizedBox(
                      height: 300,
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: DecoratedBox(
                            decoration: const BoxDecoration(color: Colors.blue),
                            child: GlowingOverscrollIndicator(
                              axisDirection: AxisDirection.down,
                              color: Colors.white,
                              child: ListView(
                                padding: const EdgeInsets.all(10),
                                physics: const ClampingScrollPhysics(),
                                children: widgetList,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );

                } else if (snapshot.hasError){
                  // TODO: style this
                  return Text("An error occured while fetching data");
                } else {
                  // TODO: style this
                  return Text("Loading connection data...");
                }
              },

              future: MyFileInterface.getConnections(),

            )
          ],
        ),
      ),
    );
  }
}
