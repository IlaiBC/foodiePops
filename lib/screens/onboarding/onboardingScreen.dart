import 'package:fancy_on_boarding/fancy_on_boarding.dart';
import 'package:flutter/material.dart';

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
        body: Text('Find special foodie expiriences near you',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            )),
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
        body: Text(
            'Get updated on the latest news in the foodie scene',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            )),
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
      body: Text('Login in to FoodiePops in the profile page for a more personalized expirience',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          )),
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
        body: Text('FoodiePops uses your location data to customize pop offers for you',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            )),
        iconAssetPath: 'assets/location.png',
        ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Pass pageList and the mainPage route.
      body: FancyOnBoarding(
        doneButtonText: "Lets Go",
        skipButtonText: "Skip",
        pageList: pageList,
        onDoneButtonPressed: () =>
            Navigator.of(context).pushReplacementNamed('/auth'),
        onSkipButtonPressed: () =>
            Navigator.of(context).pushReplacementNamed('/auth'),
      ),
    );
  }
}