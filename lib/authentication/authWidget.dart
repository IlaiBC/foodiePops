import 'package:flutter/material.dart';
import 'package:foodiepops/components/bottomNav.dart';
import 'package:foodiepops/screens/login/loginScreen.dart';
import 'package:foodiepops/services/firebaseAuthService.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key key, @required this.userSnapshot}) : super(key: key);
  final AsyncSnapshot<User> userSnapshot;

  @override
  Widget build(BuildContext context) {
    if (userSnapshot.connectionState == ConnectionState.active) {
      return userSnapshot.hasData ? BottomNav(userSnapshot: userSnapshot) : LoginScreen();
    }
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
