import 'package:flutter/material.dart';
import 'package:foodiepops/loginScreen.dart';
import 'package:foodiepops/mainScreen.dart';

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