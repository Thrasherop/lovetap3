import 'package:lovetap3/Config.dart';
import 'package:lovetap3/pages/ConnectionManagementScreen.dart';

class MyBuffer {
  /*
    This class is simply used for centralized data handling between objects.
    All attributes should be static
   */

  static String currentTargetDestination = Config.DESTINATION_OPTIONS[0].value;
  static late String? currentToken;

  static late dynamic signinFunction;

  static late String userID;


  /*
   * This is used to update the screen.
   * For example, the ConnectionManagementScreen assigns its "updateScreen()" function
   * to this when it is initialized. This is so that when a new connection request comes
   * in from FCM the screen is automagically updated with the new data.
   */
  static late Function updateScreenCallback;


}
