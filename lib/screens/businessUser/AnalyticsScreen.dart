import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:foodiepops/constants/Texts.dart';
import 'package:foodiepops/models/pop.dart';
import 'package:foodiepops/models/popClick.dart';
import 'package:foodiepops/services/fireStoreDatabase.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:geolocator/geolocator.dart';

class BusinessAnalyticsScreen extends StatefulWidget {
  BusinessAnalyticsScreen({Key key, @required this.businessId})
      : super(key: key);
  final String businessId;

  @override
  BusinessAnalyticsScreenState createState() => BusinessAnalyticsScreenState();
}

class BusinessAnalyticsScreenState extends State<BusinessAnalyticsScreen> {
  String selectedPopId;

  @override
  Widget build(BuildContext context) {
    final FirestoreDatabase database =
        Provider.of<FirestoreDatabase>(context, listen: false);
    return Container(
        child: StreamBuilder<List<Pop>>(
            stream: database.getBusinessPopList(widget.businessId),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                final List<Pop> pops = snapshot.data;
                if (pops.length == 0) {
                  return Center(
                      child: Text(
                    "No Analytics Data",
                    style: TextStyle(fontSize: 20),
                  ));
                }
                print('pops result $pops');
                return Scaffold(
                  appBar: AppBar(
                    title: const Text(Texts.analyticsScreen),
                  ),
                  body: SingleChildScrollView(
                      child: Container(
                          height: 1500,
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                DropdownButton<String>(
                                    value: selectedPopId != null
                                        ? selectedPopId
                                        : pops[0].id,
                                    icon: Icon(
                                      Icons.restaurant,
                                      color: Colors.red,
                                    ),
                                    elevation: 16,
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 20),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.red,
                                    ),
                                    onChanged: (String selectedPopId) {
                                      setState(() {
                                        this.selectedPopId = selectedPopId;
                                      });
                                    },
                                    items: pops.map<DropdownMenuItem<String>>(
                                        (Pop currentPop) {
                                      return DropdownMenuItem<String>(
                                        value: currentPop.id,
                                        child: Text(currentPop.name),
                                      );
                                    }).toList()),
                                SizedBox(height: 10),
                                Text(
                                  'Number of clicks by date',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  height: 300,
                                  child: _showPopClickData(
                                      selectedPopId != null
                                          ? selectedPopId
                                          : pops[0].id,
                                      database),
                                ),
                                SizedBox(height: 30),
                                Text(
                                  'Number of clicks by location',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  height: 300,
                                  child: _showPopClickLocationChart(
                                      selectedPopId != null
                                          ? selectedPopId
                                          : pops[0].id,
                                      database),
                                ),
                                Text(
                                  'Coupons redeemed by date',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  height: 300,
                                  child: _showPopCouponData(
                                      selectedPopId != null
                                          ? selectedPopId
                                          : pops[0].id,
                                      database),
                                ),
                                SizedBox(height: 30),
                                Text(
                                  'Coupons redeemed by location',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  height: 300,
                                  child: _showPopCouponLocationChart(
                                      selectedPopId != null
                                          ? selectedPopId
                                          : pops[0].id,
                                      database),
                                ),
                              ],
                            ),
                          ))),
                );
              }
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }));
  }

  Widget _showPopClickData(String popId, FirestoreDatabase database) {
    return StreamBuilder<List<PopClick>>(
        stream: database.getPopClickList(widget.businessId, popId),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            final List<PopClick> popClicks = snapshot.data;
            final List<PopClickAnalytics> popClickAnalytics =
                _parsePopClickAnalytics(popClicks);
            return new charts.TimeSeriesChart(
                _popClickAnalyticsToChart(popClickAnalytics),
                animate: true,
                // Custom renderer configuration for the point series.
                // Optionally pass in a [DateTimeFactory] used by the chart. The factory
                // should create the same type of [DateTime] as the data provided. If none
                // specified, the default creates local date time.
                domainAxis: new charts.DateTimeAxisSpec(
                    tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
                        day: new charts.TimeFormatterSpec(
                            format: 'dd/MM', transitionFormat: 'dd/MM/yy'))));
            // return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            //   Text('Pop name: ${pop.name}'),
            //   const SizedBox(width: 20),
            //   Text('Pop clicks: ${popClicks.length}'),
            // ]);
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  Widget _showPopClickLocationChart(String popId, FirestoreDatabase database) {
    return StreamBuilder<List<PopClick>>(
        stream: database.getPopClickList(widget.businessId, popId),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            final List<PopClick> popClicks = snapshot.data;
            debugPrint("got pop clicks ${popClicks.length}");
            return FutureBuilder<List<PopClickLocationAnalytics>>(
                future: _parsePopClickLocationAnalytics(popClicks),
                builder: (BuildContext context,
                    AsyncSnapshot<List<PopClickLocationAnalytics>> snapshot) {
                  if (snapshot.hasData) {
                    final List<PopClickLocationAnalytics>
                        popClickLocationAnalytics = snapshot.data;

                    return new charts.PieChart(
                        _popClickLocationAnalyticsToChart(
                            popClickLocationAnalytics),
                        animate: true,
                        // Configure the width of the pie slices to 60px. The remaining space in
                        // the chart will be left as a hole in the center.
                        //
                        // [ArcLabelDecorator] will automatically position the label inside the
                        // arc if the label will fit. If the label will not fit, it will draw
                        // outside of the arc with a leader line. Labels can always display
                        // inside or outside using [LabelPosition].
                        //
                        // Text style for inside / outside can be controlled independently by
                        // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
                        //
                        // Example configuring different styles for inside/outside:
                        //       new charts.ArcLabelDecorator(
                        //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
                        //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
                        defaultRenderer: new charts.ArcRendererConfig(
                            arcWidth: 90,
                            arcRendererDecorators: [
                              new charts.ArcLabelDecorator(
                                  labelPosition: charts.ArcLabelPosition.inside)
                            ]));
                  }
                  return Center(child: CircularProgressIndicator());
                });
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

    Widget _showPopCouponData(String popId, FirestoreDatabase database) {
    return StreamBuilder<List<PopClick>>(
        stream: database.getPopCouponsRedeemedList(widget.businessId, popId),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            final List<PopClick> popCouponsData = snapshot.data;
            if (popCouponsData.length > 0) {

            final List<PopClickAnalytics> popCouponAnalytics =
                _parsePopCouponAnalytics(popCouponsData);
            return new charts.TimeSeriesChart(
                _popCouponAnalyticsToChart(popCouponAnalytics),
                animate: true,
                // Custom renderer configuration for the point series.
                // Optionally pass in a [DateTimeFactory] used by the chart. The factory
                // should create the same type of [DateTime] as the data provided. If none
                // specified, the default creates local date time.
                domainAxis: new charts.DateTimeAxisSpec(
                    tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
                        day: new charts.TimeFormatterSpec(
                            format: 'dd/MM', transitionFormat: 'dd/MM/yy'))));
            // return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            //   Text('Pop name: ${pop.name}'),
            //   const SizedBox(width: 20),
            //   Text('Pop clicks: ${popClicks.length}'),
            // ]);
            }
              return Scaffold(
            body: Center(
              child: Text("No Coupons redeemed yet")
            ),
          ); 

          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  Widget _showPopCouponLocationChart(String popId, FirestoreDatabase database) {
    return StreamBuilder<List<PopClick>>(
        stream: database.getPopCouponsRedeemedList(widget.businessId, popId),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            final List<PopClick> popCouponsData = snapshot.data;
            if (popCouponsData.length > 0) {

            return FutureBuilder<List<PopClickLocationAnalytics>>(
                future: _parsePopCouponLocationAnalytics(popCouponsData),
                builder: (BuildContext context,
                    AsyncSnapshot<List<PopClickLocationAnalytics>> snapshot) {
                  if (snapshot.hasData) {
                    final List<PopClickLocationAnalytics>
                        popCouponsLocationAnalytics = snapshot.data;

                    return new charts.PieChart(
                        _popCouponLocationAnalyticsToChart(
                            popCouponsLocationAnalytics),
                        animate: true,
                        // Configure the width of the pie slices to 60px. The remaining space in
                        // the chart will be left as a hole in the center.
                        //
                        // [ArcLabelDecorator] will automatically position the label inside the
                        // arc if the label will fit. If the label will not fit, it will draw
                        // outside of the arc with a leader line. Labels can always display
                        // inside or outside using [LabelPosition].
                        //
                        // Text style for inside / outside can be controlled independently by
                        // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
                        //
                        // Example configuring different styles for inside/outside:
                        //       new charts.ArcLabelDecorator(
                        //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
                        //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
                        defaultRenderer: new charts.ArcRendererConfig(
                            arcWidth: 90,
                            arcRendererDecorators: [
                              new charts.ArcLabelDecorator(
                                  labelPosition: charts.ArcLabelPosition.inside)
                            ]));
                  }
                  return Center(child: CircularProgressIndicator());
                });
            }
          return Scaffold(
            body: Center(
              child: Text("No Coupons redeemed yet")
            ),
          );
          }
          
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  List<PopClickAnalytics> _parsePopClickAnalytics(
      List<PopClick> popClicksData) {
    HashMap<DateTime, int> popClickDataMap = new HashMap<DateTime, int>();
    List<PopClickAnalytics> popClickAnalytics = [];

    for (int i = 0; i < popClicksData.length; i++) {
      PopClick currentPopClick = popClicksData[i];
      DateTime dateTimeDayResolution = new DateTime(currentPopClick.date.year,
          currentPopClick.date.month, currentPopClick.date.day);
      print('dateTimeResolution: $dateTimeDayResolution');

      popClickDataMap.update(dateTimeDayResolution, (value) => value + 1,
          ifAbsent: () => 1);
    }

    popClickDataMap.keys.forEach((element) {
      print('inserting to list $element');
      popClickAnalytics.add(PopClickAnalytics(
          popClickDate: element, popClickCount: popClickDataMap[element]));
    });

    return popClickAnalytics;
  }

  Future<List<PopClickLocationAnalytics>> _parsePopClickLocationAnalytics(
      List<PopClick> popClicksData) async {
    HashMap<String, int> popClickDataMap = new HashMap<String, int>();
    List<PopClickLocationAnalytics> popClickLocationAnalytics = [];

    for (int i = 0; i < popClicksData.length; i++) {
      PopClick currentPopClick = popClicksData[i];
      debugPrint('before to get placeMakr popclick is: $currentPopClick');

      debugPrint('going to get placeMakr');
      debugPrint('going to get placeMakr  ${currentPopClick.userLocation}');

      List<Placemark> placemark = currentPopClick.userLocation != null
          ? await Geolocator().placemarkFromCoordinates(
              currentPopClick.userLocation.latitude,
              currentPopClick.userLocation.longitude)
          : [];

      popClickDataMap.update(
          placemark.length > 0 ? placemark[0].locality : "N/A",
          (value) => value + 1,
          ifAbsent: () => 1);
    }

    debugPrint('after popClickData update');

    popClickDataMap.keys.forEach((element) {
      print('inserting to list $element');
      popClickLocationAnalytics.add(PopClickLocationAnalytics(
          clickLocation: element, popClickCount: popClickDataMap[element]));
    });

    debugPrint('after popClickData update for each');

    return popClickLocationAnalytics;
  }

  List<charts.Series<PopClickAnalytics, DateTime>> _popClickAnalyticsToChart(
      List<PopClickAnalytics> popClickAnalytics) {
    popClickAnalytics.sort((a, b) => a.popClickDate.compareTo(b.popClickDate));
    return [
      new charts.Series<PopClickAnalytics, DateTime>(
        id: 'popClicks',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (PopClickAnalytics popClick, _) => popClick.popClickDate,
        measureFn: (PopClickAnalytics popClick, _) => popClick.popClickCount,
        data: popClickAnalytics,
      ),
    ];
  }

  List<charts.Series<PopClickLocationAnalytics, String>>
      _popClickLocationAnalyticsToChart(
          List<PopClickLocationAnalytics> popClickLocationAnalytics) {
    return [
      new charts.Series<PopClickLocationAnalytics, String>(
          id: 'popClicksByLocation',
          colorFn: (_, index) {
            return charts.MaterialPalette.red.makeShades(5)[index];
          },
          domainFn: (PopClickLocationAnalytics popClick, _) =>
              popClick.clickLocation,
          measureFn: (PopClickLocationAnalytics popClick, _) =>
              popClick.popClickCount,
          data: popClickLocationAnalytics,
          labelAccessorFn: (PopClickLocationAnalytics popClick, _) =>
              '${popClick.clickLocation}:${popClick.popClickCount}'),
    ];
  }
}

List<PopClickAnalytics> _parsePopCouponAnalytics(
      List<PopClick> popCouponData) {
    HashMap<DateTime, int> popCouponDataMap = new HashMap<DateTime, int>();
    List<PopClickAnalytics> popCouponAnalytics = [];

    for (int i = 0; i < popCouponData.length; i++) {
      PopClick currentPopCoupon = popCouponData[i];
      DateTime dateTimeDayResolution = new DateTime(currentPopCoupon.date.year,
          currentPopCoupon.date.month, currentPopCoupon.date.day);

      popCouponDataMap.update(dateTimeDayResolution, (value) => value + 1,
          ifAbsent: () => 1);
    }

    popCouponDataMap.keys.forEach((element) {
      print('inserting to list $element');
      popCouponAnalytics.add(PopClickAnalytics(
          popClickDate: element, popClickCount: popCouponDataMap[element]));
    });

    return popCouponAnalytics;
  }

  Future<List<PopClickLocationAnalytics>> _parsePopCouponLocationAnalytics(
      List<PopClick> popCouponData) async {
    HashMap<String, int> popCouponDataMap = new HashMap<String, int>();
    List<PopClickLocationAnalytics> popCouponLocationAnalytics = [];

    for (int i = 0; i < popCouponData.length; i++) {
      PopClick currentPopCoupon = popCouponData[i];
      List<Placemark> placemark = currentPopCoupon.userLocation != null
          ? await Geolocator().placemarkFromCoordinates(
              currentPopCoupon.userLocation.latitude,
              currentPopCoupon.userLocation.longitude)
          : [];

      popCouponDataMap.update(
          placemark.length > 0 ? placemark[0].locality : "N/A",
          (value) => value + 1,
          ifAbsent: () => 1);
    }

    debugPrint('after popClickData update');

    popCouponDataMap.keys.forEach((element) {
      print('inserting to list $element');
      popCouponLocationAnalytics.add(PopClickLocationAnalytics(
          clickLocation: element, popClickCount: popCouponDataMap[element]));
    });

    debugPrint('after popClickData update for each');

    return popCouponLocationAnalytics;
  }


  List<charts.Series<PopClickAnalytics, DateTime>> _popCouponAnalyticsToChart(
      List<PopClickAnalytics> popCouponAnalytics) {
    popCouponAnalytics.sort((a, b) => a.popClickDate.compareTo(b.popClickDate));
    return [
      new charts.Series<PopClickAnalytics, DateTime>(
        id: 'popCoupons',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (PopClickAnalytics popClick, _) => popClick.popClickDate,
        measureFn: (PopClickAnalytics popClick, _) => popClick.popClickCount,
        data: popCouponAnalytics,
      ),
    ];
  }

  List<charts.Series<PopClickLocationAnalytics, String>>
      _popCouponLocationAnalyticsToChart(
          List<PopClickLocationAnalytics> popCouponsLocationAnalytics) {
    return [
      new charts.Series<PopClickLocationAnalytics, String>(
          id: 'popCouponsByLocation',
          colorFn: (_, index) {
            return charts.MaterialPalette.red.makeShades(5)[index];
          },
          domainFn: (PopClickLocationAnalytics popClick, _) =>
              popClick.clickLocation,
          measureFn: (PopClickLocationAnalytics popClick, _) =>
              popClick.popClickCount,
          data: popCouponsLocationAnalytics,
          labelAccessorFn: (PopClickLocationAnalytics popClick, _) =>
              '${popClick.clickLocation}:${popClick.popClickCount}'),
    ];
  }

class PopClickAnalytics {
  final DateTime popClickDate;
  final int popClickCount;

  PopClickAnalytics({this.popClickDate, this.popClickCount});
}

class PopClickLocationAnalytics {
  final String clickLocation;
  final int popClickCount;

  PopClickLocationAnalytics({this.clickLocation, this.popClickCount});
}
