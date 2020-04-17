import 'package:flutter/material.dart';
import 'package:foodiepops/mainScreen.dart';
import 'package:foodiepops/services/firebaseAuthService.dart';
import 'package:foodiepops/services/fireStoreDatabase.dart';
import 'package:provider/provider.dart';

import 'authentication/authWidget.dart';
import 'authentication/authWidgetBuilder.dart';

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
          return MaterialApp(
            initialRoute: '/',
            routes: {
              MainScreen.routeName: (context) => MainScreen(),
            },
            title: 'FoodiePops Login',
            theme: ThemeData(primarySwatch: Colors.red),
            home: AuthWidget(userSnapshot: userSnapshot),
          );
        },
      ),
    );
  }
}