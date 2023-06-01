import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lovetap3/enums/PriorityEnum.dart';
import 'package:lovetap3/interfaces/MyFileInterface.dart';
import 'package:lovetap3/misc/MyBuffer.dart';

import '../interfaces/SettingManager.dart';
import '../misc/functions.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  bool darkMode = SettingManager.getSetting("theme") == "dark";

  void updateSetting(String settingKey, Object newValue) async {
    stamp("New value: $newValue");

    // Checks special case for messagePriority
    if (settingKey == "messagePriority") {
      if (newValue is! bool) {
        stampWTF("ERROR: updateSetting with $settingKey (detected messagePriority) does not have a bool input: $newValue");
      } else if (!newValue) {
        SettingManager.updateValue(settingKey, PriorityEnum.LOW);
      } else {
        SettingManager.updateValue(settingKey, PriorityEnum.HIGH);
      }
    } else if (settingKey == "theme") {
      // Updates the theme
      if (newValue == true){
        stamp("Switching to dark mode");
        // await MyFileInterface.setValue("theme", "dark");
        // Settings.updateValue("theme", "light");
        SettingManager.updateValue("theme", "dark");
        darkMode = true; // update the attribute to display
      } else {
        stamp("Switching to light mode");
        // await MyFileInterface.setValue("theme", "light");
        SettingManager.updateValue("theme", "light");
        darkMode = false; // update the attribute to display

      }
    }

    // update screen
    setState(() {});

    // save the new changes
    SettingManager.saveAll();

    stamp("After saving: ${await MyFileInterface.getValue("theme")}");
  }

  @override
  void dispose(){

    // Run the update for the home screen
    MyBuffer.runLastScreenCallback();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // Parses the current settings
    bool forceDeliver = SettingManager.getSetting("messagePriority") == PriorityEnum.HIGH;


    if (MyFileInterface.getValue("theme").toString() == "dark") {
      stamp("Dark mode detectd");
      darkMode = true;
    } else if (MyFileInterface.getValue("theme").toString() == "light") {
      stamp("light mode detected");
      darkMode = false;
    }

    stamp("Build: Mode $darkMode");

    return
      Scaffold(

        backgroundColor: SettingManager.colorArray[1],

        body: SafeArea (
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.center,

              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Force deliver messages immediately: ",
                      style: TextStyle(
                        color: SettingManager.colorArray[2]
                      ),
                    ),
                    Switch(
                      value: forceDeliver,
                      onChanged: (bool newValue) => updateSetting("messagePriority", newValue),
                      activeColor: SettingManager.colorArray[3],
                      activeTrackColor: SettingManager.colorArray[5],
                      inactiveThumbColor: SettingManager.colorArray[3],
                      inactiveTrackColor: SettingManager.colorArray[6],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Dark mode: ",
                      style: TextStyle(
                          color: SettingManager.colorArray[2]
                      ),
                    ),
                    Switch(
                      value: darkMode,
                      onChanged: (bool newValue) => updateSetting("theme", newValue),
                      activeColor: SettingManager.colorArray[3],
                      activeTrackColor: SettingManager.colorArray[5],
                      inactiveThumbColor: SettingManager.colorArray[3],
                      inactiveTrackColor: SettingManager.colorArray[6],
                    )
                  ],
                )

              ],
            ),
          ),
        ),
    );
  }
}
