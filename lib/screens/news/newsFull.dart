import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

void main() => runApp(new NewsFull(null));

class NewsFull extends StatelessWidget {
  static String tag = 'full-news-page';
  NewsFull(this.urlnews);
  final String urlnews;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          "Full Foodie Article",
          style: new TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: new SafeArea(
        child: new Column(
          children: <Widget>[
            Expanded(
            child: MaterialApp(
              routes: {
                "/": (_) => new WebviewScaffold(
                  url: urlnews,
                  appBar: new AppBar(),
                )
              },
            )),
          ],
        ),
      ),
    );
  }
}