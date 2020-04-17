import 'package:flutter/material.dart';
import 'package:foodiepops/loginScreen.dart';
import 'package:foodiepops/mainScreen.dart';
import 'package:foodiepops/services/firebaseAuthService.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key key, @required this.userSnapshot}) : super(key: key);
  final AsyncSnapshot<User> userSnapshot;

  @override
  Widget build(BuildContext context) {
    if (userSnapshot.connectionState == ConnectionState.active) {
      return userSnapshot.hasData ? MainScreen() : LoginScreen();
    }
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
