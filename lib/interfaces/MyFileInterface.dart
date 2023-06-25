import 'package:lovetap3/misc/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SettingManager.dart';
import '../objects/ConnectionObject.dart';
import '../objects/MyNullObject.dart';

class MyFileInterface {
  /*
   This class is for interfacing with the local client
   database. Through these functions you can do CRUD
   operations on connection data.
   */


  late SharedPreferences data;


  static Future<Object> getValue(String key) async {

    /*
     Get the value at "key" from local database.

     params::
       -- String key: the hashmap key for the element

     return::
       -- Future<Object>: the object stored at "key"
     */

    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(key)){
      return MyNullObject();
    }
    
    // Try reading data from the counter key. If it doesn't exist, return 0.
    final data = prefs.get(key) ?? 0;
    return data;
  }

  static Future<List<String>> getStringList(String key) async {

    /*
     Gets a string list of all the elements in "key". For example,
     the key "connections" will give the raw string data for all
     the connections
     */

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

  // static Future<Map<String, String>> loadSettings() async {
  //
  //
  //   String rawStr = (await getValue("settings")).toString();
  //
  //   stamp("Raw string: $rawStr");
  //
  //   Settings.initialize(rawStr);
  //
  //   return {"s":"a"};
  // }
  //
  // static Future<bool> saveSettings() async {
  //   // make it possible to save settings. Then work to get settings. Then make the settings UI
  //
  //   await setValue("settings", Settings.getString());
  //
  //   return true;
  // }

  static Future<bool> deleteAllConnections() async {
    /*
     WARNING: Very dangerous method. This will delete
     all the connection data on the client device.
     Only use this for debugging.
     */

    setValue("connections", <String>[]);
    return true;
  }

  static Future<bool> deleteConnection(String connectionID) async {

    /*
     Delete a single, specific connection from local database.

     params::
       -- String connectionID: the ID of the connection to delete

     return::
       -- Future<bool>: whether the delete was successful or not
     */

    /*
      TODO: Send request to the server to remove self
          from connection
     */


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

    setValue("connections", updatedArray);

    // TODO: Save the original connections if this fails

    return true;
  }

  static Future<bool> acceptConnection(String connectionID) async {

    /*
     Accepts the connection with connectionID string

     params::
       -- String connectionID: The connection ID to accept

     return::
       -- Future<bool>: Whether the operation was successful
     */

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

    updateConnection(targetConnection);

    return true;

  }

  static Future<bool> updateConnection(ConnectionObject connection) async {

    /*
     Updates a connection. It takes in a ConnectionObject. It uses the ID of this
     connection object to update that same connection in the local database.

     params::
       -- ConnectionObject connection: the new connection object

     return::
       -- Future<bool>: Whether or not the operation was successful
     */

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

    setValue("connections", updatedArray);

    // TODO: Save the original connections if this fails

    return true;
  }

  static Future<bool> setValue(String key, Object value) async{

    /*
     Sets a value in the database.

     params::
       -- String key: The hashmap key to assign value
       -- Object value: The value to put into the database

     return::
       -- Future<bool>: Whether or not the operation was successful
     */

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
    }

    // return true for success
    return true;
  }

  static Future<bool> addConnection(ConnectionObject newConnection) async {
    /*

     Adds a new connection to the local database.

     params::
       -- ConnectionObject newConnection: The new connection to add

     return::
       -- Future<bool>: Whether or not the operation was successful

     */

    // fetch the data
    List<String> dataArray = await getStringList("connections");

    // Append new connection data, and update database
    dataArray.add(newConnection.toDataString());
    stamp("Saving new connection: ${newConnection.toDataString()}. Existing list was: ${dataArray.toString()}");
    setValue("connections", dataArray);

    stamp("New list is ${await getStringList("connection")}");

    return true;
  }
  
  static Future<Map<String, ConnectionObject>> getConnections() async {

    /*
     Gets a hashmap of all the connections in the local database.

     params::
       -- None

     return::
       -- Future<Map<String, ConnectionObject>>: A future of the connection map; the key is connection ID
     */

    List<String> dataArray = await getStringList("connections");

    // Parse the string into the ConnectionObject's
    Map<String, ConnectionObject> connections = {};
    for (String thisString in dataArray){
       ConnectionObject thisConnection = ConnectionObject.parseString(thisString);
       connections[thisConnection.getConnectionID()] = thisConnection;
    }

    return connections;
  }

  static Future<List<String>> getConnectionsString() async {

    /*
     Gets the connection data as raw strings

     params::
       -- None

     return::
       -- Future<List<String>>: List of raw connection strings
     */

    List<String> stringList = <String>[];

    (await getConnections()).forEach((key, value) {
      stringList.add(value.toDataString());
    });

    return stringList;

  }

  static Future<bool> hasNewRequests() async {

    // loop through all connections and check for an inactive one
    Map<String, ConnectionObject> connections = await getConnections();
    for (ConnectionObject thisConn in connections.values){
      // stamp("Checking ${thisConn.toDataString()}");
      if (!thisConn.beenSeen()){
        return true;
      }
    }

    // No inactive connections so return true
    return false;
  }

  static Future<void> printConnections() async {

  }

  static Future<bool> setRequestsAsRead() async {
    // loop through all connections and check for an inactive one
    Map<String, ConnectionObject> connections = await getConnections();
    // stamp("Number of connections ${connections.length}");
    for (ConnectionObject thisConn in connections.values) {
      if (!thisConn.beenSeen()){
        // Update and save the connection
        thisConn.setBeenSeen(true);
        updateConnection(thisConn);
      }
    }


    // No inactive connections so return true
    return false;
  }
}