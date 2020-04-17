import 'package:flutter/material.dart';
import 'package:foodiepops/loginScreen.dart';
import 'package:foodiepops/mainScreen.dart';
import 'package:foodiepops/services/firebaseAuthService.dart';
import 'package:foodiepops/services/fireStoreDatabase.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
    const MyApp({Key key, this.authServiceBuilder, this.databaseBuilder})
      : super(key: key);
  // Expose builders for 3rd party services at the root of the widget tree
  // This is useful when mocking services while testing
  final FirebaseAuthService Function(BuildContext context) authServiceBuilder;
  final FirestoreDatabase Function(BuildContext context, String uid)
      databaseBuilder;
      
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodiePops Login',
      initialRoute: '/',
      routes: {
        MainScreen.routeName: (context) => MainScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: LoginScreen(),
    );
  }
}