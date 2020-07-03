import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class Pop {
  static final String popId = "id";
  static final String popName = "name";
  static final String popSubtitle = "subtitle";
  static final String popExpirationTime = "expirationTime";
  static final String popDescription = "description";
  static final String popPhotoPath = "photo";
  static final String innerPhotoPath = "innerPhoto";
  static final String popUrl = "url";
  static final String popLocation = "location";
  static final String popAddress = "address";
  static final String popBusinessId = "businessId";
  static const int MAX_DESCRIPTION_LINES = 3;

  Pop({
    @required this.name,
    @required this.expirationTime,
    @required this.description,
    this.id,
    this.innerPhoto,
    this.subtitle,
    this.photo,
    this.url,
    this.location,
    this.address,
    this.businessId,
  });

  final String name;
  final String subtitle;
  final DateTime expirationTime;
  final String description;
  final String photo;
  final String innerPhoto;
  final String url;
  final GeoPoint location;
  final String address;
  String id;
  String businessId;

  Map toMap() {
    Map<String, dynamic> map = {
      popId: id,
      popName: name,
      popExpirationTime: expirationTime,
      popDescription: description,
      popPhotoPath: photo,
      popLocation: location,
      popAddress: address,
      popSubtitle: subtitle,
      innerPhotoPath: innerPhoto,
      popUrl: url,
      popBusinessId: businessId,
    };

    return map;
  }

  static Pop fromMap(Map map) {
    return new Pop(
        id: map[popId],
        name: map[popName],
        expirationTime: (map[popExpirationTime] as Timestamp).toDate(),
        description: map[popDescription],
        photo: map[popPhotoPath],
        url: map[popUrl],
        subtitle: map[popSubtitle],
        innerPhoto: map[innerPhotoPath],
        location: map[popLocation],
        address: map[popAddress],
        businessId: map[popBusinessId],
    );
  }
}
