import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lovetap3/MyBuffer.dart';
import 'package:lovetap3/interfaces/MyFileInterface.dart';
import 'package:lovetap3/objects/MyNullObject.dart';

import '../Config.dart';
import '../functions.dart';
import '../objects/ConnectionObject.dart';


class ConnectionManagementScreen extends StatefulWidget {
  const ConnectionManagementScreen({Key? key}) : super(key: key);

  @override
  State<ConnectionManagementScreen> createState() => _ConnectionManagementScreenState();
}

class _ConnectionManagementScreenState extends State<ConnectionManagementScreen> {




  void acceptConnection(ConnectionObject connection) async {
    stamp("Accepting ${connection.getConnectionID()}");

    bool success = await MyFileInterface.acceptConnection(connection.getConnectionID());
    stamp("Acceptance status: $success");
    stamp("Data: ${await MyFileInterface.getConnectionsString()}");

    // Reload the screen to show changes
    setState(() {});

  }

  void deleteConnection(ConnectionObject connection) async {
    stamp("Deleting ${connection.getConnectionID()}");

    bool success = await MyFileInterface.deleteConnection(connection.getConnectionID());
    stamp("Acceptance status: $success");

    // Reload the screen to show changes
    setState(() {});
  }

  void updateScreen(){
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {

    // update callback
    MyBuffer.updateScreenCallback = updateScreen;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Connection management screen"),
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

                  // return SizedBox(
                  //   height: 300,
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.circular(15),
                  //     child: GlowingOverscrollIndicator(
                  //       axisDirection: AxisDirection.down,
                  //       color: Config.accent,
                  //       child: Container(
                  //         margin: EdgeInsets.all(30),
                  //         padding: EdgeInsets.all(10),
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(20),
                  //           color: Config.mainColor,
                  //         ),
                  //         child: ListView(
                  //             children: widgetList,
                  //           ),
                  //         ),
                  //     ),
                  //   ),
                  // );

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
                  return Text("An error occured while fetching data");
                } else {
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
