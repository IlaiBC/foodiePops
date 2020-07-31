import 'dart:math';

import 'package:flutter/material.dart';
import 'package:foodiepops/data/mockData.dart';
import 'package:foodiepops/models/UserData.dart';
import 'package:foodiepops/models/pop.dart';
import 'package:foodiepops/services/fireStoreDatabase.dart';
import 'package:foodiepops/services/firebaseAuthService.dart';
import 'package:provider/provider.dart';

class BusinessProfileScreen extends StatelessWidget {
  BusinessProfileScreen(
      {Key key, @required this.userSnapshot, @required this.userData})
      : super(key: key);
  final AsyncSnapshot<User> userSnapshot;
  final UserData userData;

  Widget rowCell(int count, String type) => new Expanded(
          child: new Column(
        children: <Widget>[
          new Text('$count',
              style: new TextStyle(
                  color: Color(0xffe51923),
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold)),
          new Text(type,
              style: new TextStyle(
                  color: Color(0xffe51923),
                  fontSize: 18.0,
                  fontWeight: FontWeight.normal))
        ],
      ));

  @override
  Widget build(BuildContext context) {
    final user = userSnapshot.data;
    var rng = new Random();
    final authService =
        Provider.of<FirebaseAuthService>(context, listen: false);
    final FirestoreDatabase database =
        Provider.of<FirestoreDatabase>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () => authService.signOut(),
            )
          ],
        ),
        body: new Center(
            child: Column(children: <Widget>[
          SizedBox(height: 50.0),
          Container(
              width: 150.0,
              height: 150.0,
              decoration: BoxDecoration(
                  color: Colors.red,
                  image: DecorationImage(
                      image: AssetImage('assets/business_login.png'),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.all(Radius.circular(75.0)),
                  boxShadow: [
                    BoxShadow(blurRadius: 7.0, color: Colors.black)
                  ])),
          SizedBox(height: 40.0),
          if (user.displayName != null)
            Text(
              user.displayName,
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          SizedBox(height: 15.0),
          Padding(
              padding: new EdgeInsets.symmetric(horizontal: 7.0),
              child: Text(
                quotes[rng.nextInt(12)],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17.0,
                  fontStyle: FontStyle.italic,
                ),
              )),
          SizedBox(height: 25.0),
          Divider(thickness: 4.0, color: Color(0xffe51923)),
          Row(
            children: <Widget>[
              rowCell(7, 'ACTIVE POPS'),
              rowCell(78, 'COUPONS REDEEMED'),
            ],
          ),
          new Divider(thickness: 4.0, color: Color(0xffe51923)),
          SizedBox(height: 25.0),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'NEED HELP OR GOT SUGGESTIONS?',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              )),
          SizedBox(height: 15.0),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Email The Foodie Team',
                style: TextStyle(
                  fontSize: 18.0,
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
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              )),
          SizedBox(height: 15.0),
        ])));
  }
}
