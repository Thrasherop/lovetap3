import 'package:flutter/material.dart';
import 'package:lovetap3/interfaces/MyFileInterface.dart';

import '../objects/MyNullObject.dart';
import 'functions.dart';

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
  // static const MaterialColor mainColor = Colors.blue;
  static const MaterialColor primaryColorDarkmodeArray = MaterialColor(0xFF343A40, <int, Color>{
      50: Color(0xFFE5E5E5),
      100: Color(0xFFBDBDBD),
      200: Color(0xFF9E9E9E),
      300: Color(0xFF757575),
      400: Color(0xFF616161),
      500: Color(0xFF424242),
      600: Color(0xFF373737),
      700: Color(0xFF303030),
      800: Color(0xFF282828),
      900: Color(0xFF1B1B1B),
  });

  static const MaterialColor secondaryColorDarkmodeArray = MaterialColor(0xFFDBAFC3, <int, Color>{
    50: Color(0xFFE8F4F6),
    100: Color(0xFFCFDFE4),
    200: Color(0xFFB4D2D6),
    300: Color(0xFF99C4C8),
    400: Color(0xFF87B8BE),
    500: Color(0xFF75ABB4),
    600: Color(0xFF6D9FAE),
    700: Color(0xFF6694A8),
    800: Color(0xFF5E8AA2),
    900: Color(0xFF4F7B98),
  });

  static Color primaryColorDarkMode = primaryColorDarkmodeArray[900]!;
  static Color secondaryColorDarkMode = secondaryColorDarkmodeArray[50]!;

  static Color primaryColorLightMode = Color(0xFFee578a);
  // static Color secondaryColorLightMode = Color(0xFFFFF3F9);
  // static Color secondaryColorLightMode = Color(0xFFedd08a);
  static Color secondaryColorLightMode = Color(0xFF241E10);


  static Color primaryColor = primaryColorDarkMode;
  static Color secondaryColor = secondaryColorDarkMode; // 50 was the white
  static const MaterialColor accent = Colors.pink;

  // Home screen
  static const String DEFAULT_PROFILE_PICTURE = "https://www.google.com/url?sa=i&url=https%3A%2F%2Fpowerusers.microsoft.com%2Ft5%2Fmedia%2Fgallerypage%2Fimage-id%2F98171iCC9A58CAF1C9B5B9&psig=AOvVaw1K8_lA5ZgMWsYmtuLjiqCQ&ust=1668821492316000&source=images&cd=vfe&ved=0CA4QjRxqFwoTCOCG1dLKtvsCFQAAAAAdAAAAABAE";

  static void init() async {

    Object theme = await MyFileInterface.getValue("theme");

    if (theme is MyNullObject){
      // Set default
      MyFileInterface.setValue("theme", "light");

    } else if (theme == "dark"){
      primaryColor = primaryColorDarkMode;
      secondaryColor = secondaryColorDarkMode;
    } else if (theme == "light") {
      primaryColor = primaryColorLightMode;
      secondaryColor = secondaryColorDarkMode;
    }

  }
  

}