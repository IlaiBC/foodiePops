import 'dart:collection';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:foodiepops/models/pop.dart';
import 'package:foodiepops/models/UserData.dart';
import 'package:foodiepops/screens/pops/popMapScreen.dart';
import 'package:foodiepops/services/fireStoreDatabase.dart';
import 'package:foodiepops/services/firebaseAuthService.dart';
import 'package:foodiepops/util/imageUtil.dart';
import 'package:flutter_countdown_timer/countdown_timer.dart';
import 'package:animations/animations.dart';
import 'package:foodiepops/widgets/RedeemCouponButton.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:filter_list/filter_list.dart';
import 'package:foodiepops/constants/generalConsts.dart';
import 'package:foodiepops/models/popClickCounter.dart';
import 'package:foodiepops/components/SliderShape.dart';

class PopListScreen extends StatefulWidget {
  PopListScreen({Key key, @required this.userSnapshot, @required this.userData})
      : super(key: key);
  final AsyncSnapshot<User> userSnapshot;
  final UserData userData;

  @override
  _PopListScreenState createState() => _PopListScreenState();
}

class _PopListScreenState extends State<PopListScreen> {
  ContainerTransitionType _transitionType = ContainerTransitionType.fade;
  List<Pop> pops = [];
  Set<String> likedPopsSet = {};
  Set<String> redeemedPopCouponsSet = {};
  bool finishedLoading = false;

  HashMap<String, double> popDistanceMap = new HashMap<String, double>();

  Geolocator geolocator = Geolocator();
  Position userLocation;
  bool _showFilter = false;
  int _priceRank = 0;
  double _filterDistance = 10000;
  List<String> selectedKitchenTypes = [];
  List<String> kitchenTypes = [
    "Asian",
    "Sushi",
    "Pizza",
    "Hamburger",
    "Italian",
    "American",
    "Cafe",
    "Bar",
    "Meat",
    "Fish",
    "Indian",
    "Hummus",
    "Seafood",
    "Bakery",
    "Mexican"
  ];

  @override
  void initState() {
    super.initState();
    _getLocation().then((position) {
      setState(() {
        this.userLocation = position;
        this.finishedLoading = true;
      });
    });
  }

  Future<List<Pop>> _filterPopsLocation(List<Pop> pops) async {
    List<Pop> filteredPopsList = [];

    for (var i = 0; i < pops.length; i++) {
      if (userLocation != null) {
        double distance = await _getUserDistanceFromPop(pops[i]);
        popDistanceMap.update(pops[i].id, (value) => distance,
            ifAbsent: () => distance);

        if (distance <= this._filterDistance) {
          filteredPopsList.add(pops[i]);
        }
      }
    }

    print('current pop length ${pops.length}');

    debugPrint("finished filter");
    return userLocation != null ? filteredPopsList : pops;
  }

  Future<double> _getUserDistanceFromPop(Pop pop) async {
    return geolocator.distanceBetween(userLocation.latitude,
        userLocation.longitude, pop.location.latitude, pop.location.longitude);
  }

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      GeolocationStatus geolocationStatus =
          await geolocator.checkGeolocationPermissionStatus();
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

  _handleRadioValueChange(int value) {
    setState(() {
      this._priceRank = value;
    });
  }

  void _openFilterList() async {
    var list = await FilterList.showFilterList(
      context,
      allTextList: GeneralConsts.kitchenTypes,
      height: 480,
      borderRadius: 20,
      headlineText: "Select Kitchen Types",
      searchFieldHintText: "Search Here",
      selectedTextList: selectedKitchenTypes,
      applyButonTextBackgroundColor: Color(0xffe51923),
      headerTextColor: Color(0xffe51923),
      selectedTextBackgroundColor: Color(0xffe51923),
      closeIconColor: Color(0xffe51923),
      allResetButonColor: Color(0xffe51923),
    );

    if (list != null) {
      setState(() {
        selectedKitchenTypes = List.from(list);
      });
    }
  }

