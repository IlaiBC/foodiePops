import 'dart:math';

import 'package:flutter/material.dart';
import 'package:foodiepops/data/mockData.dart';
import 'package:foodiepops/models/UserData.dart';
import 'package:foodiepops/models/pop.dart';
import 'package:foodiepops/services/fireStoreDatabase.dart';
import 'package:foodiepops/services/firebaseAuthService.dart';
import 'package:provider/provider.dart';
import 'package:foodiepops/models/popClickCounter.dart';

class BusinessProfileScreen extends StatelessWidget {
  BusinessProfileScreen(
      {Key key, @required this.userSnapshot, @required this.userData})
      : super(key: key);
  final AsyncSnapshot<User> userSnapshot;
  final UserData userData;
  List<Pop> businessPopList = [];

  int _getActivePopsLength() {
    int activePopsLength = 0;
    if (businessPopList.length > 0) {
      for (var i = 0; i < businessPopList.length; i++) {
        Pop currentPop = businessPopList[i];

        if (!currentPop.expirationTime.isBefore(DateTime.now())) {
          activePopsLength = activePopsLength + 1;
        }
      }
    }

    return activePopsLength;
  }

  ImageProvider _getUserImage() {
    if (userSnapshot.hasData && userSnapshot.data.photoUrl != null) {
      return NetworkImage(userSnapshot.data.photoUrl);
    }

    return AssetImage('assets/business_login.png');
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
    debugPrint('user details: displayName: ${user.displayName}, email: ${user.email}');
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
      body: StreamBuilder<List<Pop>>(
          stream: database.getBusinessPopList(user.uid),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              final List<Pop> popList = snapshot.data;
              businessPopList = popList;
              return new Center(
                  child: Column(children: <Widget>[
                SizedBox(height: 20.0),
                Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        image: DecorationImage(
                            image: _getUserImage(),
                            fit: BoxFit.cover),
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
                SizedBox(height: 15.0),
                Divider(thickness: 4.0, color: Color(0xffe51923)),
                Row(
                  children: <Widget>[
                    rowCell(_getActivePopsLength(), 'ACTIVE POPS'),
                    rowCell(businessPopList.length, 'TOTAL POPS'),
                  ],
                ),
                new Divider(thickness: 4.0, color: Color(0xffe51923)),
                SizedBox(height: 15.0),
                Text(
                  'Pops Overview:',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15.0),
                businessPopList.length != 0
                    ? Expanded(
                        child: ListView.builder(
                            itemCount: businessPopList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return StreamBuilder<PopClickCounter>(
                                  stream: database.popCouponRedeemCounterStream(
                                      businessPopList[index].id),
                                  builder: (context, snapshot) {
                                    final PopClickCounter couponsRedeemed =
                                        snapshot.data;
                                    int numOfCouponsRedeemed =
                                        couponsRedeemed != null
                                            ? couponsRedeemed.counter
                                            : 0;
                                    return Card(
                                        child: ListTile(
                                      title: Text(businessPopList[index].name,
                                          style: new TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold)),
                                      // name of pop up
                                      trailing: Text(
                                          'Coupons Redeemed: $numOfCouponsRedeemed',
                                          style: new TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold)),
                                      // code redeemed
                                      contentPadding: EdgeInsets.all(10.0),
                                      onTap: () => {},
                                    ));
                                  });
                            }))
                    : Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              "You've got no pops, add some!",
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
