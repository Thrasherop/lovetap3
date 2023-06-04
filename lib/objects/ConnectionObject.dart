import 'package:lovetap3/misc/functions.dart';

class ConnectionObject {

    late String _connectionID;
    late String _targetEmail;
    late String _nickname;
    late bool _isActive;

    ConnectionObject.parseString(String rawString){

      /*

        Constructor for taking in a delimited string.

        Takes in a raw string of a connection. It needs
        to be delimited with "!!!".

        params::
          -- String rawString: The raw string of connection data

        return::
          -- ConnectionObject: the newly constructed object

      */


      List<String> parsed = rawString.split("!!!");
      _connectionID = parsed[0];
      _targetEmail = parsed[1];
      _nickname = parsed[2];


      if (parsed[3].contains("true")){
        _isActive = true;
      } else if (parsed[3].contains("false")){
        _isActive = false;
      } else {
        stampWTF("_IsActive is not true nor false on ConnectionObject $rawString");
      }

    }

    ConnectionObject.explicit(String connectionID, String targetEmail, String nickname, bool isActive){

      /*

        Constructor for explicit values.

        This is for explicitly initializing a new ConnectionObject. This means you are
        passing in each of the values as parameters.

        params::
          -- String connectionID: the connectionID for this connection
          -- String targetUser: the userID that messages will be sent to
          -- String targetEmail: the user email that messages will be sent to
          -- bool isActive: whether or not this connection is activated for the current user


        return::
          -- ConnectionObject: the newly created object

      */


      _connectionID = connectionID;
      _isActive = isActive;
      _targetEmail = targetEmail;
      _nickname = nickname;
    }

    String getTargetEmail(){
      return _targetEmail;
    }

    String getConnectionID(){
      return _connectionID;
    }

    String getNickname(){
      return _nickname;
    }


    bool isActive(){
      return _isActive;
    }

    void setActive(bool newStatus){
      _isActive = newStatus;
    }

    String toDataString(){
      // return "${getConnectionID()}!!!${getTargetUser()}!!!${getTargetEmail()}!!!${isActive().toString()}";
      stamp("Saving: ${getConnectionID()}!!!${getTargetEmail()}!!!${getNickname()}!!!${isActive().toString()}}");
      return "${getConnectionID()}!!!${getTargetEmail()}!!!${getNickname()}!!!${isActive().toString()}}";
    }

}