import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lovetap3/interfaces/MyFileInterface.dart';
import 'package:lovetap3/objects/MyNullObject.dart';

import '../objects/ConnectionObject.dart';


class ConnectionManagementScreen extends StatefulWidget {
  const ConnectionManagementScreen({Key? key}) : super(key: key);

  @override
  State<ConnectionManagementScreen> createState() => _ConnectionManagementScreenState();
}

class _ConnectionManagementScreenState extends State<ConnectionManagementScreen> {
  @override
  Widget build(BuildContext context) {

    // Build the list of connections
    // Map<String, ConnectionObject> connectionsMap =
    // MyFileInterface.getConnections().then((value){
    //  
    // });

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

                  List<ConnectionObject> dataList= <ConnectionObject>[];

                  // Convert it into a list
                  dataMap.forEach((key, value) {
                    dataList.add(value);
                  });

                  List<String> quotes = [
                    "quote1",
                    "quote2",
                    "quote3",
                  ];

                  return SizedBox(
                    height: 500,
                    child: Scaffold(
                      body:  Column(
                          children: dataList.map((quote) {

                            Widget finalWidget = Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(quote.getTargetEmail())
                              ],
                            );

                            return finalWidget;

                            return Text(quote.getConnectionID());
                          }).toList(),
                        ),
                      )
                  );

                  return Column(
                    // children: dataList.map((e) => {
                    //   return Text("foo");
                    // }).toList(),
                  );

                  return Text("Data recieved: ${snapshot.data}");
                } else if (snapshot.hasError){
                  return Text("An error occured while fetching data");
                } else {
                  return Text("Loading connection data...");
                }

              },

              future: MyFileInterface.getConnections()
            )
          ],
        ),
      ),
    );
  }
}
