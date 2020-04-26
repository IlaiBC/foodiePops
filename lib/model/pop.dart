import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

class Pop {
  static final String popId = "_id";
  static final String popName = "name";
  static final String popTime = "time";
  static final String popDescription = "description";
  static final String popPhotoUrl = "photo";
  static final String popLat = "lat";
  static final String popLng = "lng";

  Pop({
    @required this.name,
    @required this.time,
    this.description,
    this.photoUrl,
    this.latLng,
  });

  final String name;
  final int time;
  final String description;
  final String photoUrl;
  final LatLng latLng;

  Map toMap() {
    Map<String, dynamic> map = {
      popName: name,
      popTime: time,
      popDescription: description,
      popPhotoUrl: photoUrl,
      popLat: latLng.latitude,
      popLng: latLng.longitude
    };

    return map;
  }

  static Pop fromMap(Map map) {
    return new Pop(
        name: map[popName],
        time: map[popTime],
        description: map[popDescription],
        photoUrl: map[popPhotoUrl],
        latLng: new LatLng(map[popLat], map[popLng]));
  }
}