import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key key, this.userDisplayName}) : super(key: key); 

  final String userDisplayName;

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Welcome $userDisplayName!'),) ,
    );
  }
}