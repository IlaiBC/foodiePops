import 'package:flutter/material.dart';
import 'package:foodiepops/data/popsRepository.dart';
import 'package:foodiepops/model/pop.dart';
import 'package:foodiepops/util/imageUtil.dart';


class PopListScreen extends StatefulWidget {
  @override
  _PopListScreenState createState() => _PopListScreenState();
}



class _PopListScreenState extends State<PopListScreen> {
  List<Pop> pops = [];

  @override
  void initState() {
    super.initState();

    PopsRepository.getEvents().then((List<Pop> pops) {
      setState(() {
        this.pops = pops;
        this.pops.sort((a, b) {
          return a.time.compareTo(b.time);
        });
        print("allData length is: " + pops.length.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
          child: pops.length == 0
              ? new Center(child: new CircularProgressIndicator())
              : new ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.black,
            ),
            itemCount: pops.length,
            itemBuilder: (_, index) {
              return _buildRow(pops[index]);
            },
          )),
    );
  }

  Widget _buildRow(Pop pop) {
    return new GestureDetector(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  new ClipRRect(
                    borderRadius: new BorderRadius.circular(4.0),
                    child: ImageUtil.getPopImageWidget(pop, 80.0, 80.0),
                  ),
                ]),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                ),
                new Expanded(
                    child: new Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new SizedBox(height: 4.0),
                          new Text(
                            pop.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          )
                        ]))
              ]),
        ),
        onTap: () => popTapped(pop));
  }

  popTapped(Pop pop) {
//    UrlUtil.launchURL(event.url);
  print("pop clicked!!");
  }
}