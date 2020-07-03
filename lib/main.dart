import 'package:flutter/material.dart';
import 'package:foodiepops/authentication/authWidget.dart';
import 'package:foodiepops/screens/main/mainScreen.dart';
import 'package:foodiepops/screens/onboarding/onboardingScreen.dart';
import 'package:foodiepops/services/firebaseAuthService.dart';
import 'package:foodiepops/services/fireStoreDatabase.dart';
import 'package:foodiepops/services/imagePickerService.dart';
import 'package:provider/provider.dart';
import 'authentication/authWidgetBuilder.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp(
      authServiceBuilder: (_) => FirebaseAuthService(),
      databaseBuilder: (_) => FirestoreDatabase(),
    ));

class MyApp extends StatelessWidget {
  const MyApp({Key key, this.authServiceBuilder, this.databaseBuilder})
      : super(key: key);

  // Expose builders for 3rd party services at the root of the widget tree
  // This is useful when mocking services while testing
  final FirebaseAuthService Function(BuildContext context) authServiceBuilder;
  final FirestoreDatabase Function(BuildContext context) databaseBuilder;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(
          create: authServiceBuilder,
        ),
        Provider<FirestoreDatabase>(
          create: databaseBuilder,
        ),
        Provider<ImagePickerService>(
          create: (_) => ImagePickerService(),
        )
      ],
      child: AuthWidgetBuilder(
        builder: (BuildContext context, AsyncSnapshot<User> userSnapshot) {
          FlutterStatusbarcolor.setStatusBarColor(Color(0xffe51923));

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            routes: {
              MainScreen.routeName: (context) => MainScreen(),
              '/auth': (context) => AuthWidget(userSnapshot: userSnapshot),
            },
            title: 'FoodiePops',
            theme: ThemeData(
                primarySwatch: Colors.red, primaryColor: Color(0xffe51923)),
            home: Splash(userSnapshot: userSnapshot,),
          );
        },
      ),
    );
  }
}

class Splash extends StatelessWidget {
  const Splash({Key key, @required this.userSnapshot}) : super(key: key);
  final AsyncSnapshot<User> userSnapshot;

  Future<bool> checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    debugPrint(_seen.toString());
    debugPrint("here");

    if (_seen == false) {
      await prefs.setBool('seen', true);
    }

    return _seen;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
          child: FutureBuilder(
              future: checkFirstSeen(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData) {
                  bool hasSeenSplash = snapshot.data;

                  return hasSeenSplash ?  AuthWidget(userSnapshot: userSnapshot,) : OnboardingScreen(
                            title: 'Fancy OnBoarding HomePage');
                }

                return Text('Loading...');
              })),
    );
  }
}
