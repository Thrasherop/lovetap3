import 'dart:ffi';

import 'package:lovetap3/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../objects/ConnectionObject.dart';
import '../objects/MyNullObject.dart';

class MyFileInterface {

  late SharedPreferences data;


  static Future<Object> getValue(String key) async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(key)){
      return MyNullObject();
    }
    
    // Try reading data from the counter key. If it doesn't exist, return 0.
    final counter = prefs.get(key) ?? 0;
    return counter;
  }

  static Future<List<String>> getStringList(String key) async {

    dynamic rawData = await getValue(key);
    List<String> dataArray = <String>[];

    if (rawData.runtimeType == MyNullObject){
      dataArray = <String>[]; // Initialize empty string list if there is no connection data
    } else {

      // raw_data is of type List<Object?>. This iterates to cast each item as a string and puts it in data array
      for (Object thisItem in rawData){
        dataArray.add(thisItem as String);
      }
    }

    return dataArray;
  }

  static Future<bool> deleteAllConnections() async {
    setValue("connections", <String>[]);
    return true;
  }

  static Future<bool> deleteConnection(String connectionID) async {
    Map<String, ConnectionObject> allConnections = await getConnections();
    List<String> updatedArray = <String>[];

    allConnections.forEach((key, value) {

      if (value.getConnectionID() == connectionID){
        // Do nothing: we don't want to write this connection
      } else {
        // Write this value
        updatedArray.add(value.toDataString());
      }

    });

    // dataArray.add("${newConnection.getConnectionID()}!!!${newConnection.getTargetUser()}!!!${newConnection.getTargetEmail()}!!!${newConnection.isActive().toString()}");
    // stamp("Dataarray: ${dataArray.toList()}");
    setValue("connections", updatedArray);

    // TODO: Safe the original connections if this fails

    return true;
  }

  static Future<bool> acceptConnection(String connectionID) async {

    Map<String, ConnectionObject> allConnections = await getConnections();

    if (!allConnections.containsKey(connectionID)){
      // We don't have that connection, so something is wrong
      stampE("Failed to accept connection $connectionID: It does not exist}");
      return false;
    } else if (allConnections[connectionID] == null){
      stampE("Failed to accept connection $connectionID: Connection null}");
      return false;
    }

    ConnectionObject targetConnection = allConnections[connectionID]!;
    targetConnection.setActive(true);

    stamp("updated object: ${targetConnection.toDataString()}");

    _updateConnection(targetConnection);

    return true;

  }

  static Future<bool> _updateConnection(ConnectionObject connection) async {

    Map<String, ConnectionObject> allConnections = await getConnections();
    List<String> updatedArray = <String>[];

    allConnections.forEach((key, value) {

      if (value.getConnectionID() == connection.getConnectionID()){
        // Update that connection by writing the new one, not old
        updatedArray.add(connection.toDataString());
      } else {
        // Write this value
        updatedArray.add(value.toDataString());
      }

    });

    // dataArray.add("${newConnection.getConnectionID()}!!!${newConnection.getTargetUser()}!!!${newConnection.getTargetEmail()}!!!${newConnection.isActive().toString()}");
    // stamp("Dataarray: ${dataArray.toList()}");
    setValue("connections", updatedArray);

    // TODO: Save the original connections if this fails

    return true;
  }

  static Future<bool> setValue(String key, Object value) async{

    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();


    // Checks the type, and uses the appropriate SharePreferences method
    if (value.runtimeType == 1.runtimeType){
      await prefs.setInt(key, value as int);
    } else if (value.runtimeType == "".runtimeType){
      await prefs.setString(key,  value as String);
    } else if (value.runtimeType == true.runtimeType){
      await prefs.setBool(key,  value as bool);
    } else if (value.runtimeType == (1.2).runtimeType){
      await prefs.setDouble(key, value as double);
    } else if (value.runtimeType == ["a","b"].runtimeType){
      await prefs.setStringList(key, value as List<String>);
    } else {
      stampE("That type is not supported");
      throw ("Invalid value passed into setValue");
      return false;
    }

    return true;

  }

  static Future<bool> addConnection(ConnectionObject newConnection) async {

    List<String> dataArray = await getStringList("connections");
    // dataArray.add("${newConnection.getConnectionID()}!!!${newConnection.getTargetUser()}!!!${newConnection.getTargetEmail()}!!!${newConnection.isActive().toString()}");
    dataArray.add(newConnection.toDataString());
    stamp("Dataarray: ${dataArray.toList()}");
    setValue("connections", dataArray);

    return true;
  }
  
  static Future<Map<String, ConnectionObject>> getConnections() async {

    List<String> dataArray = await getStringList("connections");

    Map<String, ConnectionObject> connections = {};

    for (String thisString in dataArray){
       ConnectionObject thisConnection = ConnectionObject.parseString(thisString);
       connections[thisConnection.getConnectionID()] = thisConnection;
    }

    return connections;
  }

  static Future<List<String>> getConnectionsString() async {

    List<String> stringList = <String>[];

    (await getConnections()).forEach((key, value) {
      stringList.add(value.toDataString());
    });

    return stringList;

  }






}