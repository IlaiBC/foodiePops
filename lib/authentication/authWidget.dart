import 'package:flutter/material.dart';
import 'package:foodiepops/screens/regularUser/widgets/userNavBar.dart';
import 'package:foodiepops/services/firebaseAuthService.dart';
import 'package:provider/provider.dart';
import 'package:foodiepops/models/UserData.dart';
import 'package:foodiepops/services/fireStoreDatabase.dart';
import 'package:foodiepops/screens/businessUser/widgets/BusinessNavBar.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key key, @required this.userSnapshot}) : super(key: key);
  final AsyncSnapshot<User> userSnapshot;

  @override
  Widget build(BuildContext context) {
    debugPrint("in auth widget1");
    debugPrint("in auth widget1 user snapshot $userSnapshot");

    if (userSnapshot.connectionState == ConnectionState.active) {
    debugPrint("in auth widget2");

      if (userSnapshot.hasData) {
    debugPrint("in auth widget3");

        final database = Provider.of<FirestoreDatabase>(context, listen: false); 

        return StreamBuilder<UserData>(
            stream: database.userInfoStream(userSnapshot.data.uid),
            builder: (context, snapshot) {
              final UserData userData = snapshot.data;
    debugPrint("in auth widget4");


              return userData?.isBusinessUser == true
                  ? BusinessNavBar(
                      userSnapshot: userSnapshot, userData: userData)
                  : UserNavBar(userSnapshot: userSnapshot, userData: userData);
            });
      }
    debugPrint("in auth widget5");

      return UserNavBar(userSnapshot: userSnapshot);
    }
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
