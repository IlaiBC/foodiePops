import 'package:flutter/material.dart';
import 'package:foodiepops/constants/Texts.dart';
import 'package:foodiepops/screens/login/credentialsLogin/credentialsLoginForm.dart';

class CredentialsLoginScreen extends StatelessWidget {

  CredentialsLoginScreen({Key key, this.isBusinessUser}) : super(key: key);
  final bool isBusinessUser;

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(isBusinessUser ? Texts.businessCredentialsLogin : Texts.userCredentialsLogin),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
        Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Image(
          image: AssetImage("assets/foodiepopslogo_no_bg.png"),
          height: 250)),
                SizedBox(height: 10),

          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CredentialsSignInFormBuilder(isBusinessUser: isBusinessUser)
            ),
          ),
          ],
        ),
      ),
    );
  }
}
