import 'package:flutter/material.dart';
import 'package:foodiepops/components/bottomNav.dart';
import 'package:foodiepops/screens/main/mainScreen.dart';
import 'package:foodiepops/services/firebaseAuthService.dart';
import 'package:foodiepops/services/fireStoreDatabase.dart';
import 'package:provider/provider.dart';
import 'authentication/authWidget.dart';
import 'authentication/authWidgetBuilder.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

void main() => runApp(MyApp(
      authServiceBuilder: (_) => FirebaseAuthService(),
      databaseBuilder: (_, uid) => FirestoreDatabase(uid: uid),
    ));

class MyApp extends StatelessWidget {
    const MyApp({Key key, this.authServiceBuilder, this.databaseBuilder})
      : super(key: key);
  // Expose builders for 3rd party services at the root of the widget tree
  // This is useful when mocking services while testing
  final FirebaseAuthService Function(BuildContext context) authServiceBuilder;
  final FirestoreDatabase Function(BuildContext context, String uid)
      databaseBuilder;
      
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(
          create: authServiceBuilder,
        ),
      ],
      child: AuthWidgetBuilder(
        databaseBuilder: databaseBuilder,
        builder: (BuildContext context, AsyncSnapshot<User> userSnapshot) {
          FlutterStatusbarcolor.setStatusBarColor(Color(0xffe51923));
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            routes: {
              MainScreen.routeName: (context) => MainScreen(),
            },
            title: 'FoodiePops',
            theme: ThemeData(primarySwatch: Colors.red, primaryColor: Color(0xffe51923)),
            home: BottomNav(userSnapshot: userSnapshot),
          );
        },
      ),
    );
  }
}