import 'package:flutter/material.dart';
import 'package:foodiepops/services/firebaseAuthService.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key key, @required this.userSnapshot, @required this.navPages, @required this.navItems}) : super(key: key);
  final AsyncSnapshot<User> userSnapshot;
  final navPages;
  final navItems;

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
      assert(widget.navPages.length == widget.navItems.length);
      final bottomNavBar = BottomNavigationBar(
        items: widget.navItems,
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
            children: widget.navPages),
        bottomNavigationBar: bottomNavBar,
      );
  }
}
