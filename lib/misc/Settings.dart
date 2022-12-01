import 'package:lovetap3/interfaces/MyFileInterface.dart';
import 'package:lovetap3/interfaces/MyFirebaseInterface.dart';

import '../enums/PriorityEnum.dart';
import 'functions.dart';

class Settings {

  // various settings
  // static PriorityEnum messagePriority = PriorityEnum.HIGH; // default HIGH

  static Map<String, Object> _settingsMap = {
    "messagePriority": PriorityEnum.HIGH,
  };

  static Future<void> initialize() async {

    // gets settings from MyFileInterface
    String rawStr = (await MyFileInterface.getValue("settings")).toString();

    stamp("Rawstr: $rawStr");
    List<String> settingsList = rawStr.split("!!!");
    stamp("list: ${settingsList.toString()}");

    try {
      _settingsMap["messagePriority"] = PriorityEnum.values.firstWhere((e) => e.toString() == settingsList[0]);
    } catch (e){
      /*
         TODO: Have this callback to the server to get the setting. Only if that also
          fails should we set it to the default. Also make the try catch more specific
          so that we can handle errors elsewhere.
       */

      // Assign the default
      stampE("Failed to initialize messagePriority: ${e.toString()}");
      _settingsMap["messagePriority"] = PriorityEnum.HIGH;

    }

    stamp("Parsed messagePriority: ${_settingsMap["messagePriority"]}");

  }

  static void saveAll() async {
    String settingsStr = "";
    settingsStr += _settingsMap["messagePriority"].toString();

    await MyFileInterface.setValue("settings", settingsStr);
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

}