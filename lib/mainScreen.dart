import 'package:flutter/material.dart';
import 'package:foodiepops/mainScreenArguments.dart';

class MainScreen extends StatelessWidget {
  static const routeName = '/MainScreen';
  const MainScreen({Key key, this.userLoginResponse}) : super(key: key); 

  final dynamic userLoginResponse;

  
  @override
  Widget build(BuildContext context) {
    final MainScreenArguments args = ModalRoute.of(context).settings.arguments;
    String userDisplayName = args.userLoginResponse.providerData[0].displayName;
    
    return Scaffold(backgroundColor: Colors.green,
      body: Center(child: Text('Welcome $userDisplayName!'),) ,
    );
  }
}