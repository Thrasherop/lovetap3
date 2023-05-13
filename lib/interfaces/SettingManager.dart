import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lovetap3/interfaces/MyFileInterface.dart';
import 'package:lovetap3/interfaces/MyFirebaseInterface.dart';

import '../enums/PriorityEnum.dart';
import '../misc/Config.dart';
import '../misc/functions.dart';

import 'package:lovetap3/misc/functions.dart';

class SettingManager {

  // various settings
  // static PriorityEnum messagePriority = PriorityEnum.HIGH; // default HIGH

  static Map<String, Object> _settingsMap = {
    "messagePriority": PriorityEnum.HIGH,
    "theme": "light",
  };

  // Set the default colorArray to light mode.
  static late MaterialColor colorArray;

  static Future<void> initialize() async {

    // gets settings from MyFileInterface
    String rawStr = (await MyFileInterface.getValue("settings")).toString();

    stamp("Rawstr: $rawStr");
    List<String> settingsList = rawStr.split("!!!");
    stamp("list: ${settingsList.toString()}");

    try {
      _settingsMap["messagePriority"] = PriorityEnum.values.firstWhere((e) => e.toString() == settingsList[0]);

      // Set the theme
      _settingsMap['theme'] = await MyFileInterface.getValue("theme");
      _updateAppTheme(_settingsMap['theme'] as String); // update the config
    } catch (e){
      /*
         TODO: Have this callback to the server to get the setting. Only if that also
          fails should we set it to the default. Also make the try catch more specific
          so that we can handle errors elsewhere.
       */

      // Assign the default
      stampE("Failed to initialize messagePriority: ${e.toString()}. Defaulting to high");
      _settingsMap["messagePriority"] = PriorityEnum.HIGH;

    }

    // Get the theme data & call the update function
    String theme = (await MyFileInterface.getValue("theme")).toString();
    _updateAppTheme(theme);

  }

  static void saveAll() async {
    String settingsStr = "";
    settingsStr += _settingsMap["messagePriority"].toString();

    await MyFileInterface.setValue("settings", settingsStr);
    await MyFileInterface.setValue("theme", _settingsMap['theme'] as String);
    stamp("SaveAll completed");
  }

  static void updateValue(String key, Object value) async {

    stamp("Updating settings value $key to $value");

    // Checks special case for messagePriority
    if (key == "messagePriority") {

      if (value is! PriorityEnum) {
        stampWTF("ERROR: updateSetting with $key (detected messagePriority) does not have a PriorityEnum input: $value");
      } else {
        _settingsMap[key] = value;

        // Makes firebase call
        stamp("Attempting to update Firebase preference...");
        stamp("Result: ${await MyFirebaseInterface.setPriority(value)}"); // TODO: Do something if this fails
      }

    } else if (key == "theme"){
      // Calls _updateAppTheme logic if we want to set theme
      _updateAppTheme(value as String);
    }
  }

  static Object? getSetting(String key){
    return _settingsMap[key];
  }

  static String getString() {
    String finalStr = "";

    finalStr += _settingsMap["messagePriority"].toString();

    return finalStr;
  }

  static void _updateAppTheme (String newTheme){

    /*

      Update the app theme. This includes changing _settingsMap, colorArray,
      and updating the local database

     */

    _settingsMap['theme'] = newTheme;

    // Update the colorArray
    if (newTheme == "dark"){

      colorArray = MaterialColor(0xFF343A40, const <int, Color>{
        1: Color(0xFF1B1B1B), // Primary color
        2: Color(0xFFE8F4F6), // Secondary color
        3: Color(0xFF111111), // Alternative Primary
        // 4: Color(0xFF8E7980), //
        400: Color(0xFFf53325), // Red
        500: Color(0xFFFFFFFF)
      });

    } else { // Default to light
      colorArray = MaterialColor(0xFF343A40, const <int, Color>{
        1: Color(0xFFee578a), // Primary color
        2: Color(0xFFFFF3F9), // Secondary color
        3: Color(0xFFe35281), // Alternative primary
        400: Color(0xFF8800FF),
        500: Color(0xFF41fc03),
        // 500: Color(0xFFdcb5ff)
      });
    }
    
    // Update the database
    MyFileInterface.setValue("theme", newTheme).catchError((error, stackTrace) {
      /*
        TODO: Handle this more gracefully
       */
      stampE("SettingManager: Failed to safe theme to local database: $error, stacktrace: $stackTrace");
      return false;
    });

  }

}