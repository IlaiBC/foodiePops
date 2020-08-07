import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:foodiepops/screens/businessUser/CredentialsLoginScreen.dart';
import 'package:foodiepops/widgets/signInButton.dart';
import 'package:foodiepops/services/firebaseAuthService.dart';
import 'package:provider/provider.dart';

class BusinessLoginScreen extends StatefulWidget {
  @override
  _BusinessLoginScreenState createState() => _BusinessLoginScreenState();
}

class _BusinessLoginScreenState extends State<BusinessLoginScreen> {
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
    await authService.signInWithGoogle(true).catchError((onError) {
      toggleLoadingIndicator();
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Login failed, is your internet on?')));
    });
  }

  void onFacebookSignInPressed(
      BuildContext context, FirebaseAuthService authService) async {
    toggleLoadingIndicator();
    await authService.signInWithFacebook(true).catchError((onError) {
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
                  isBusinessUser: true,
                )));
  }

  @override
  Widget build(BuildContext context) {
    final authService =
        Provider.of<FirebaseAuthService>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Business Login'),
        ),
        body: Builder(builder: (BuildContext context) {
          return Container(
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
                    ]),
              ),
            ),
          );
        }));
  }
}
