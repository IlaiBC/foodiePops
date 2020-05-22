import 'package:geolocator/geolocator.dart';
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
  static final String popAddress = "address";
  List<Placemark> placemark;

  Pop({
    @required this.name,
    @required this.time,
    @required this.description,
    this.innerPhoto,
    this.subtitle,
    this.photo,
    this.url,
    this.address,
    this.placemark
  });

  final String name;
  final String subtitle;
  final int time;
  final String description;
  final String photo;
  final String innerPhoto;
  final String url;
  final String address;

  Map toMap() {
    Map<String, dynamic> map = {
      popName: name,
      popTime: time,
      popDescription: description,
      popPhotoPath: photo,
      popAddress: address,
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
        address: map[popAddress]);
  }
}
