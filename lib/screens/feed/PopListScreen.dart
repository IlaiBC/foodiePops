import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:foodiepops/data/popsRepository.dart';
import 'package:foodiepops/model/pop.dart';
import 'package:foodiepops/util/imageUtil.dart';
import 'package:flutter_countdown_timer/countdown_timer.dart';

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
              : new ListView.builder(
                  itemCount: pops.length,
                  itemBuilder: (_, index) {
                    return _buildRow(pops[index]);
                  },
                )),
    );
  }

  Widget _buildPop(Pop pop) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
          ClipRRect(
              borderRadius: new BorderRadius.circular(4.0),
              child: ImageUtil.getPopImageWidget(pop, 180.0, 180.0)),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
          ),
          Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Text(pop.name,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis),
            Padding(
              padding: EdgeInsets.only(top: 16.0),
            ),
            Text(pop.description, style: TextStyle(fontSize: 16.0),
              overflow: TextOverflow.ellipsis,),
            Padding(
              padding: EdgeInsets.only(top: 16.0),
            ),
            Text(pop.description, style: TextStyle(color: Colors.blue),
              overflow: TextOverflow.ellipsis)
          ])
        ]));
  }

  Widget _buildRow(Pop pop) {
    return new Card(
        child: ExpansionTile(
            title: Padding(
              padding: const EdgeInsets.all(0.0),
              child: new Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
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
//                  new SizedBox(height: 4.0),
                      new Text(
                        pop.name,
//                    textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      )
                    ])),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new ClipRRect(
                          borderRadius: new BorderRadius.circular(4.0),
                          child: ImageUtil.getPopTimer(pop, 40.0, 40.0),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 2.0),
                        ),
                        new ClipRRect(
                          borderRadius: new BorderRadius.circular(4.0),
                          child: CountdownTimer(
                            endTime: pop.time,
                            defaultDays: "==",
                            defaultHours: "--",
                            defaultMin: "**",
                            defaultSec: "++",
                            daysSymbol: ":",
                            hoursSymbol: ":",
                            minSymbol: ":",
                            secSymbol: "",
                            daysTextStyle:
                                TextStyle(fontSize: 15, color: Colors.red),
                            hoursTextStyle:
                                TextStyle(fontSize: 15, color: Colors.red),
                            minTextStyle:
                                TextStyle(fontSize: 15, color: Colors.red),
                            secTextStyle:
                                TextStyle(fontSize: 15, color: Colors.red),
                            daysSymbolTextStyle:
                                TextStyle(fontSize: 15, color: Colors.black),
                            hoursSymbolTextStyle:
                                TextStyle(fontSize: 15, color: Colors.black),
                            minSymbolTextStyle:
                                TextStyle(fontSize: 15, color: Colors.black),
                            secSymbolTextStyle:
                                TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                      ]),
                )
              ]),
            ),
            children: <Widget>[_buildPop(pop)]));
//        onTap: () => popTapped(pop));
  }

  popTapped(Pop pop) {
//    UrlUtil.launchURL(event.url);
    print("pop clicked!!");
  }
}
