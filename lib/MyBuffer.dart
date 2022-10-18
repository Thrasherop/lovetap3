import 'package:lovetap3/Config.dart';

class MyBuffer {
  /*
    This class is simply used for centralized data handling between objects.
    All attributes should be static
   */

  static String currentTargetDestination = Config.DESTINATION_OPTIONS[0].value;
  static late String? currentToken;

  static late dynamic signinFunction;


}
