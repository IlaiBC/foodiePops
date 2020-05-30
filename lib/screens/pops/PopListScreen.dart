import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:foodiepops/data/popsRepository.dart';
import 'package:foodiepops/models/pop.dart';
import 'package:foodiepops/util/imageUtil.dart';
import 'package:flutter_countdown_timer/countdown_timer.dart';
import 'package:animations/animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_launcher/map_launcher.dart';

class PopListScreen extends StatefulWidget {
  @override
  _PopListScreenState createState() => _PopListScreenState();
}

class _PopListScreenState extends State<PopListScreen> {
  ContainerTransitionType _transitionType = ContainerTransitionType.fade;
  List<Pop> pops = [];
  Geolocator geolocator = Geolocator();
  Position userLocation;
  int filterDistance = 10000;

  @override
  void initState() {
    super.initState();

    _getLocation().then((position) {
      setState(() {
        this.userLocation = position;
      });

      PopsRepository.getEvents().then((List<Pop> pops) {
        _filterPopsLocation(pops).then((List<Pop> pops) {
          setState(() {
            this.pops = pops;
            this.pops.sort((a, b) {
              return a.time.compareTo(b.time);
            });
          });
          debugPrint("allData length is: " + this.pops.length.toString());
        });
      });
    });
  }

  Future<List<Pop>> _filterPopsLocation(List<Pop> pops) async {
    List<int> toFilter = [];

    for (var i = 0; i < pops.length; i++) {
      if (userLocation != null) {
        List<Placemark> placemark = await _getPlacemark(pops[i]);
        pops[i].placemark = placemark;

        double distance = await _getPlacemarkDistance(pops[i]);
        debugPrint("Distance: $distance");
        if (distance > this.filterDistance) {
          debugPrint("should filter");
          toFilter.add(i);
        }
      }
    }

    for (var index in toFilter) {
      debugPrint("removed $index");
      pops.removeAt(index);
    }

    debugPrint("finished filter");
    return pops;
  }

  Future<double> _getPlacemarkDistance(Pop pop) async {
    return geolocator.distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        pop.placemark[0].position.latitude,
        pop.placemark[0].position.longitude);
  }

  Future<List<Placemark>> _getPlacemark(Pop pop) async {
    return Geolocator()
        .placemarkFromAddress(pop.address, localeIdentifier: "en");
  }

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      GeolocationStatus geolocationStatus =
          await geolocator.checkGeolocationPermissionStatus();
      debugPrint(geolocationStatus.toString());
      if (geolocationStatus == GeolocationStatus.denied ||
          geolocationStatus == GeolocationStatus.disabled) {
        currentLocation = await geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
      }
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Foodie Pops you will love'),
        ),
        body: new Container(
          child: pops.length == 0
              ? new Center(child: new CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(8.0),
                  children: <Widget>[
                    ...List<Widget>.generate(pops.length, (int index) {
                      return OpenContainer(
                        transitionType: _transitionType,
                        openBuilder:
                            (BuildContext _, VoidCallback openContainer) {
                          return _DetailsPage(pop: pops[index]);
                        },
                        tappable: false,
                        closedShape: const RoundedRectangleBorder(),
                        closedElevation: 0.0,
                        closedBuilder:
                            (BuildContext _, VoidCallback openContainer) {
                          return _buildRow(pops[index], openContainer);
                        },
                      );
                    }),
                  ],
                ),
        ));
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
                              TextStyle(fontSize: 15, color: Color(0xffe51923)),
                          hoursTextStyle:
                              TextStyle(fontSize: 15, color: Color(0xffe51923)),
                          minTextStyle:
                              TextStyle(fontSize: 15, color: Color(0xffe51923)),
                          secTextStyle:
                              TextStyle(fontSize: 15, color: Color(0xffe51923)),
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
  final Pop pop;

  openMapsSheet(context, Pop pop) async {
    try {
      final title = pop.name;
      final description = pop.subtitle;
      final coords = Coords(pop.placemark[0].position.latitude,
          pop.placemark[0].position.longitude);
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () => map.showMarker(
                          coords: coords,
                          title: title,
                          description: description,
                        ),
                        title: Text(map.mapName),
                        leading: Image(
                          image: map.icon,
                          height: 30.0,
                          width: 30.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  _DetailsPage({Key key, this.pop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pop Details')),
      body: ListView(
        children: <Widget>[
          Container(
            height: 250,
            child: ImageUtil.getPopImageWidget(pop, 200.0, 200.0),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                    child: Text(
                  pop.name,
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                )),
                const SizedBox(height: 10),
                Text(
                  pop.description,
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
                Container(
                    child: ButtonBar(children: <Widget>[
                  FlatButton.icon(
                    icon: Icon(Icons.location_on, color: Color(0xffe51923)),
                    label: Text(""),
                    onPressed: () => openMapsSheet(context, pop),
                  ),
                  FlatButton.icon(
                    textColor: Colors.blue,
                    icon: Icon(Icons.open_in_new, color: Colors.blue),
                    label: Text('Visit Pops website'),
                    onPressed: () {},
                  )
                ])),
                Container(
                    margin: EdgeInsets.all(50.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(width: 3.0, color: Color(0xffe51923)),
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CountdownTimer(
                            endTime: pop.time,
                            defaultDays: "==",
                            defaultHours: "--",
                            defaultMin: "**",
                            defaultSec: "++",
                            daysSymbol: ":",
                            hoursSymbol: ":",
                            minSymbol: ":",
                            secSymbol: "",
                            daysTextStyle: TextStyle(
                                fontSize: 30, color: Color(0xffe51923)),
                            hoursTextStyle: TextStyle(
                                fontSize: 30, color: Color(0xffe51923)),
                            minTextStyle: TextStyle(
                                fontSize: 30, color: Color(0xffe51923)),
                            secTextStyle: TextStyle(
                                fontSize: 30, color: Color(0xffe51923)),
                            daysSymbolTextStyle:
                                TextStyle(fontSize: 30, color: Colors.black),
                            hoursSymbolTextStyle:
                                TextStyle(fontSize: 30, color: Colors.black),
                            minSymbolTextStyle:
                                TextStyle(fontSize: 30, color: Colors.black),
                            secSymbolTextStyle:
                                TextStyle(fontSize: 30, color: Colors.black),
                          )
                        ]))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
