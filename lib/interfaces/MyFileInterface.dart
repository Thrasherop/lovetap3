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
    dataArray.add("${newConnection.getConnectionID()}!!!${newConnection.getTargetUser()}!!!${newConnection.getTargetEmail()}!!!${newConnection.isActive().toString()}");
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





}