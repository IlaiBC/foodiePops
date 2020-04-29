import 'package:flutter/material.dart';
import 'package:foodiepops/models/news.dart';
import 'package:foodiepops/screens/news/newsFull.dart';
import 'package:foodiepops/util/imageUtil.dart';
import 'package:animations/animations.dart';

class NewsScreen extends StatelessWidget {
  final List<News> news;

  NewsScreen({Key key, this.news}) : super(key: key);

  final ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foodie News'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          ...List<Widget>.generate(news.length, (int index) {
            return OpenContainer(
              transitionType: _transitionType,
              openBuilder: (BuildContext _, VoidCallback openContainer) {
                return NewsFull(news[index].url);
              },
              tappable: false,
              closedShape: const RoundedRectangleBorder(),
              closedElevation: 0.0,
              closedBuilder: (BuildContext _, VoidCallback openContainer) {
                return _buildNewsCard(news[index], openContainer);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNewsCard(News news, VoidCallback openContainer) {
    return Card(
        child: new Container(
            height: 120.0,
            child: ListTile(
                title: Text(news.title,
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          news.author,
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(news.date, style: TextStyle(color: Colors.white))
                      ]),
                ),
                onTap: openContainer),
            decoration: new BoxDecoration(
                color: Colors.black,
                image: new DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: new ColorFilter.mode(
                      Colors.black.withOpacity(0.5), BlendMode.dstATop),
                  image: new NetworkImage(news.picUrl),
                ))));
  }
}
