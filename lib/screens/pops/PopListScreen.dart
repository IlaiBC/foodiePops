import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:foodiepops/models/pop.dart';
import 'package:foodiepops/services/fireStoreDatabase.dart';
import 'package:foodiepops/util/imageUtil.dart';
import 'package:flutter_countdown_timer/countdown_timer.dart';
import 'package:animations/animations.dart';
import 'package:provider/provider.dart';
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
  bool _showFilter = false;
  double _filterDistance = 10000;

  @override
  void initState() {
    super.initState();

    _getLocation().then((position) {
      print('getting location $position' );
      setState(() {
        this.userLocation = position;
      });
    });
  }


  Future<List<Pop>> _filterPopsLocation(List<Pop> pops) async {
    List<int> toFilter = [];

    for (var i = 0; i < pops.length; i++) {
      print('user location is: $userLocation');
      if (userLocation != null) {
        double distance = await _getUserDistanceFromPop(pops[i]);
        debugPrint("Distance: $distance");
        print('distance is: $distance');
        if (distance > this._filterDistance) {
          debugPrint("should filter");
          toFilter.add(i);
        }
      }
    }

print('to filter is: $toFilter');
print('pops is: $pops');
    for (var index in toFilter) {
      debugPrint("removed $index");

      pops.removeAt(index);
    }

    print('current pop length ${pops.length}');

    debugPrint("finished filter");
    return pops;
  }


  Future<double> _getUserDistanceFromPop(Pop pop) async {
    return geolocator.distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        pop.location.latitude,
        pop.location.longitude);
  }

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      GeolocationStatus geolocationStatus =
          await geolocator.checkGeolocationPermissionStatus();
      debugPrint(geolocationStatus.toString());
      if (geolocationStatus != GeolocationStatus.denied ||
          geolocationStatus != GeolocationStatus.disabled) {
        currentLocation = await geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
      }
    } catch (e) {
      print('error getting user location $e');
      currentLocation = null;
    }
    return currentLocation;
  }

  Widget _buildFilter() {
    return Container(
      margin: EdgeInsets.only(top: 50, left: 50, right: 50),
      alignment: Alignment.centerLeft,
      child: Column(
          children: <Widget> [
            Text("Set the maximum distance of pops from you",
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 18.0, fontWeight: FontWeight.bold),),
            Slider(
        value: _filterDistance/1000,
        max: 100,
        min: 5.0,
        divisions: 19,
        label: '${_filterDistance.round()/1000}KM',
        onChanged: (double value) {
          _filterDistance = value * 1000;
          setState(() {});
        },
      )]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final FirestoreDatabase database =
        Provider.of<FirestoreDatabase>(context, listen: false);

    return StreamBuilder<List<Pop>>(
        stream: database.getPopList(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            final List<Pop> popsFromDB = snapshot.data;

            return Scaffold(
            appBar: AppBar(
              title: const Text('Foodie Pops you will love'),
              automaticallyImplyLeading: false,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () => {
                    setState(() {
                      this._showFilter = !this._showFilter;
                    })
                  },
                )
              ],
            ),
        body: FutureBuilder<List<Pop>>(future: _filterPopsLocation(popsFromDB),
        builder: (BuildContext context, AsyncSnapshot<List<Pop>> snapshot) {

          if (snapshot.hasData) {
          List<Pop> filteredPops = snapshot.data;
            print('filtered pops length: ${filteredPops.length}');
            return new Column(
              children: <Widget>[
                this._showFilter ? _buildFilter() : new Container(width: 0, height: 0),
                  new Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(8.0),
                    children: <Widget>[
                      ...List<Widget>.generate(filteredPops.length, (int index) {
                        return OpenContainer(
                          transitionType: _transitionType,
                          openBuilder:
                              (BuildContext _, VoidCallback openContainer) {
                            return _DetailsPage(pop: filteredPops[index]);
                          },
                          tappable: false,
                          closedShape: const RoundedRectangleBorder(),
                          closedElevation: 0.0,
                          closedBuilder:
                              (BuildContext _, VoidCallback openContainer) {
                            return _buildRow(filteredPops[index], openContainer, database);
                          },
                        );
                      }),
                    ],
                  ))
                ]);
          }
         
          return new Center(child: new CircularProgressIndicator());
        }
          
          
          ) 
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}

Widget _buildRow(
    Pop pop, VoidCallback openContainer, FirestoreDatabase database) {
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
                          endTime: pop.expirationTime.millisecondsSinceEpoch,
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
          onTap: () {
            print('pop is: ${pop.businessId}');
            database.addPopClick(pop);
            openContainer();
          }));
}

class _DetailsPage extends StatelessWidget {
  final Pop pop;

  openMapsSheet(context, Pop pop) async {
    try {
      final title = pop.name;
      final description = pop.subtitle;
      final coords = Coords(pop.location.latitude,
          pop.location.longitude);
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
                            endTime: pop.expirationTime.millisecondsSinceEpoch,
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
