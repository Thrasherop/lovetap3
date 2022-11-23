import 'package:lovetap3/misc/functions.dart';

class ConnectionObject {

    late String _connectionID;
    late String _targetUser;
    late String _targetEmail;
    late bool _isActive;

    ConnectionObject.parseString(String rawString){
      List<String> parsed = rawString.split("!!!");
      _connectionID = parsed[0];
      _targetUser = parsed[1];
      _targetEmail = parsed[2];

      if (parsed[3].toLowerCase() == "true"){
        _isActive = true;
      } else if (parsed[3].toLowerCase() == "false"){
        _isActive = false;
      } else {
        stampWTF("_IsActive is not true nor false on CoonnectionObject $rawString");
      }

    }

    ConnectionObject.explicit(String connectionID, String targetUser, String targetEmail, bool isActive){
      _connectionID = connectionID;
      _targetUser = targetUser;
      _isActive = isActive;
      _targetEmail = targetEmail;
    }

    String getTargetEmail(){
      return _targetEmail;
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

    void setActive(bool newStatus){
      _isActive = newStatus;
    }

    String toDataString(){
      return "${getConnectionID()}!!!${getTargetUser()}!!!${getTargetEmail()}!!!${isActive().toString()}";
    }

}