import 'package:flutter/material.dart';
import 'package:foodiepops/data/mockData.dart';
import 'package:foodiepops/models/news.dart';
import 'package:foodiepops/screens/news/newsFull.dart';

class NewsScreen extends StatelessWidget {
  final List<News> news;

  NewsScreen({Key key, this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: news.length,
      itemBuilder: (context, index) {
        return new Card(
          child: new ListTile(
            leading: CircleAvatar(
              child: ImageIcon(AssetImage("assets/foodie.png")),
              backgroundColor: Colors.lightBlue,
            ),
            title: Text(news[index].title),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                Text(news[index].author),
                Text(news[index].date)
              ]
              ),
            ),
            onTap: () {
              var url = news[index].url;
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (BuildContext context) => new NewsFull(url),
                  ));
            },
          ),
        );
      },
    );
  }
}