import 'package:flutter/material.dart';
import 'package:foodiepops/signInButton.dart';
import 'package:foodiepops/services/firebaseAuthService.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoadingIndicatorShowing = false;

  void toggleLoadingIndicator() {
    setState(() {
      _isLoadingIndicatorShowing = !_isLoadingIndicatorShowing;
    });
  }

  void onGoogleSignInPressed(
      BuildContext context, FirebaseAuthService authService) async {
    toggleLoadingIndicator();
    await authService.signInWithGoogle().catchError((onError) =>
        print("login error occurred, user possibly canceled login"));
    toggleLoadingIndicator();
  }

  void onFacebookSignInPressed(
      BuildContext context, FirebaseAuthService authService) async {
    toggleLoadingIndicator();
    await authService.signInWithFacebook().catchError((onError) =>
        print("login error occurred, user possibly canceled login"));
    toggleLoadingIndicator();
  }

  @override
  Widget build(BuildContext context) {
    final authService =
        Provider.of<FirebaseAuthService>(context, listen: false);
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                    image: AssetImage("assets/foodiepopslogo.png"),
                    height: 250),
                Stack(children: <Widget>[
                  Visibility(
                    visible: _isLoadingIndicatorShowing,
                    child: CircularProgressIndicator(),
                  ),
                ]),
                SizedBox(height: 50),
                SignInButton(
                    buttonText: 'Sign in with Google',
                    buttonColor: Colors.grey,
                    buttonIconPath: "assets/google_logo.png",
                    buttonOnPressedAction: () =>
                        onGoogleSignInPressed(context, authService)),
                SizedBox(height: 20),
                SignInButton(
                    buttonText: 'Sign in with Facebook',
                    buttonColor: Colors.blue,
                    buttonIconPath: "assets/google_logo.png",
                    buttonOnPressedAction: () =>
                        onFacebookSignInPressed(context, authService)),
              ]),
        ),
      ),
    );
  }
}