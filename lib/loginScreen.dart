
import 'package:flutter/material.dart';
import 'package:foodiepops/firebaseAuth.dart';
import 'package:foodiepops/mainScreen.dart';
import 'package:foodiepops/mainScreenArguments.dart';
import 'package:foodiepops/signInButton.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}



class _LoginScreenState extends State<LoginScreen> {

  bool _isLoadingIndicatorShowing = false;

  void toggleLoadingIndicator () {
    setState(() {
        _isLoadingIndicatorShowing = !_isLoadingIndicatorShowing;
      });
  }

  void onGoogleSignInPressed (BuildContext context) {
      toggleLoadingIndicator();
      signInWithGoogle().catchError((onError) {
        print(onError);
      }).then((value) {
      toggleLoadingIndicator();
      Navigator.pushNamed(context, MainScreen.routeName, arguments: MainScreenArguments(value));
    });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlutterLogo(size: 150),
              Stack(
              children: <Widget>[
                Visibility(
                  visible: _isLoadingIndicatorShowing,
                  child: CircularProgressIndicator(),
                ),
              ]),
              SizedBox(height: 50),
              SignInButton(buttonText: 'Sign in with Google', buttonColor: Colors.grey, buttonIconPath: "assets/google_logo.png", buttonOnPressedAction: () => onGoogleSignInPressed(context)),
              SizedBox(height: 20),
              SignInButton(buttonText: 'Sign in with Facebook', buttonColor: Colors.blue, buttonIconPath: "assets/google_logo.png", buttonOnPressedAction: () {}),
            ]),
        ),
      ),
    );
  }


}