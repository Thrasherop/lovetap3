import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lovetap3/interfaces/MyAuthenticator.dart';
import 'package:lovetap3/interfaces/MyFileInterface.dart';
import 'package:lovetap3/objects/ConnectionObject.dart';
import 'package:lovetap3/objects/MyNullObject.dart';

import '../misc/Config.dart';
import '../misc/MyBuffer.dart';
import '../objects/OutgoingPackage.dart';
import '../misc/functions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  TextStyle hamburgerTextStyle = TextStyle(
    // color: Config.primaryColor,
    color: Colors.blue,
    fontStyle: FontStyle.italic

  );

  late OutgoingPackage curPackage = OutgoingPackage.PlaceHolder();

  List<DropdownMenuItem> destinationOptions = <DropdownMenuItem>[DropdownMenuItem(child: Text("Loading..."), value: "Loading...")];
  late String _selectedDestination;// = MyNullObject().toString();//Config.DESTINATION_OPTIONS[0].value;

  @override
  void initState(){
    super.initState();
    _selectedDestination = destinationOptions[0].value;

    // Push our updateList() callback onto MyBuffer.updateScreenCallback stack.
    MyBuffer.updateScreenCallback.insert(0, updateList);


    // Initialize the list, but delayed to ensure the screen has been created
    Future.delayed(Duration(milliseconds: 100), updateList);

  }


  void updateList() async {

    await _updateDestinationOptions();

    if (destinationOptions.isEmpty){
      destinationOptions = <DropdownMenuItem>[DropdownMenuItem(child: Text("No connections"), value: "No connections")];
    }
    _selectedDestination = destinationOptions[0].value;
    setState(() {});

  }

  Future<void> _updateDestinationOptions() async {

    // Fetch connection information & add to newDestinationOptions
    Map<String, ConnectionObject> connectionsMap = (await MyFileInterface.getConnections());

    List<DropdownMenuItem> newDestinationOptions = <DropdownMenuItem>[];
    connectionsMap.forEach((key, value) {
      if (value.isActive()) {
        // Add the value IF its active
        // This is the style for the individual items
        newDestinationOptions.add(DropdownMenuItem(
            value: value.getConnectionID(),
            child: Text(
                value.getTargetEmail(),
                style: TextStyle(
                  color: Config.secondaryColor,
                  fontSize: 16,
                ),
            ),
        ));
      }
    });

    // overwrite the old destination options
    destinationOptions = newDestinationOptions;
    Config.DESTINATION_OPTIONS = destinationOptions;

  }

  void _press(TapDownDetails event){
    /*
      This method is called when the button is pressed. It
      then processes it by first initializing a valid Package
      object (if curPackage is invalid), then by calling
      curPackage.press()
     */

    // Create a new package if the current one has timed out
    // This is why we need Packages of PlaceHolder type


    if (curPackage.isPlaceHolder() || curPackage.hasTimedOut()){
      curPackage = OutgoingPackage();
    }

    curPackage.press();
  }

  void _release(TapUpDetails event){

    /*
      This registers when the tap button is released. This
      merely calls curPackage.release()
     */

    curPackage.release();
  }

  void _destinationChanged(newValue){

    if (newValue is String){
      setState(() {
        stamp("New target destination is $newValue");

        // Updates target in buffer
        MyBuffer.currentTargetDestination = newValue;

        _selectedDestination = newValue;
      });
    }

  }

  @override
  Widget build(BuildContext context) {

    _updateDestinationOptions();

    stamp("primary: ${Config.primaryColor}");

    return MaterialApp(
      
      home: Container(

        color: Config.primaryColor,

        child: Scaffold (
          backgroundColor: Colors.transparent, // transparent to show background of container
          endDrawer: Drawer(
            /*
              This is the layout for the drawer.
             */
            child: Container(
              color: Config.primaryColor,

              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(FirebaseAuth.instance.currentUser?.photoURL ?? Config.DEFAULT_PROFILE_PICTURE),
                          fit: BoxFit.cover,
                      ),
                    ),
                    child: Text(''),
                  ),
                  ListTile(
                    title: Text('Manage Connections', style: hamburgerTextStyle,),
                    onTap: () {
                      // Close the drawer first
                      // Navigator.pop(context);

                      // Navigate to connection management screen
                      Navigator.pushNamed(context, "/connection_management");

                    },
                  ),
                  ListTile(
                    title: Text("Settings", style: hamburgerTextStyle),
                    onTap: () async {
                      // Close the drawer first
                      // Navigator.pop(context);

                      // Navigate to testing screen
                      Navigator.pushNamed(context, "/settings");
                    },
                  ),
                  ListTile(
                    title: Text("Testing Screen", style: hamburgerTextStyle,),
                    onTap: () {
                      // Close the drawer first
                      // Navigator.pop(context);

                      // Navigate to testing screen
                      Navigator.pushNamed(context, "/testing");
                    },
                  ),
                  ListTile(
                    title: Text("Sign Out", style: hamburgerTextStyle),
                    onTap: () async {
                      await MyAuthenticator.signOut(context: context);
                      Navigator.pushReplacementNamed(context, "/loading");
                    },
                  ),ListTile(
                    title: Text("Report a bug", style: hamburgerTextStyle,),
                    onTap: () {
                      // Close the drawer first
                      // Navigator.pop(context);

                      // Navigate to testing screen
                      Navigator.pushNamed(context, "/LogSubmission");
                    },
                  ),
                ],
              ),
            ),
          ),

          appBar: AppBar(
            iconTheme: IconThemeData(color: Config.secondaryColor), // this sets the drawer color
            automaticallyImplyLeading: false, // Removes the back arrow from the top left
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.account_circle_rounded, color: Config.secondaryColor),
                SizedBox(width: 118), // centers the title
                Text("LoveTap", style: TextStyle(color: Config.secondaryColor),),
              ]
            ),
            centerTitle: false,
            backgroundColor: Colors.transparent,//Config.secondaryColor,
            elevation: 0.0,
          ),

          // WillPopScope prevents back presses
          body: WillPopScope(
            onWillPop: () async {
              stamp("Back press on home screen detected");
              final scaffold = ScaffoldMessenger.of(context);
              scaffold.showSnackBar(
                  SnackBar(
                    content: const Text('This is the home screen. To log out, go to settings.'),
                    duration: Duration(milliseconds: Config.SNACKBAR_TIMEOUT),
                  ));
              return false;
            },

            // UI
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          // width: 200,
                          child: Padding(
                            padding: EdgeInsets.all(2),
                            child: DropdownButton (
                              // This styles the menu
                              dropdownColor: Color.fromRGBO(243, 53, 136, 1),
                              borderRadius: BorderRadius.circular(10),
                              style: TextStyle(
                                color: Config.secondaryColor,
                                fontSize: 16,
                              ),
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: Config.secondaryColor,
                              ),
                              underline: Container(), // Get rid of the underline

                              // This takes care of logic
                              items: destinationOptions,
                              onChanged: _destinationChanged,
                              value: _selectedDestination,
                            ),
                          ),
                        ),
                        IconButton(
                          // Update the list and setState()
                          onPressed: () {updateList(); setState(() {});},
                          icon: const Icon(Icons.refresh),
                          color: Config.secondaryColor,
                        )
                      ],
                    ),

                    SizedBox(height: 140),

                    // Tap interface
                    InkWell(
                      onTapDown: _press,
                      onTapUp: _release,

                      splashColor: Config.accent,
                      highlightColor: Colors.transparent, // This disables the white overlay on presses
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Ink(
                        width: 300,
                        height: 300,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Config.primaryColor,
                          border: Border.all(
                            color: Config.secondaryColor!,
                            width: 2.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Tap Here",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Config.secondaryColor,
                              fontSize: 25,
                            ),
                          )
                        ),
                      )
                    ),
                  ],
                ),
              )
            ),
          )
        ),
      ),
    );
  }
}