  Widget _buildFilter() {
    return Card(
        child: Container(
      margin: EdgeInsets.fromLTRB(0, 50, 0, 50),
      alignment: Alignment.centerLeft,
      child: Column(children: <Widget>[
        Text(
          "Distance Of Pops From You:",
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        new Padding(
          padding: new EdgeInsets.all(30.0),
        ),
        SliderTheme(
            data: SliderThemeData(
              showValueIndicator: ShowValueIndicator.never,
              thumbShape: const ThumbShape(),
            ),
            child: Slider(
              value: _filterDistance / 1000,
              max: 40.0,
              min: 2.0,
              divisions: 19,
              label: '${_filterDistance.round() / 1000}KM',
              onChanged: (double value) {
                _filterDistance = value * 1000;
                setState(() {});
              },
            )),
        new Divider(height: 5.0, color: Color(0xffe51923)),
        new Padding(
          padding: new EdgeInsets.all(8.0),
        ),
        new Text(
          'Price Range:',
          style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Radio(
              value: 0,
              groupValue: _priceRank,
              onChanged: _handleRadioValueChange,
            ),
            new Text(
              'All',
              style: new TextStyle(fontSize: 16.0),
            ),
            new Radio(
              value: 1,
              groupValue: _priceRank,
              onChanged: _handleRadioValueChange,
            ),
            new Text(
              '₪',
              style: new TextStyle(fontSize: 16.0),
            ),
            new Radio(
              value: 2,
              groupValue: _priceRank,
              onChanged: _handleRadioValueChange,
            ),
            new Text(
              '₪₪',
              style: new TextStyle(
                fontSize: 16.0,
              ),
            ),
            new Radio(
              value: 3,
              groupValue: _priceRank,
              onChanged: _handleRadioValueChange,
            ),
            new Text(
              '₪₪₪',
              style: new TextStyle(fontSize: 16.0),
            ),
          ],
        ),
        new Divider(height: 5.0, color: Color(0xffe51923)),
        new Padding(
          padding: new EdgeInsets.all(8.0),
        ),
        new RaisedButton(
            onPressed: _openFilterList,
            color: Color(0xffe51923),
            textColor: Colors.white,
            child:
                Text('Choose Kitchen Types', style: TextStyle(fontSize: 18.0)))
      ]),
    ));
  }

  List<Pop> _applyAllFilters(List<Pop> locationFilteredPops) {
    List<Pop> filteredPops = [];

    for (int i = 0; i < locationFilteredPops.length; i++) {
      Pop currentPop = locationFilteredPops[i];

      if (currentPop.expirationTime.millisecondsSinceEpoch >
          DateTime.now().millisecondsSinceEpoch) {
        if (currentPop.priceRank == _priceRank || _priceRank == 0) {
          if (selectedKitchenTypes.length == 0) {
            filteredPops.add(currentPop);
            continue;
          } else {
            if (_popKitchenTypesContainedInSelectedKitchenTypes(
                currentPop.kitchenTypes)) {
              filteredPops.add(currentPop);
              continue;
            }
          }
        }
      }
    }

    return filteredPops;
  }

