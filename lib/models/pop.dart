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
  static final String popKitchenTypes = "kitchenTypes";
  static final String popMinPrice = "minPrice";
  static final String popMaxPrice = "maxPrice";
  static final String popPriceRank = "priceRank";

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
    this.kitchenTypes,
    this.minPrice,
    this.maxPrice,
    this.priceRank,
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
  List<String> kitchenTypes;
  int minPrice;
  int maxPrice;
  int priceRank;

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
      popKitchenTypes: kitchenTypes,
      popMinPrice: minPrice,
      popMaxPrice: maxPrice,
      popPriceRank: priceRank,
    };

    return map;
  }

  static Pop fromMap(Map map) {
    try {

      print('map min price 222: ${map[popMinPrice].runtimeType}');
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
        kitchenTypes: List<String>.from(map[popKitchenTypes]),
        minPrice: (map[popMinPrice] as int),
        maxPrice: (map[popMaxPrice] as int),
        priceRank: (map[popPriceRank] as int),

    );
    } catch (e) {
      print('map values are: $map');
      print('map values are2: ${map[popId]}');
      print('map values are3: ${map[popName]}');
      print('error is: $e');
    }
  }
}
