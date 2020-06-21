import 'package:flutter/material.dart';
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
    if(mounted) {

    setState(() {
      _isLoadingIndicatorShowing = !_isLoadingIndicatorShowing;
    });
    }
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

  void onBusinessSignInPressed(context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => BusinessLogin()));
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
                    buttonText: 'Business Login',
                    buttonColor: Colors.green,
                    buttonIconPath: "assets/business_login.png",
                    buttonOnPressedAction: () => onBusinessSignInPressed(context),
          )]),
        ),
      ),
    );
  }
}