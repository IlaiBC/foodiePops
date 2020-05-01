import 'package:flutter/material.dart';
import 'package:foodiepops/components/Avatar.dart';
import 'package:foodiepops/screens/main/mainScreen.dart';
import 'package:foodiepops/services/firebaseAuthService.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final authService =
        Provider.of<FirebaseAuthService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => authService.signOut(),
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130.0),
          child: _buildUserInfo(user),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          Center(child: const Text("Your favorite foods",  style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),)),

          const SizedBox(height: 16.0),
          Row(
            children: <Widget>[
              Expanded(
                child: _FoodCard(
                      image: 'assets/foodie_pizza.png',
                      title: 'Pizza',
                    )
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child:_FoodCard(
                      image: 'assets/foodie_sushi.png',
                      title: 'Sushi',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 32.0),
          RaisedButton(color: Color(0xffe51923), child: Text("Change Favorite Foods", style: TextStyle(color: Colors.white),), onPressed: () {Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()));} ,)

        ]));
  }
  
  Widget _buildUserInfo(User user) {
    return Column(
      children: [
        Avatar(
          photoUrl: user.photoUrl,
          radius: 50,
          borderColor: Colors.black54,
          borderWidth: 2.0,
        ),
        SizedBox(height: 8),
        if (user.displayName != null)
          Text(
            user.displayName,
            style: TextStyle(color: Colors.white),
          ),
        SizedBox(height: 8),
      ],
    );
  }
}

class _FoodCard extends StatelessWidget {
  const _FoodCard({
    this.image,
    this.title,
  });

  final String image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      color: Colors.black12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 150,
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage(
                image,
              ), fit: BoxFit.contain,))

          ),
          Expanded(
              child: 
                  Center(child: Text(
                    title,
                     style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold)
                  )),

          ),
        ],
      ),
    );
  }
}