import 'package:flutter/material.dart';

class Config {

  /*
      Holds configuration data for the app.

      This is so that all configuration is held in one
      location. This makes it easy to find variables.

     */

  // General configs
  static const int SNACKBAR_TIMEOUT = 3000; // ms of how long to keep snackbars on the screen

  // Configs for package
  static const int PACKAGE_TIMEOUT = 3000; // This is the time delay before sending a package. This is in ms
  static const String PACKAGE_DATA_MAP = "pattern";
  static const String PATTERN_DELIMETER = "!!!";
  static const String TARGET_MAP = "to";
  static const String ORIGIN_MAP = "from";
  static const String CONNECTION_ID_MAP = "connectionID";

  // Default value
  static List<DropdownMenuItem> DESTINATION_OPTIONS = [
    DropdownMenuItem(child: Text("S20-S20"), value: "tagO7nMVdwGSqRoRrETW"),
    DropdownMenuItem(child: Text("S8 (token)"), value: "c7u2JBSHSF6zSeYRCFYvWS:APA91bHZ15FelfNe-Qdsi-L7ntwIjSEduTnE5aMlqyGB_anNSpzKheXEki8W8FumZ4CZX2LkxXPtkxQB5GArzh6Gt2UeE6bAk5wmK9mKn2rjJKXnENs_Xq6CNBqwx1Jh3ODYcGYnJn3m"),
    DropdownMenuItem(child: Text("Oneplus (token)"), value: "cNLYK6OaTneHdF2jnN3_Ph:APA91bHXCOeOcoMDlCsZZYCqSQAzDsii3EBpzJxNuPIFTCTj8GGYJxshxqyCj2t02kbY9pLl5qbzIkWWe0rizErHh6_YpQ-F8AGkyMjPIg3qbgwIXZJemQrhyEbCXUNSMm4soXAT0adC"),

  ];

  // Firebase organization configs
  static const String USER_SEND_COLLECTION = "sending";


  // Configs for demoing
  static const String DEMO_USER_NAME = "demoUser";


  // Colors
  static const MaterialColor mainColor = Colors.blue;
  static const MaterialColor secondaryColor = Colors.red;
  static const MaterialColor accent = Colors.pink;

  // Home screen
  static const String DEFAULT_PROFILE_PICTURE = "https://www.google.com/url?sa=i&url=https%3A%2F%2Fpowerusers.microsoft.com%2Ft5%2Fmedia%2Fgallerypage%2Fimage-id%2F98171iCC9A58CAF1C9B5B9&psig=AOvVaw1K8_lA5ZgMWsYmtuLjiqCQ&ust=1668821492316000&source=images&cd=vfe&ved=0CA4QjRxqFwoTCOCG1dLKtvsCFQAAAAAdAAAAABAE";


}