import 'package:flutter/material.dart';
import 'package:foodiepops/screens/feed/PopListScreen.dart';
import 'package:foodiepops/screens/login/loginScreen.dart';
import 'package:foodiepops/screens/main/mainScreen.dart';
import 'package:foodiepops/services/firebaseAuthService.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key key, @required this.userSnapshot}) : super(key: key);
  final AsyncSnapshot<User> userSnapshot;

  @override
  Widget build(BuildContext context) {
    if (userSnapshot.connectionState == ConnectionState.active) {
      return userSnapshot.hasData ? MainScreen() : PopListScreen();
    }
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
