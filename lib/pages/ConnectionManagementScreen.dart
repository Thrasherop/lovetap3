import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lovetap3/interfaces/SettingManager.dart';
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

  // variables to hold each tab's widget
  Widget _allConnectionsWidget = Scaffold();
  Widget _activeConnectionsWidget = Scaffold();
  Widget _connectionRequestsWidget = Scaffold();

  // Input for the edit pop-up
  final nicknameInput = TextEditingController();


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
    ConnectionObject newConnection = ConnectionObject.explicit(data["connectionID"]!, data["targetEmail"]!, "No nickname", true, true);
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

  void _editConnection(ConnectionObject connection) async {

    // Calculate the style for the buttons & button text
    ButtonStyle buttonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(SettingManager.colorArray[10]!),
    );

    TextStyle textStyle = TextStyle(
        color: SettingManager.colorArray[13]
    );

    // Set the nickname value
    nicknameInput.text = connection.getNickname() == connection.getTargetEmail() ? "" : connection.getNickname();


    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: SettingManager.colorArray[4],
        // title: Text("The dialog title"),
        content: SizedBox(
          height: 300,
          child: Column(
            children: [
              Text(
                "${connection.getTargetEmail()} ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: SettingManager.colorArray[2],
                ),
              ),

              Row(
                children: [
                  Text(
                    "Nickname: ",
                    style: TextStyle(
                      color: SettingManager.colorArray[2],
                    ),
                  ),

                  Flexible(
                    child: TextField(
                        controller: nicknameInput,
                    ),
                  ),



                ],
              ),
            ],
          ),
        ),

        actionsAlignment: MainAxisAlignment.spaceAround,
        actions: [
          ElevatedButton(
              onPressed: () {

                // Update the connection
                connection.setNickname(nicknameInput.text);
                MyFileInterface.updateConnection(connection);
                // Close the dialog
                Navigator.pop(context);

                // update screen
                setState(() {});
              },
              style: buttonStyle,
              child: Text("Save", style: textStyle)
          ),
          ElevatedButton(
              onPressed: () {
                // Send accept request
                deleteConnection(connection);

                // Close the dialog
                Navigator.pop(context);
              },
              style: buttonStyle,
              child: Text("Delete", style: textStyle)
          ),
          ElevatedButton(
              onPressed: () {
                // This is the cancel, so we just close the dialog
                Navigator.pop(context);
              },
              style: buttonStyle,
              child: Text("Cancel", style: textStyle)
          ),
        ],
      ),
    );


  }

  void _respond(ConnectionObject connection) async {

    // Calculate the style for the buttons & button text
    ButtonStyle buttonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(SettingManager.colorArray[10]!),
    );

    TextStyle textStyle = TextStyle(
      color: SettingManager.colorArray[13]
    );


    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: SettingManager.colorArray[4],
        // title: Text("The dialog title"),
        content: Text(
          "You have recieved a connection request from ${connection.getTargetEmail()}. \n\n"
              "What would you like to do?",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: SettingManager.colorArray[2],
          ),
        ),

        actionsAlignment: MainAxisAlignment.spaceAround,
        actions: [
          ElevatedButton(
              onPressed: () {
                // Send accept request
                acceptConnection(connection);

                // Close the dialog
                Navigator.pop(context);
              },
              style: buttonStyle,
              child: Text("Accept", style: textStyle)
          ),
          ElevatedButton(
              onPressed: () {
                // Send accept request
                deleteConnection(connection);

                // Close the dialog
                Navigator.pop(context);
              },
              style: buttonStyle,
              child: Text("Delete", style: textStyle)
          ),
          ElevatedButton(
              onPressed: () {
                // This is the cancel, so we just close the dialog
                Navigator.pop(context);
              },
              style: buttonStyle,
              child: Text("Cancel", style: textStyle)
          ),
        ],
      ),
    );


  }

  void updateScreen(){
    /// Callback for updating the screen
    setState(() {});
  }

  void setRequestsAsRead() async {
    await MyFileInterface.setRequestsAsRead();
    // rebuild the screen
    setState(() {});
  }

  Widget _calculateTab(List<ConnectionObject> connections)  {

    // Check if the list is empty
    // if yes, return a widget saying so
    if (connections.isEmpty){
      return Scaffold(
        backgroundColor: SettingManager.colorArray[11],

        body: Center(
          // heightFactor: 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 80,), // Move the text lower
              Text(
                "All caught up!",
                textAlign: TextAlign.center,
                style: GoogleFonts.getFont(
                  Config.SECONDARY_FONT,
                  textStyle: TextStyle(
                      fontSize: 20,
                      color: SettingManager.colorArray[14],
                      decoration: TextDecoration.none
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Text(
                "No pending requests",
                textAlign: TextAlign.center,
                style: GoogleFonts.getFont(
                  Config.SECONDARY_FONT,
                  textStyle: TextStyle(
                      fontSize: 12,
                      color: SettingManager.colorArray[14],
                      decoration: TextDecoration.none
                  ),
                ),
              ),

              SizedBox(height: 40),

              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(SettingManager.colorArray[10]!),
                ),

                child: Text(
                  "Send Request",
                  style: TextStyle(
                      color: SettingManager.colorArray[13]
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Generate all sub-widgets
    List<Widget> widgetList = <Widget>[];

    List<Widget> thisRow = <Widget>[];
    Widget thisText;
    for (ConnectionObject conn in connections){

      // Clear thisRow
      thisRow = <Widget>[];

      // append the text part conataining the nickname
      thisRow.add(
          Container(
            constraints: BoxConstraints(minWidth: 1, maxWidth: 200, maxHeight: 20),
            child: Text(
            conn.getNickname(),
            style: GoogleFonts.getFont(
              Config.SECONDARY_FONT,
              textStyle: TextStyle(
                fontSize: 15,
                color: SettingManager.colorArray[14],
                decoration: TextDecoration.none
              ),
            ),
          ),
        )
      );

      if (conn.isActive()){
        // Generate an edit button
        thisRow.add(
          Container(
            constraints: BoxConstraints(minWidth: 90, maxWidth: 90, maxHeight: 40),
            child: ElevatedButton(
              onPressed: () {_editConnection(conn);},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(SettingManager.colorArray[10]!),
              ),

              child: Text(
                "Edit",
                style: TextStyle(
                  color: SettingManager.colorArray[13]
                ),
              ),
            ),
          )
        );
      } else {
        // Generate accept and delete buttons, then put in a row
        // to ensure proper spacing
        thisRow.add(
          Container(
            constraints: BoxConstraints(minWidth: 90, maxWidth: 90, maxHeight: 40),
            child: ElevatedButton(
              onPressed: () {_respond(conn);},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(SettingManager.colorArray[10]!),
              ),

              child: Text(
                "Respond",
                style: TextStyle(
                    color: SettingManager.colorArray[13]
                ),
              ),
            ),
          )
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     ElevatedButton(
          //       onPressed: () {acceptConnection(conn);},
          //       child: Text("Accept")
          //     ),
          //     ElevatedButton(
          //       onPressed: () {deleteConnection(conn);},
          //       child: Text("Delete")
          //     )
          //   ],
          // )
        );
      }


      // Add this row to the widget list
      widgetList.add(
        Container(
          decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.0, color: SettingManager.colorArray[12]!),
              ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: thisRow,
            ),
          ),
        )
      );
    }

    return Scaffold(
      backgroundColor: SettingManager.colorArray[11],
      body: ListView(
        physics: const ClampingScrollPhysics(),
        children: widgetList,
      ),
    );

  }

  void _updateTabs() async {

    // Get the list of connections

    Map<String, ConnectionObject> connections = await MyFileInterface.getConnections();

    // Sort the connections into the three types
    List<ConnectionObject> allConnections = <ConnectionObject>[];
    List<ConnectionObject> activeConnections = <ConnectionObject>[];
    List<ConnectionObject> connectionRequests = <ConnectionObject>[];
    for (ConnectionObject thisConn in connections.values) {

      allConnections.add(thisConn);

      if (thisConn.isActive()){
        activeConnections.add(thisConn);
      } else {
        connectionRequests.add(thisConn);
      }
    }

    // Update the three widgets
    _allConnectionsWidget = _calculateTab(allConnections);
    _activeConnectionsWidget = _calculateTab(activeConnections);
    _connectionRequestsWidget = _calculateTab(connectionRequests);

    // Update the screen
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    // set all connections as read
    setRequestsAsRead();

    // Update the tabs
    _updateTabs();

    // update callback
    MyBuffer.updateScreenCallback.insert(0, updateScreen);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          // Set back button to the primary text color for complex screens
          iconTheme: IconThemeData(
            color: SettingManager.colorArray[13]
          ),

          backgroundColor: SettingManager.colorArray[10],
          bottom: TabBar(
            tabs: const [
              Tab(text: "All"),
              Tab(text: "Active"),
              Tab(text: "Requests"),
            ],
            labelColor: SettingManager.colorArray[13],
          ),

          title: Text(
            'Manage connections',
            style: TextStyle(color: SettingManager.colorArray[13]),),
          centerTitle: true,
        ),
        body: SafeArea (
          child: TabBarView(
            children: [
              _allConnectionsWidget,
              _activeConnectionsWidget,
              _connectionRequestsWidget,
            ],
          ),
        )
      ),
    );

    // return Scaffold(
    //   body: SafeArea(
    //     child: Column(
    //
    //       // Section to input email and request connection
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       children: [
    //
    //         Row (
    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
    //           children: [
    //             SizedBox(
    //               width: 200,
    //               child: TextField(
    //                 controller: emailInput,
    //                 decoration: InputDecoration(
    //                   border: OutlineInputBorder(),
    //                   hintText: "Enter an email to request",
    //                 ),
    //               ),
    //             ),
    //
    //             ElevatedButton(
    //                 onPressed: requestConnection,
    //                 child: Text("REQUEST")
    //             )
    //           ],
    //         ),
    //
    //
    //         // Builder to load (and subsequently display) connections
    //         FutureBuilder(builder: (stx, snapshot){
    //
    //             if (snapshot.hasData && snapshot.data != null){
    //
    //               Map<String, ConnectionObject> dataMap = snapshot.data ?? {};
    //
    //               // If there isn't data, say so
    //               if (dataMap.isEmpty){
    //                 return Text("No connection data. Try requesting a connection with someone!");
    //               }
    //
    //
    //               /*
    //                 Convert it into a list, and order it: active first, then requests. Sorted by newest first
    //                */
    //               List<ConnectionObject> dataList= <ConnectionObject>[];
    //               List<ConnectionObject> activeConnections = <ConnectionObject>[];
    //
    //               dataMap.forEach((key, value) {
    //                 if (value.isActive()){
    //                   // if it is active, we need to set it aside to insert last
    //                   activeConnections.add(value);
    //                 } else {
    //                   dataList.add(value);
    //                 }
    //               });
    //
    //               // reverse the list so that recent connections are first
    //               dataList = List.from(dataList.reversed);
    //
    //               // now we add the active ones to the front w/ newest first
    //               for (ConnectionObject connection in activeConnections.reversed){
    //                 dataList.insert(0, connection);
    //               }
    //
    //
    //
    //               // generate the list of widgets
    //               List<Widget> widgetList = <Widget>[];
    //               for (var element in dataList) {
    //                 Widget thisWidget = Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Text(
    //                       element.getTargetEmail(),
    //                       style: TextStyle(),
    //                     ),
    //
    //                     // Adds accept button if it's not active
    //                     element.isActive() ? SizedBox(height: 0, width: 0,) : ElevatedButton(
    //                       style: ElevatedButton.styleFrom(
    //                         backgroundColor: Colors.green[800],
    //                       ),
    //                       onPressed: () {
    //                         acceptConnection(element);
    //                       },
    //                       child: Text("ACCEPT"),
    //                     ),
    //
    //                     // Delete Button
    //                     ElevatedButton(
    //                       style: ElevatedButton.styleFrom(
    //                         backgroundColor: Colors.red[800],
    //                       ),
    //                       onPressed: (){
    //                         deleteConnection(element);
    //                       },
    //                       child: Text("DELETE"),
    //                     ),
    //
    //                   ],
    //                 );
    //
    //                 widgetList.add(thisWidget);
    //               }
    //
    //               // This is the actual list box
    //               return Material(
    //                 child: SizedBox(
    //                   height: 300,
    //                   child: Padding(
    //                     padding: const EdgeInsets.all(30.0),
    //                     child: ClipRRect(
    //                       borderRadius: BorderRadius.circular(20),
    //                       child: DecoratedBox(
    //                         decoration: const BoxDecoration(color: Colors.blue),
    //                         child: GlowingOverscrollIndicator(
    //                           axisDirection: AxisDirection.down,
    //                           color: Colors.white,
    //                           child: ListView(
    //                             padding: const EdgeInsets.all(10),
    //                             physics: const ClampingScrollPhysics(),
    //                             children: widgetList,
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               );
    //
    //             } else if (snapshot.hasError){
    //               // TODO: style this
    //               return Text("An error occured while fetching data");
    //             } else {
    //               // TODO: style this
    //               return Text("Loading connection data...");
    //             }
    //           },
    //
    //           future: MyFileInterface.getConnections(),
    //
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
