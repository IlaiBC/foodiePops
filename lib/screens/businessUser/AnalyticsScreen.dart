import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:foodiepops/constants/Texts.dart';
import 'package:foodiepops/models/pop.dart';
import 'package:foodiepops/models/popClick.dart';
import 'package:foodiepops/services/fireStoreDatabase.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:geolocator/geolocator.dart';

class BusinessAnalyticsScreen extends StatelessWidget {
  BusinessAnalyticsScreen({Key key, @required this.businessId}) : super(key: key);
  final String businessId;

  @override
  Widget build(BuildContext context) {
      final FirestoreDatabase database =
      Provider.of<FirestoreDatabase>(context, listen: false);
    return Container(child: StreamBuilder<List<Pop>>(
        stream: database.getBusinessPopList(businessId),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            final List<Pop> pops = snapshot.data;
            print('pops result $pops');
            return Scaffold(
              appBar: AppBar(
                title: const Text(Texts.analyticsScreen),
              ),
              body: ListView(
                padding: const EdgeInsets.all(8.0),
                children: <Widget>[
                  ...List<Widget>.generate(pops.length, (int index) {
                    return Container(height: 700, child: Center(child: Column(children: <Widget>[
                      Text(
                      pops[index].name,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                                          Text(
                      'Number of clicks by date',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                      Container(height: 300, child: _showPopClickData(pops[index], database),),
                                                           Text(
                      'Number of clicks by location',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                      Container(height: 300, child: _showPopClickLocationChart(pops[index], database),),

                    ],),));
                  }),
                ],
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }));


  }

  Widget _showPopClickData(Pop pop, FirestoreDatabase database) {
      return 
       StreamBuilder<List<PopClick>>(
        stream: database.getPopClickList(businessId, pop.id),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            final List<PopClick> popClicks = snapshot.data;
            final List<PopClickAnalytics> popClickAnalytics = _parsePopClickAnalytics(popClicks);
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
                    format: 'dd/MM', transitionFormat: 'dd/MM/yy')))
    );
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

  
  Widget _showPopClickLocationChart(Pop pop, FirestoreDatabase database) {
      return 
       StreamBuilder<List<PopClick>>(
        stream: database.getPopClickList(businessId, pop.id),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            final List<PopClick> popClicks = snapshot.data;
            debugPrint("got pop clicks ${popClicks.length}");
            return FutureBuilder<List<PopClickLocationAnalytics>>(
              future: _parsePopClickLocationAnalytics(popClicks),
              builder: (BuildContext context,
                        AsyncSnapshot<List<PopClickLocationAnalytics>> snapshot) {
                      if (snapshot.hasData) {
                        final List<PopClickLocationAnalytics> popClickLocationAnalytics = snapshot.data;

                        return new charts.PieChart(_popClickLocationAnalyticsToChart(popClickLocationAnalytics),
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
            arcRendererDecorators: [new charts.ArcLabelDecorator(labelPosition: charts.ArcLabelPosition.inside)]));
                      }
                      return Center(
              child: CircularProgressIndicator());
                        });
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  

  List<PopClickAnalytics> _parsePopClickAnalytics (List<PopClick> popClicksData) {
    HashMap<DateTime, int> popClickDataMap = new HashMap<DateTime, int>();
    List<PopClickAnalytics> popClickAnalytics = [];

    for (int i = 0; i < popClicksData.length; i++) {
      PopClick currentPopClick = popClicksData[i];
      DateTime dateTimeDayResolution = new DateTime(currentPopClick.date.year, currentPopClick.date.month, currentPopClick.date.day);
      print('dateTimeResolution: $dateTimeDayResolution');

      popClickDataMap.update(dateTimeDayResolution, (value) => value + 1, ifAbsent: () => 1);
    }

    popClickDataMap.keys.forEach((element) {print('inserting to list $element'); popClickAnalytics.add(PopClickAnalytics(popClickDate: element, popClickCount: popClickDataMap[element]));});

    return popClickAnalytics;
  }

    Future<List<PopClickLocationAnalytics>> _parsePopClickLocationAnalytics (List<PopClick> popClicksData) async {
    HashMap<String, int> popClickDataMap = new HashMap<String, int>();
    List<PopClickLocationAnalytics> popClickLocationAnalytics = [];

    for (int i = 0; i < popClicksData.length; i++) {
      PopClick currentPopClick = popClicksData[i];
      debugPrint('before to get placeMakr popclick is: $currentPopClick');

      debugPrint('going to get placeMakr');
      debugPrint('going to get placeMakr  ${currentPopClick.userLocation}');

      List<Placemark> placemark = currentPopClick.userLocation != null ? await Geolocator().placemarkFromCoordinates(currentPopClick.userLocation.latitude, currentPopClick.userLocation.longitude) : [];

      popClickDataMap.update(placemark.length > 0 ? placemark[0].locality : "N/A", (value) => value + 1, ifAbsent: () => 1);
    }

    debugPrint('after popClickData update');

    popClickDataMap.keys.forEach((element) {print('inserting to list $element'); popClickLocationAnalytics.add(PopClickLocationAnalytics(clickLocation: element, popClickCount: popClickDataMap[element]));});

    debugPrint('after popClickData update for each');

    return popClickLocationAnalytics;
  }

  List<charts.Series<PopClickAnalytics, DateTime>> _popClickAnalyticsToChart(List<PopClickAnalytics> popClickAnalytics) {
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

    List<charts.Series<PopClickLocationAnalytics, String>> _popClickLocationAnalyticsToChart(List<PopClickLocationAnalytics> popClickLocationAnalytics) {
    return [
      new charts.Series<PopClickLocationAnalytics, String>(
        id: 'popClicksByLocation',
        colorFn: (_, index){
      return charts.MaterialPalette.red.makeShades(5)[index];
    },
        domainFn: (PopClickLocationAnalytics popClick, _) => popClick.clickLocation,
        measureFn: (PopClickLocationAnalytics popClick, _) => popClick.popClickCount,
        data: popClickLocationAnalytics,
        labelAccessorFn: (PopClickLocationAnalytics popClick, _) => '${popClick.clickLocation}:${popClick.popClickCount}'
      ),
    ];
  }
}

class PopClickAnalytics {
  final DateTime popClickDate;
  final int popClickCount;

  PopClickAnalytics(
      {this.popClickDate, this.popClickCount});
}

class PopClickLocationAnalytics {
  final String clickLocation;
  final int popClickCount;

  PopClickLocationAnalytics(
      {this.clickLocation, this.popClickCount});
}


