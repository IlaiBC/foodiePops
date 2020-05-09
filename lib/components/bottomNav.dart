import 'package:flutter/material.dart';
import 'package:foodiepops/data/mockData.dart';
import 'package:foodiepops/screens/login/loginScreen.dart';
import 'package:foodiepops/screens/news/newsScreen.dart';
import 'package:foodiepops/screens/pops/PopListScreen.dart';
import 'package:foodiepops/screens/profile/profileScreen.dart';
import 'package:foodiepops/services/firebaseAuthService.dart';
import 'package:provider/provider.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key key, @required this.userSnapshot}) : super(key: key);
  final AsyncSnapshot<User> userSnapshot;

  @override
  State<StatefulWidget> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentPageIndex = 0;
  PageController _pageController;
  @override
  void initState() {
    _pageController = new PageController(
      initialPage: _currentPageIndex,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userSnapshot.connectionState == ConnectionState.active) {
      final _kTabPages = <Widget>[
        PopListScreen(),
        NewsScreen(news: mockNews),
        widget.userSnapshot.hasData ? ProfileScreen() : LoginScreen(),
      ];
      final _kBottmonNavBarItems = <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/foodie.png")),
            title: Text('Pops')),
        BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/news.png")),
            title: Text('News')),
        BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/profile.png")),
            title: Text('Profile')),
      ];
      assert(_kTabPages.length == _kBottmonNavBarItems.length);
      final bottomNavBar = BottomNavigationBar(
        items: _kBottmonNavBarItems,
        currentIndex: _currentPageIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut);
        },
      );
      return Scaffold(
        body: new PageView(
            controller: _pageController,
            onPageChanged: (newPage) {
              setState(() {
                this._currentPageIndex = newPage;
              });
            },
            children: _kTabPages),
        bottomNavigationBar: bottomNavBar,
      );
    }
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
