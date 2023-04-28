import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lovetap3/enums/PriorityEnum.dart';
import 'package:lovetap3/interfaces/MyFileInterface.dart';

import '../misc/Settings.dart';
import '../misc/functions.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  bool darkMode = false;

  void updateSetting(String settingKey, Object newValue) async {
    stamp("New value: $newValue");

    // Checks special case for messagePriority
    if (settingKey == "messagePriority") {
      if (newValue is! bool) {
        stampWTF("ERROR: updateSetting with $settingKey (detected messagePriority) does not have a bool input: $newValue");
      } else if (!newValue) {
        Settings.updateValue(settingKey, PriorityEnum.LOW);
      } else {
        Settings.updateValue(settingKey, PriorityEnum.HIGH);
      }
    } else if (settingKey == "theme") {
      // Updates the theme
      if (newValue == true){
        stamp("Switching to dark mode");
        // await MyFileInterface.setValue("theme", "dark");
        Settings.updateValue("theme", "dark");
        darkMode = true; // update the attribute to display
      } else {
        stamp("Switching to light mode");
        // await MyFileInterface.setValue("theme", "light");
        Settings.updateValue("theme", "light");
        darkMode = false; // update the attribute to display

      }
    }

    // update screen
    setState(() {});

    // save the new changes
    Settings.saveAll();

    stamp("After saving: ${await MyFileInterface.getValue("theme")}");
  }


  @override
  Widget build(BuildContext context) {

    // Parses the current settings
    bool forceDeliver = Settings.getSetting("messagePriority") == PriorityEnum.HIGH;


    // stamp()

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
      body: SafeArea (
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.center,

            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Force deliver messages immediately: "), Switch(value: forceDeliver, onChanged: (bool newValue) => updateSetting("messagePriority", newValue)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Dark mode: "), Switch(value: darkMode, onChanged: (bool newValue) => updateSetting("theme", newValue))
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}