  bool _popKitchenTypesContainedInSelectedKitchenTypes(
      List<String> popKitchenTypes) {
    for (int i = 0; i < popKitchenTypes.length; i++) {
      if (selectedKitchenTypes.contains(popKitchenTypes[i]) == false) {
        return false;
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    print('*************** calling build *************');
    if (widget.userData != null) {
      likedPopsSet = widget.userData.likedPops;
      redeemedPopCouponsSet = widget.userData.redeemedPopCoupons;
      debugPrint('redeemedPopCouponsSet is: $redeemedPopCouponsSet');
    }
    final FirestoreDatabase database =
        Provider.of<FirestoreDatabase>(context, listen: false);

    return StreamBuilder<List<Pop>>(
        stream: database.getPopList(),
        builder: (context, snapshot) {
          if (snapshot.data != null && this.finishedLoading == true) {
            final List<Pop> popsFromDB = snapshot.data;
            this.pops = popsFromDB;
            return Scaffold(
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endFloat,
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
                floatingActionButton: Container(
                    height: 70,
                    width: 70,
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: FloatingActionButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PopMapScreen(
                                        pops: this.pops,
                                        database: database,
                                        userData: widget.userData,
                                        redeemedCouponSet:
                                            redeemedPopCouponsSet,
                                        userLocation: userLocation)));
                          },
                          child: Icon(Icons.map, size: 36.0),
                        ))),
                body: FutureBuilder<List<Pop>>(
                    future: _filterPopsLocation(popsFromDB),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Pop>> snapshot) {
                      if (snapshot.hasData && this.finishedLoading == true) {
                        List<Pop> locationFilteredPops = snapshot.data;
                        List<Pop> filteredPops =
                            _applyAllFilters(locationFilteredPops);
                        this.pops = filteredPops;

                        return new Column(children: <Widget>[
                          this._showFilter
                              ? _buildFilter()
                              : new Container(width: 0, height: 0),
                          filteredPops.length != 0
                              ? new Expanded(
                                  child: ListView(
                                  padding: const EdgeInsets.all(8.0),
                                  children: <Widget>[
                                    ...List<Widget>.generate(
                                        filteredPops.length, (int index) {
                                      return OpenContainer(
                                        transitionType: _transitionType,
                                        openBuilder: (BuildContext _,
                                            VoidCallback openContainer) {
                                          Pop currentPop = filteredPops[index];
                                          return DetailsPage(
                                              database: database,
                                              userData: widget.userData,
                                              pop: currentPop,
                                              redeemedCouponSet:
                                                  redeemedPopCouponsSet);
                                        },
                                        tappable: false,
                                        closedShape:
                                            const RoundedRectangleBorder(),
                                        closedElevation: 0.0,
                                        closedBuilder: (BuildContext _,
                                            VoidCallback openContainer) {
                                          return _buildRow(
                                              filteredPops[index],
                                              openContainer,
                                              database,
                                              userLocation,
                                              context);
                                        },
                                      );
                                    }),
                                  ],
                                ))
                              : Column(children: [
                                  this._showFilter
                                      ? SizedBox(height: 50)
                                      : SizedBox(height: 200),
                                  Center(
                                      child: Text(
                                          'No Pops available/meet your criteria',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold))),
                                ])
                        ]);
                      }

                      return new Center(child: new CircularProgressIndicator());
                    }));
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  String _getPopDistanceText(String popId) {
    double popDistance = popDistanceMap[popId];

    return popDistance != null
        ? '${((popDistance) / 1000).toStringAsFixed(2)} KM  |'
        : '';
  }

  Widget _buildRow(Pop pop, VoidCallback openContainer,
      FirestoreDatabase database, Position userLocation, BuildContext context) {
    return StreamBuilder<PopClickCounter>(
        stream: database.popLikeCounterStream(pop.id),
        builder: (context, snapshot) {
          return new Card(
              child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: new Row(mainAxisSize: MainAxisSize.max, children: <
                        Widget>[
                      new Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new ClipRRect(
                              borderRadius: new BorderRadius.circular(4.0),
                              child: ImageUtil.getPopImageWidget(
                                  pop, 80.0, 80.0, false),
                            ),
                          ]),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                      ),
                      new Expanded(
                          child: new Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                            new Text(
                              pop.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  new Text(_getPopDistanceText(pop.id),
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold)),
                                  new IconButton(
                                      icon: Icon(Icons.restaurant,
                                          color: likedPopsSet.contains(pop.id)
                                              ? Colors.red
                                              : Colors.grey),
                                      onPressed: () {
                                        if (widget.userData != null) {
                                          database
                                              .addLikeToPop(
                                                  widget.userSnapshot.hasData
                                                      ? widget
                                                          .userSnapshot.data.uid
                                                      : null,
                                                  pop,
                                                  userLocation,
                                                  snapshot.data != null
                                                      ? snapshot.data.counter
                                                      : 0)
                                              .catchError((e) =>
                                                  Scaffold.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(e))));

                                          likedPopsSet.add(pop.id);
                                          database.setLikedPops(
                                              widget.userData, likedPopsSet);
                                        } else {
                                          Scaffold.of(context).showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      "Login to show your love")));
                                        }
                                      }),
                                  new Text(
                                      snapshot.data != null
                                          ? snapshot.data.counter.toString()
                                          : "0",
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold)),
                                ])
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
                              Container(
                                  padding: const EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                    color: Color(0xffe51923),
                                    border: Border.all(
                                        width: 1.0, color: Colors.red),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  child: new ClipRRect(
                                    borderRadius:
                                        new BorderRadius.circular(4.0),
                                    child: CountdownTimer(
                                        endTime: pop.expirationTime
                                            .millisecondsSinceEpoch,
                                        defaultDays: "==",
                                        defaultHours: "--",
                                        defaultMin: "**",
                                        defaultSec: "++",
                                        daysSymbol: ":",
                                        hoursSymbol: ":",
                                        minSymbol: "",
                                        secSymbol: "",
                                        daysTextStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        hoursTextStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        minTextStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        secTextStyle: TextStyle(
                                            fontSize: 0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        daysSymbolTextStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        hoursSymbolTextStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        minSymbolTextStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ))
                            ]),
                      )
                    ]),
                  ),
                  onTap: () {
                    database.addPopClick(pop, userLocation);
                    openContainer();
                  }));
        });
  }
}

