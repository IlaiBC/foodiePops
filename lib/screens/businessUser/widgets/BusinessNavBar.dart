import 'package:flutter/material.dart';
import 'package:foodiepops/data/mockData.dart';
import 'package:foodiepops/models/UserData.dart';
import 'package:foodiepops/screens/login/loginScreen.dart';
import 'package:foodiepops/screens/news/newsScreen.dart';
import 'package:foodiepops/screens/pops/PopListScreen.dart';
import 'package:foodiepops/screens/profile/profileScreen.dart';
import 'package:foodiepops/services/firebaseAuthService.dart';
import 'package:foodiepops/widgets/bottomNav.dart';

class BusinessNavBar extends StatelessWidget  {
  const BusinessNavBar({Key key, @required this.userSnapshot, this.userData});
  final AsyncSnapshot<User> userSnapshot;
  final UserData userData;

  Widget build(BuildContext context) {
      final navPages = <Widget>[
        PopListScreen(),
        NewsScreen(news: mockNews),
        userSnapshot.hasData ? ProfileScreen() : LoginScreen(),
      ];

      final navItems = <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/foodie.png")),
            title: Text('Business')),
        BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/news.png")),
            title: Text('Business')),
        BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/profile.png")),
            title: Text('Business')),
      ];

      return BottomNav(userSnapshot: userSnapshot, navPages: navPages, navItems: navItems);
  }     
}