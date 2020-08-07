import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class PopClick {
  static final String popClickId = "id";
  static final String popClickDate = "date";
  static final String clickingUserLocation = "userLocation";


  PopClick({
    @required this.date,
    @required this.userLocation,
    this.id,
  });

  final DateTime date;
  final GeoPoint userLocation;
  String id;

  Map toMap() {
    Map<String, dynamic> map = {
      popClickId: id,
      popClickDate: date,
      clickingUserLocation: userLocation,
    };

    return map;
  }

  static PopClick fromMap(Map map) {
    try {

    return new PopClick(
        id: map[popClickId],
        date: (map[popClickDate] as Timestamp).toDate(),
        userLocation: map[clickingUserLocation],
    );
    } catch (e) {
      print('error is $e');
    }
  }
}