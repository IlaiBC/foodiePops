import 'package:fancy_on_boarding/fancy_on_boarding.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _OnboardingScreenState createState() => new _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final pageList = [
    PageModel(
        color: const Color(0xFF678FB4),
        heroAssetPath: 'assets/foodie.png',
        title: Text('Pops',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 34.0,
            )),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text('Find special foodie expiriences near you',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ))),
        iconAssetPath: 'assets/foodie.png'),
    PageModel(
        color: const Color(0xFF65B0B4),
        heroAssetPath: 'assets/news.png',
        title: Text('News',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 34.0,
            )),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text('Get updated on the latest news in the foodie scene',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ))),
        iconAssetPath: 'assets/news.png'),
    PageModel(
      color: const Color(0xFF9B90BC),
      heroAssetPath: 'assets/profile.png',
      title: Text('User',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 34.0,
          )),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text('Login in the profile page to redeem pop coupons',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ))),
      iconAssetPath: 'assets/profile.png',
    ),
    PageModel(
      color: Color(0xffe51923),
      heroAssetPath: 'assets/location.png',
      title: Text('Location',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 34.0,
          )),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
              'FoodiePops uses your location data to customize pop offers for you',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ))),
      iconAssetPath: 'assets/location.png',
    ),
  ];

  setSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('seen', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //Pass pageList and the mainPage route.
        body: FancyOnBoarding(
      doneButtonText: "Lets Go",
      skipButtonText: "Skip",
      pageList: pageList,
      onDoneButtonPressed: () {
        setSeen();
        Navigator.of(context).pushReplacementNamed('/auth');
      },
      onSkipButtonPressed: () {
        setSeen();
        Navigator.of(context).pushReplacementNamed('/auth');
      },
    ));
  }
}
