import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodiepops/services/firebaseAuthService.dart';

class MainScreen extends StatelessWidget {
  static const routeName = '/MainScreen';
  const MainScreen({Key key}) : super(key: key); 
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    final authService =
    Provider.of<FirebaseAuthService>(context, listen: false);
    
    return Scaffold(backgroundColor: Colors.green,
      body: Center(child: Column(children: <Widget>[
        Text('Welcome ${user.displayName}!'),
        RaisedButton(child: Text("logout"), onPressed: () => authService.signOut(),)
      ],) ) ,
    );
  }
}