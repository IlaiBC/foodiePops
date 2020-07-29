import 'dart:math';

import 'package:flutter/material.dart';
import 'package:foodiepops/data/mockData.dart';
import 'package:foodiepops/services/firebaseAuthService.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
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
    final user = Provider.of<User>(context);
    var rng = new Random();
    final authService =
        Provider.of<FirebaseAuthService>(context, listen: false);
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
                      image: NetworkImage(user.photoUrl), fit: BoxFit.cover),
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
              rowCell(343, 'LIKED POPS'),
              rowCell(673826, 'COUPONS REDEEMED'),
            ],
          ),
          new Divider(thickness: 4.0, color: Color(0xffe51923)),
          SizedBox(height: 25.0),
          Text(
            'My Coupons:',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15.0),
          Expanded(
              child: ListView.builder(
                  itemCount: 20, //need to get coupon number
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        child: ListTile(
                      title: Text("Pop-up name"), // name of pop up
                      trailing: Text("Coupon code"), // code redeemed
                      contentPadding: EdgeInsets.all(5.0),
                      onTap: () => {},
                    ));
                  }))
        ])));
  }
}
