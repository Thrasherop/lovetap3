import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lovetap3/enums/PriorityEnum.dart';

import '../misc/Settings.dart';
import '../misc/functions.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  void updateSetting(String settingKey, Object newValue) {
    // Checks special case for messagePriority
    if (settingKey == "messagePriority") {
      if (newValue is! bool) {
        stampWTF("ERROR: updateSetting with $settingKey (detected messagePriority) does not have a bool input: $newValue");
      } else if (!newValue) {
        Settings.updateValue(settingKey, PriorityEnum.LOW);
      } else {
        Settings.updateValue(settingKey, PriorityEnum.HIGH);
      }

    }

    // update screen
    setState(() {});

    // save the new changes
    Settings.saveAll();
  }


  @override
  Widget build(BuildContext context) {

    // Parses the current settings
    bool forceDeliver = Settings.getSetting("messagePriority") == PriorityEnum.HIGH;

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
                children: [Text("Force deliver messages immediately: "), Switch(value: forceDeliver, onChanged: (bool newValue) => updateSetting("messagePriority", newValue))],
              )

            ],
          ),
        ),
      ),
    );
  }
}
