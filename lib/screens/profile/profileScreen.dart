import 'dart:math';

import 'package:flutter/material.dart';
import 'package:foodiepops/data/mockData.dart';
import 'package:foodiepops/models/UserData.dart';
import 'package:foodiepops/models/pop.dart';
import 'package:foodiepops/services/fireStoreDatabase.dart';
import 'package:foodiepops/services/firebaseAuthService.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key key, @required this.userSnapshot, @required this.userData})
      : super(key: key);
  final AsyncSnapshot<User> userSnapshot;
  final UserData userData;

  List<Pop> _getRedeemedCouponPops(List<Pop> allPops) {
    List<Pop> redeemedCouponPops = [];
    Set<String> redeemedPopCoupons = userData.redeemedPopCoupons;

    for (var i = 0; i < allPops.length; i++) {
      Pop currentPop = allPops[i];

      if (redeemedPopCoupons.contains(currentPop.id)) {
        redeemedCouponPops.add(currentPop);
      }
    }

    return redeemedCouponPops;
  }

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
        body: 
        StreamBuilder<List<Pop>>(
              stream: database.getPopList(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  final List<Pop> popList = snapshot.data;

                  List<Pop> redeemedCouponPops =
                      _getRedeemedCouponPops(popList);
                      return new Center(
            child: Column(children: <Widget>[
          SizedBox(height: 20.0),
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
          SizedBox(height: 15.0),
            Text(
              user.displayName != null && user.displayName.isNotEmpty ? user.displayName : user.email,
              style: TextStyle(
                fontSize: 24.0,
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
              rowCell(userData.likedPops.length, 'LIKED POPS'),
              rowCell(userData.redeemedPopCoupons.length, 'COUPONS REDEEMED'),
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
      redeemedCouponPops.length != 0 ?
                   Expanded(
                      child: ListView.builder(
                          itemCount: redeemedCouponPops
                              .length, //need to get coupon number
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                                child: ListTile(
                              title: Text(redeemedCouponPops[index].name,
                                  style: new TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                              // name of pop up
                              trailing: Text(redeemedCouponPops[index].coupon,
                                  style: new TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                              // code redeemed
                              contentPadding: EdgeInsets.all(10.0),
                              onTap: () => {},
                            ));
                          }))
                          : Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              "You've got no coupons, get some!",
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 40.0),
                          ],
                        ),
                      ),
                SizedBox(height: 15.0),
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
                SizedBox(height: 15.0),
              ]));
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              
              }),
    );
}
}