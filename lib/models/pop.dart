import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

class Pop {
  static final String popId = "_id";
  static final String popName = "name";
  static final String popSubtitle = "subtitle";
  static final String popTime = "time";
  static final String popDescription = "description";
  static final String popPhotoPath = "photo";
  static final String innerPhotoPath = "innerPhoto";
  static final String popUrl = "url";
  static final String popLat = "lat";
  static final String popLng = "lng";

  Pop({
    @required this.name,
    @required this.time,
    @required this.description,
    this.innerPhoto,
    this.subtitle,
    this.photo,
    this.url,
    this.latLng,
  });

  final String name;
  final String subtitle;
  final int time;
  final String description;
  final String photo;
  final String innerPhoto;
  final String url;
  final LatLng latLng;

  Map toMap() {
    Map<String, dynamic> map = {
      popName: name,
      popTime: time,
      popDescription: description,
      popPhotoPath: photo,
      popLat: latLng.latitude,
      popLng: latLng.longitude,
      popSubtitle: subtitle,
      innerPhotoPath: innerPhoto,
      popUrl: url
    };

    return map;
  }

  static Pop fromMap(Map map) {
    return new Pop(
        name: map[popName],
        time: map[popTime],
        description: map[popDescription],
        photo: map[popPhotoPath],
        url: map[popUrl],
        subtitle: map[popSubtitle],
        innerPhoto: map[innerPhotoPath],
        latLng: new LatLng(map[popLat], map[popLng]));
  }
}