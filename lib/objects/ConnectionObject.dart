

import 'package:lovetap3/functions.dart';

class ConnectionObject {

    late String _connectionID;
    late String _targetUser;
    late bool _isActive;

    ConnectionObject.parseString(String rawString){
      List<String> parsed = rawString.split("!!!");
      _connectionID = parsed[0];
      _targetUser = parsed[1];

      if (parsed[2].toLowerCase() == "true"){
        _isActive = true;
      } else if (parsed[2].toLowerCase() == "false"){
        _isActive = false;
      } else {
        stampWTF("_IsActive is not true nor false on CoonnectionObject $rawString");
      }

    }

    ConnectionObject.direct(String connectionID, String targetUser, bool isActive){
      _connectionID = connectionID;
      _targetUser = targetUser;
      _isActive = isActive;
    }



    String getConnectionID(){
      return _connectionID;
    }

    String getTargetUser(){
      return _targetUser;
    }

    bool isActive(){
      return _isActive;
    }

}