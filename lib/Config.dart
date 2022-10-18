import 'package:flutter/material.dart';

class Config {

  // Routing configs
  static const String CONNECTION_FAILED_SCREEN = "/connection_failed";

  // General configs
  static const int SNACKBAR_TIMEOUT = 3000; // ms of how long to keep snackbars on the screen

  // Configs for package
  static const int PACKAGE_TIMEOUT = 4000; // This is the time delay before sending a package. This is in ms
  static const String DATA_MAP = "pattern";
  static const String PATTERN_DELIMETER = "!!!";
  static const String TARGET_MAP = "to";
  static const String ORIGIN_MAP = "from";

  // Tap interface configs
  static const List<DropdownMenuItem> DESTINATION_OPTIONS = [
    DropdownMenuItem(child: Text("S20"), value: "f9rPh2m5Qm-PQUz1gxPXSn:APA91bHcvIQgtJGn6N-FrXMyITZcc4wOeyTAl8Abi92e35laKcwkbO_g1diOVdTbX49sG8k9G1hk8_qXyD4YXDRHdZmTn93yQEcfi-4n0K9hOuiEpyZF8ul7x6ZKohO80oZO4j9dvhGY"),
    DropdownMenuItem(child: Text("S8"), value: "c7u2JBSHSF6zSeYRCFYvWS:APA91bHZ15FelfNe-Qdsi-L7ntwIjSEduTnE5aMlqyGB_anNSpzKheXEki8W8FumZ4CZX2LkxXPtkxQB5GArzh6Gt2UeE6bAk5wmK9mKn2rjJKXnENs_Xq6CNBqwx1Jh3ODYcGYnJn3m"),
    DropdownMenuItem(child: Text("Oneplus"), value: "cNLYK6OaTneHdF2jnN3_Ph:APA91bHXCOeOcoMDlCsZZYCqSQAzDsii3EBpzJxNuPIFTCTj8GGYJxshxqyCj2t02kbY9pLl5qbzIkWWe0rizErHh6_YpQ-F8AGkyMjPIg3qbgwIXZJemQrhyEbCXUNSMm4soXAT0adC"),
  ];

  // Firebase organization configs
  static const String USER_SEND_COLLECTION = "sending";


  // Configs for demoing
  static const String DEMO_USER_NAME = "demoUser";


}