import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RSSNews extends StatefulWidget {
  RSSNews() : super();

  final String title = 'Foodie News';

  @override
  RSSNewsState createState() => RSSNewsState();
}

class RSSNewsState extends State<RSSNews> {
  static const String FEED_URL = 'http://www.rssmix.com/u/11835678/rss.xml';
  RssFeed _feed;
  String _title;
  static const String loadingFeedMsg = 'Loading Feed...';
  static const String feedLoadErrorMsg = 'Error Loading Feed.';
  static const String feedOpenErrorMsg = 'Error Opening Feed.';
  static const String placeholderImg = 'assets/foodiepopsicon.png';
  GlobalKey<RefreshIndicatorState> _refreshKey;

  updateTitle(title) {
    setState(() {
      _title = title;
    });
  }

  updateFeed(feed) {
    setState(() {
      _feed = feed;
    });
  }

  Future<Null> _openInWebview(context, String url) async {
    if (await canLaunch(url)) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => WebviewScaffold(
            initialChild: Center(child: CircularProgressIndicator()),
            url: url,
            appBar: AppBar(title: Text(url)),
          ),
        ),
      );
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('URL $url can not be launched.'),
        ),
      );
    }
  }

  load() async {
    updateTitle(loadingFeedMsg);
    loadFeed().then((result) {
      if (null == result || result.toString().isEmpty) {
        updateTitle(feedLoadErrorMsg);
        return;
      }
      updateFeed(result);
      updateTitle('Foodie News');
    });
  }

  Future<RssFeed> loadFeed() async {
    try {
      final client = http.Client();
      final response = await client.get(FEED_URL);
      return RssFeed.parse(response.body);
    } catch (e) {
      //
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _refreshKey = GlobalKey<RefreshIndicatorState>();
    updateTitle(widget.title);
    load();
  }

  title(title) {
    return Text(
      title,
      textAlign: TextAlign.right,
      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  subtitle(subTitle) {
    return Text(
      subTitle,
      textAlign: TextAlign.right,
      style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w100),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  thumbnail(imageUrl) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: CachedNetworkImage(
        placeholder: (context, url) => Image.asset(placeholderImg),
        imageUrl: imageUrl,
        height: 100,
        width: 100,
        alignment: Alignment.center,
        fit: BoxFit.fill,
      ),
    );
  }

  rightIcon() {
    return Icon(
      Icons.keyboard_arrow_right,
      color: Colors.grey,
      size: 30.0,
    );
  }

  String getImgUrlFromItem(RssItem item) {
    if (item.description.contains("<img ")) {
      String cleanUrl = "";
      if (item.description.contains(".jpg")) {
        cleanUrl = item.description.substring(
            item.description.indexOf("src=") + 5,
            item.description.indexOf(".jpg") + 4);
      } else if (item.description.contains(".jpeg")) {
        cleanUrl = item.description.substring(
            item.description.indexOf("src=") + 5,
            item.description.indexOf(".jpeg") + 5);
      }
      return cleanUrl;
    } else {
      return "";
    }
  }

  list() {
    return ListView.builder(
      itemCount: _feed.items.length,
      itemBuilder: (BuildContext context, int index) {
        final item = _feed.items[index];
        getImgUrlFromItem(item);
        return GestureDetector(
            onTap: () => _openInWebview(context, item.link),
            child: Card(
                child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: thumbnail(getImgUrlFromItem(item)),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(5.0,10.0,10.0,5.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              title(item.title),
                              subtitle(item.pubDate)
                            ])),
                  ),
                ],
              ),
            )));

//            ListTile(
//                  title: title(item.title),
//                  subtitle: subtitle(item.pubDate),
//                  leading: thumbnail(getImgUrlFromItem(item)),
//                  trailing: rightIcon(),
//                  contentPadding: EdgeInsets.all(5.0),
//                  onTap: () => _openInWebview(context, item.link),
//                ));
      },
    );
  }

  isFeedEmpty() {
    return null == _feed || null == _feed.items;
  }

  body() {
    return isFeedEmpty()
        ? Center(
            child: Expanded(child: Column(children: [SizedBox(height: 200), Text('Is your internet connection on?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold )), RaisedButton(onPressed: load, child: Text("Refresh", style: TextStyle(color: Colors.white)), color: Color(0xffe51923),)]))
          )
        : RefreshIndicator(
            key: _refreshKey,
            child: list(),
            onRefresh: () => load(),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: body(),
    );
  }
}
