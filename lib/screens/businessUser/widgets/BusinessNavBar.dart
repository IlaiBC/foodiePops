import 'package:flutter/material.dart';
import 'package:foodiepops/constants/Texts.dart';
import 'package:foodiepops/models/UserData.dart';
import 'package:foodiepops/screens/businessUser/AnalyticsScreen.dart';
import 'package:foodiepops/screens/businessUser/BusinessPopList.dart';
import 'package:foodiepops/screens/businessUser/PopFormScreen.dart';
import 'package:foodiepops/screens/profile/businessProfileScreen.dart';
import 'package:foodiepops/services/firebaseAuthService.dart';
import 'package:foodiepops/widgets/bottomNav.dart';

class BusinessNavBar extends StatelessWidget  {
  const BusinessNavBar({Key key, @required this.userSnapshot, this.userData});
  final AsyncSnapshot<User> userSnapshot;
  final UserData userData;

  Widget build(BuildContext context) {
      final navPages = <Widget>[
        BusinessAnalyticsScreen(businessId: userData.id,),
        BusinessPopList(businessId: userData.id,),
        PopFormScreen(),
        BusinessProfileScreen(userSnapshot: userSnapshot, userData: userData),
      ];

      final navItems = <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            title: Text(Texts.analyticsScreen)),
        BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/foodie.png")),
            title: Text(Texts.myPops)),
        BottomNavigationBarItem(
            icon: Icon(Icons.library_add),
            title: Text(Texts.addPop)),
        BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/profile.png")),
            title: Text(Texts.profilePage)),
      ];

      return BottomNav(userSnapshot: userSnapshot, navPages: navPages, navItems: navItems);
  }     
}