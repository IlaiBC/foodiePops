import 'package:flutter/material.dart';
import 'package:foodiepops/data/mockData.dart';
import 'package:foodiepops/screens/news/newsScreen.dart';
import 'package:foodiepops/screens/pops/PopListScreen.dart';
import 'package:foodiepops/screens/profile/profileScreen.dart';


class BottomNav extends StatefulWidget {
  const BottomNav({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BottomNavState();
}

class _BottomNavState
    extends State<BottomNav> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final _kTabPages = <Widget>[
      PopListScreen(),
      NewsScreen(news: mockNews),
      ProfileScreen(),
    ];
    final _kBottmonNavBarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/foodie.png")), title: Text('Pops')),
      BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/news.png")), title: Text('News')),
      BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/profile.png")), title: Text('Profile')),
    ];
    assert(_kTabPages.length == _kBottmonNavBarItems.length);
    final bottomNavBar = BottomNavigationBar(
      items: _kBottmonNavBarItems,
      currentIndex: _currentTabIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        setState(() {
          _currentTabIndex = index;
        });
      },
    );
    return Scaffold(
      body: _kTabPages[_currentTabIndex],
      bottomNavigationBar: bottomNavBar,
    );
  }
}