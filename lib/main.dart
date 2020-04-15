import 'package:flutter/material.dart';
import 'package:foodiepops/screens/login/loginScreen.dart';
import 'package:foodiepops/screens/main/mainScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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