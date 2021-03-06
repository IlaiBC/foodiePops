import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:foodiepops/screens/businessUser/CredentialsLoginScreen.dart';
import 'package:foodiepops/screens/businessUser/businessLogin.dart';

import 'package:foodiepops/widgets/signInButton.dart';
import 'package:foodiepops/services/firebaseAuthService.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoadingIndicatorShowing = false;

  void toggleLoadingIndicator() {
    if (mounted) {
      setState(() {
        _isLoadingIndicatorShowing = !_isLoadingIndicatorShowing;
      });
    }
  }

  void onGoogleSignInPressed(
      BuildContext context, FirebaseAuthService authService) async {
    toggleLoadingIndicator();
    await authService.signInWithGoogle(false).catchError((onError) {
      toggleLoadingIndicator();
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Login failed, is your internet on?')));
    });
  }

  void onFacebookSignInPressed(
      BuildContext context, FirebaseAuthService authService) async {
    toggleLoadingIndicator();
    await authService.signInWithFacebook(false).catchError((onError) {
      toggleLoadingIndicator();
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Login failed, is your internet on?')));
    });
  }

  void onCredentialsSignInPressed(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CredentialsLoginScreen(
                  isBusinessUser: false,
                )));
  }

  void onBusinessSignInPressed(context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => BusinessLoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final authService =
        Provider.of<FirebaseAuthService>(context, listen: false);
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                    image: AssetImage("assets/foodiepopslogo_no_bg.png"),
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
                    buttonColor: Colors.red,
                    buttonIconPath: "assets/google_logo.png",
                    buttonOnPressedAction: () =>
                        onGoogleSignInPressed(context, authService)),
                SizedBox(height: 20),
                SignInButton(
                    buttonText: 'Sign in with Facebook',
                    buttonColor: Colors.blue,
                    buttonIconPath: "assets/facebook_logo.png",
                    buttonOnPressedAction: () =>
                        onFacebookSignInPressed(context, authService)),
                SizedBox(height: 20),
                SignInButton(
                  buttonText: 'Sign in with Email',
                  buttonColor: Colors.orange,
                  buttonIconPath: "assets/email_login.png",
                  buttonOnPressedAction: () =>
                      onCredentialsSignInPressed(context),
                ),
                SizedBox(height: 20),
                SignInButton(
                  buttonText: 'Business Login',
                  buttonColor: Colors.green,
                  buttonIconPath: "assets/business_login.png",
                  buttonOnPressedAction: () => onBusinessSignInPressed(context),
                ),
                SizedBox(height: 25.0),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'Email The Foodie Team',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                SizedBox(height: 5.0),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'foodiepopsIL@gmail.com',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                SizedBox(height: 5.0),
              ]),
        ),
      ),
    ));
  }
}
