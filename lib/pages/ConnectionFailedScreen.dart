import 'package:flutter/material.dart';

class ConnectionFailedScreen extends StatefulWidget {
  const ConnectionFailedScreen({Key? key}) : super(key: key);

  @override
  State<ConnectionFailedScreen> createState() => _ConnectionFailedScreenState();
}

class _ConnectionFailedScreenState extends State<ConnectionFailedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Text("COnnectionFailedScreen"))
    );
  }
}
