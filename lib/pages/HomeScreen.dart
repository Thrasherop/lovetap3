import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lovetap3/interfaces/MyAuthenticator.dart';
import 'package:lovetap3/interfaces/MyFileInterface.dart';
import 'package:lovetap3/interfaces/SettingManager.dart';
import 'package:lovetap3/objects/ConnectionObject.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

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

  // Scaffold key. We use this reference to close the drawer
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  // This is set up in _updateHamburgerTextStyle()
  late TextStyle hamburgerTextStyle;

  late OutgoingPackage curPackage = OutgoingPackage.PlaceHolder();

  List<DropdownMenuItem> destinationOptions = <DropdownMenuItem>[DropdownMenuItem(child: Text("Loading..."), value: "Loading...")];
  late String _selectedDestination;// = MyNullObject().toString();//Config.DESTINATION_OPTIONS[0].value;

  @override
  void initState(){
    super.initState();
    _selectedDestination = destinationOptions[0].value;

    // update the hamburger text style
    _updateHamburgerTextStyle();

    // Push our resumeContext() callback onto MyBuffer.updateScreenCallback stack.
    MyBuffer.updateScreenCallback.insert(0, (){
       // Call resumeContext after the screen is calledback
       WidgetsBinding.instance.addPostFrameCallback((_) => resumeContext());
    });


    // Initialize the list, but delayed to ensure the screen has been created
    Future.delayed(Duration(milliseconds: 100), updateList);

  }

  void resumeContext() {

    // Update the list
    updateList();

    // Update screen
    setState(() {});
  }

  void updateList() async {

    await _updateDestinationOptions();

    if (destinationOptions.isEmpty){
      destinationOptions = <DropdownMenuItem>[DropdownMenuItem(child: Text("No connections"), value: "No connections")];
    }
    _selectedDestination = destinationOptions[0].value ?? "No connections";
    setState(() {});

  }

  Future<void> _updateDestinationOptions() async {

    // Fetch connection information & add to newDestinationOptions
    Map<String, ConnectionObject> connectionsMap = (await MyFileInterface.getConnections());


    // Generates the list of destination options
    List<DropdownMenuItem> newDestinationOptions = <DropdownMenuItem>[];
    connectionsMap.forEach((key, value) {
      if (value.isActive()) {
        // Add the value IF its active
        // This is the style for the individual items
        newDestinationOptions.add(DropdownMenuItem(
            value: value.getConnectionID(),
            child: Text(
                value.getNickname(),
                style: TextStyle(
                  color: SettingManager.colorArray[2],
                  fontSize: 20,
                ),
            ),
        ));
      }
    });

    // overwrite the old destination options
    destinationOptions = newDestinationOptions;
    Config.DESTINATION_OPTIONS = destinationOptions;

    // Check for empty. If so, display No connections
    if (destinationOptions.isEmpty){
      destinationOptions = <DropdownMenuItem>[DropdownMenuItem(child: Text("No connections"), value: "No connections")];
      _selectedDestination = destinationOptions[0].value ?? "No connections";
    } else {
      _selectedDestination = destinationOptions[0].value;
    }
    setState(() {});

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

  void _addConnectionMenuButtonPressed(){
    stamp("Redirecting user to add connection screen");


    // Navigate to add connection screen
    Navigator.pushNamed(context, "/add_connection");

  }

  void _updateHamburgerTextStyle(){
    /*

      This function updates the HamburgerTextStyle. This
      is necessary in case the theme changes.

     */

    hamburgerTextStyle = TextStyle(
      // color: Config.primaryColor,
        color: SettingManager.colorArray[2],
        fontStyle: FontStyle.italic
    );

  }

  @override
  Widget build(BuildContext context) {

    // Update various values
    _updateDestinationOptions();
    _updateHamburgerTextStyle();

    // stamp("Destination options: ${destinationOptions[0].value}");
    // stamp("Selected destination option: ${_selectedDestination}");

    return MaterialApp(

      home: Container(

        color: Colors.transparent, //SettingManager.colorArray[1], // Home screen background

        child: Stack(
          children: [

            // LoveTap title
            Positioned(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Scaffold (

                backgroundColor: SettingManager.colorArray[1],

                body: SafeArea(
                  child: SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text(
                          "Love",
                          style: GoogleFonts.getFont("Alex Brush",
                            textStyle: TextStyle(
                                fontSize: 75,
                                color: SettingManager.colorArray[2],
                                decoration: TextDecoration.none
                            ),
                          )
                        ),

                        Text(
                          "Tap",
                          style: GoogleFonts.getFont("Alex Brush",
                            textStyle: TextStyle(
                                fontSize: 75,
                                color: SettingManager.colorArray[3],
                                decoration: TextDecoration.none
                            ),
                          )
                        )

                      ],
                    )
                  ),
                ),
              ),
            ),

            Scaffold (
            backgroundColor: Colors.transparent, // transparent to show background of container
            key: _scaffoldKey,
            drawer: Drawer(
              /*
                This is the layout for the drawer.
               */
              child: Container(
                color: SettingManager.colorArray[4],//Colors.transparent,//SettingManager.colorArray[400],

                // Drawer
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
                        // Close the drawer
                        _scaffoldKey.currentState?.closeDrawer();

                        // Navigate to connection management screen
                        Navigator.pushNamed(context, "/connection_management");

                      },
                    ),
                    ListTile(
                      title: Text("Settings", style: hamburgerTextStyle),
                      onTap: () async {
                        // Close the drawer first
                        _scaffoldKey.currentState?.closeDrawer();

                        // Navigate to testing screen
                        Navigator.pushNamed(context, "/settings");
                      },
                    ),
                    ListTile(
                      title: Text("Testing Screen", style: hamburgerTextStyle,),
                      onTap: () {
                        // Close the drawer first
                        _scaffoldKey.currentState?.closeDrawer();

                        // Navigate to testing screen
                        Navigator.pushNamed(context, "/testing");
                      },
                    ),
                    ListTile(
                      title: Text("Sign Out", style: hamburgerTextStyle),
                      onTap: () async {
                        await MyAuthenticator.signOut(context: context);
                        await Navigator.pushReplacementNamed(context, "/loading"); // Await so that we can resume when it returns
                        stamp("pushreplacement ended. Resetting screen");
                        setState(() {}); // refresh now that it returns
                        stamp("PushReplacement ended. Screen reset");
                      },
                    ),
                    ListTile(
                      title: Text("Report a bug", style: hamburgerTextStyle,),
                      onTap: () {
                        // Close the drawer first
                        _scaffoldKey.currentState?.closeDrawer();

                        // Navigate to testing screen
                        Navigator.pushNamed(context, "/LogSubmission");
                      },
                    ),
                  ],
                ),
              ),
            ),

            appBar: AppBar(

              iconTheme: IconThemeData(color: SettingManager.colorArray[2]), // this sets the drawer color
              automaticallyImplyLeading: true, // Removes the back arrow from the top left

              title: Text("", style: TextStyle(color: SettingManager.colorArray[2])),

              actions: [
                Padding( // Padding for the plus icon
                  padding: const EdgeInsets.only(right: 1.0),
                  child: IconButton(
                          onPressed: _addConnectionMenuButtonPressed,
                          icon: const Icon(Icons.add),
                          color: SettingManager.colorArray[2],
                          padding: EdgeInsets.zero,
                        ),
                ),
              ],
              centerTitle: true,
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          SizedBox(
                              height: 10
                          ),

                          Text(
                              "Sending   to   ",
                            style: GoogleFonts.getFont(
                              "Alex Brush",
                              textStyle: TextStyle(
                                color: SettingManager.colorArray[2],
                                fontSize: 20,
                              ),
                            )
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                // width: 200,
                                child: Padding(
                                  padding: EdgeInsets.all(2),
                                  child: DropdownButton (
                                    // This styles the menu
                                    dropdownColor: SettingManager.colorArray[4],//Color.fromRGBO(243, 53, 136, 1),
                                    borderRadius: BorderRadius.circular(10),
                                    style: GoogleFonts.getFont(
                                      "Alex Brush",
                                      textStyle: TextStyle (
                                        color: SettingManager.colorArray[2],
                                        fontSize: 19,
                                      ),
                                    ),
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: SettingManager.colorArray[2],
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
                                color: SettingManager.colorArray[2],
                              )
                            ],
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 80
                      ),

                      // Heart icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.heart_fill,
                            color: SettingManager.colorArray[2]!,
                            size: 120,
                          ),

                          Icon(
                            CupertinoIcons.heart_fill,
                            color: SettingManager.colorArray[3]!,
                            size: 120,
                          ),

                        ],
                      ),

                      SizedBox(height: 20),

                      // Tap interface
                      InkWell(

                        onTapDown: _press,
                        onTapUp: _release,

                        splashColor: SettingManager.colorArray[3],
                        highlightColor: Colors.transparent, // This disables the white overlay on presses
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: Ink(
                          width: 270,
                          height: 270,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: SettingManager.colorArray[1], // Color of the tap square
                            border: Border.all(
                              color: SettingManager.colorArray[3]!,
                              width: 4.0,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Tap Here",
                              style: GoogleFonts.getFont(
                                "Alex Brush",
                                textStyle: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: SettingManager.colorArray[3],
                                  fontSize: 50,
                                ),
                              )
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

          ]
        ),
      ),
    );
  }
}