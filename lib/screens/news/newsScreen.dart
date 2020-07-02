import 'package:flutter/material.dart';
import 'package:foodiepops/models/news.dart';
import 'package:foodiepops/screens/news/newsFull.dart';
import 'package:animations/animations.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';


class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
   List<RssItem> news = [];
   final ContainerTransitionType _transitionType = ContainerTransitionType.fade;

   @override
   void initState() {
     super.initState();
     _getNews().then((feed) {
       if (feed != null) {
       setState(() {
         this.news = feed;
       });
     }});

   }

   Future<List<RssItem>> _getNews() async {
     var client = new http.Client();

     // rss feed
     var feed = client.get("http://rcs.mako.co.il/rss/food-restaurants.xml").then((response) {
       return response.body;
     }).then((bodyString) {
       var feed = new RssFeed.parse(bodyString);
       print(feed.items.first.pubDate);
       return feed.items;
     });

   }



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
                return NewsFull(news[index].link);
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

  Widget _buildNewsCard(RssItem newsItem, VoidCallback openContainer) {
    return Card(
        child: new Container(
            height: 120.0,
            child: ListTile(
                title: Text(newsItem.title,
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
                          newsItem.author,
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(newsItem.pubDate, style: TextStyle(color: Colors.white))
                      ]),
                ),
                onTap: openContainer),
            decoration: new BoxDecoration(
                color: Colors.black,
                image: new DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: new ColorFilter.mode(
                      Colors.black.withOpacity(0.5), BlendMode.dstATop),
                  image: new NetworkImage(newsItem.media.toString()),
                ))));
  }
}