class DetailsPage extends StatefulWidget {
  DetailsPage(
      {Key key,
      this.pop,
      this.redeemedCouponSet,
      this.database,
      this.userData,
      this.userLocation})
      : super(key: key);
  final Pop pop;
  final Set<String> redeemedCouponSet;
  final FirestoreDatabase database;
  final UserData userData;
  final Position userLocation;

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool isRedeemingCoupon = false;

  getPopUrl(String url) {
    String popUrlToParse = (url.contains("http://") || url.contains("https://"))
        ? url
        : 'https://$url';
    return popUrlToParse;
  }

  openMapsSheet(context, Pop pop) async {
    try {
      final title = pop.name;
      final description = pop.subtitle;
      final coords = Coords(pop.location.latitude, pop.location.longitude);
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

  Future<Null> _openInWebview(context, String url) async {
    if (await url_launcher.canLaunch(url)) {
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

  void _redeemCoupon(previousRedeemCount) async {
    setState(() {
      this.isRedeemingCoupon = true;
    });
    await widget.database.redeemCoupon(widget.userData.id, widget.pop,
        widget.userLocation, previousRedeemCount);
    widget.redeemedCouponSet.add(widget.pop.id);
    await widget.database
        .setRedeemedCoupons(widget.userData, widget.redeemedCouponSet);
    setState(() {
      this.isRedeemingCoupon = false;
    });
  }

  Widget _popCouponDetailsWidget(context) {
    if (widget.database != null) {
      return StreamBuilder<PopClickCounter>(
          stream: widget.database.popCouponRedeemCounterStream(widget.pop.id),
          builder:
              (BuildContext context, AsyncSnapshot<PopClickCounter> snapshot) {
            final PopClickCounter redeemCount = snapshot.data;
            final int countToDisplay =
                redeemCount != null ? redeemCount.counter : 0;
            return Center(
                child: Column(children: [
              Text('$countToDisplay Coupons already redeemed!',
                                style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),),
                      SizedBox(height: 15),
              widget.redeemedCouponSet.contains(widget.pop.id)
                  ? Text('Coupon: ${widget.pop.coupon}',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),)
                  : RedeemCouponButton(
                      loading: isRedeemingCoupon,
                      text: "Redeem coupon",
                      onPressed: () {
                        if (widget.userData != null) {
                          _redeemCoupon(countToDisplay);
                        } else {
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Login to redeem this coupon")));
                        }
                      })
            ]));
          });
    }

    return Center(
      child: Text('Coupon: ${widget.pop.coupon}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pop Details')),
      body: ListView(
        children: <Widget>[
          Container(
            height: 250,
            child: ImageUtil.getPopImageWidget(widget.pop, 200.0, 200.0, true),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                    child: Text(
                  widget.pop.name,
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                )),
                const SizedBox(height: 10),
                Text(
                  widget.pop.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0, color: Colors.black87),
                ),
                Container(
                    child: ButtonBar(children: <Widget>[
                  FlatButton.icon(
                    icon: Icon(Icons.location_on, color: Color(0xffe51923)),
                    label: Text(""),
                    onPressed: () => openMapsSheet(context, widget.pop),
                  ),
                  FlatButton.icon(
                    textColor: Colors.blue,
                    icon: Icon(Icons.open_in_new, color: Colors.blue),
                    label: Text('Visit Pops website'),
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      this._openInWebview(context, getPopUrl(widget.pop.url));
                    },
                  )
                ])),
                _popCouponDetailsWidget(context),
                Container(
                    margin: EdgeInsets.all(50.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Color(0xffe51923),
                      border: Border.all(width: 3.0, color: Colors.red),
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CountdownTimer(
                            endTime: widget
                                .pop.expirationTime.millisecondsSinceEpoch,
                            defaultDays: "==",
                            defaultHours: "--",
                            defaultMin: "**",
                            defaultSec: "",
                            daysSymbol: "d ",
                            hoursSymbol: "h ",
                            minSymbol: "m",
                            secSymbol: "",
                            daysTextStyle:
                                TextStyle(fontSize: 30, color: Colors.white),
                            hoursTextStyle:
                                TextStyle(fontSize: 30, color: Colors.white),
                            minTextStyle:
                                TextStyle(fontSize: 30, color: Colors.white),
                            secTextStyle:
                                TextStyle(fontSize: 0, color: Colors.white),
                            daysSymbolTextStyle:
                                TextStyle(fontSize: 30, color: Colors.white),
                            hoursSymbolTextStyle:
                                TextStyle(fontSize: 30, color: Colors.white),
                            minSymbolTextStyle:
                                TextStyle(fontSize: 30, color: Colors.white),
                          ),
                        ]))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
