import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:foodiepops/data/popsRepository.dart';
import 'package:foodiepops/models/pop.dart';
import 'package:foodiepops/util/imageUtil.dart';
import 'package:flutter_countdown_timer/countdown_timer.dart';
import 'package:animations/animations.dart';

const String _mockFoodieText = "Some foodie text bro, that's no doubt";
class PopListScreen extends StatefulWidget {
  @override
  _PopListScreenState createState() => _PopListScreenState();
}

class _PopListScreenState extends State<PopListScreen> {
ContainerTransitionType _transitionType = ContainerTransitionType.fade;

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foodie Pops you will love'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          ...List<Widget>.generate(pops.length, (int index) {
            return OpenContainer(
              transitionType: _transitionType,
              openBuilder: (BuildContext _, VoidCallback openContainer) {
                return _DetailsPage();
              },
              tappable: false,
              closedShape: const RoundedRectangleBorder(),
              closedElevation: 0.0,
              closedBuilder: (BuildContext _, VoidCallback openContainer) {
                return _buildRow(
                  pops[index], openContainer
                );
              },
            );
          }),
        ],
      ),
    );
  }
}

  Widget _buildRow(Pop pop, VoidCallback openContainer) {
    return new Card(
        child: ListTile(
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
       onTap: openContainer));
  }

class _DetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details page')),
      body: ListView(
        children: <Widget>[
          Container(
            height: 250,
              child: Image.asset(
                'assets/benedicts.png',
              ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Title',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Text(
                  _mockFoodieText,
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}