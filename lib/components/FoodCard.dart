import 'package:flutter/material.dart';


class FoodCard extends StatelessWidget {
  const FoodCard({
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