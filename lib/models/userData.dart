import 'dart:collection';
import 'dart:ui';

import 'package:meta/meta.dart';

class UserData {
  UserData({@required this.id, @required this.isBusinessUser, @required this.likedPops, @required this.redeemedPopCoupons});
  final String id;
  final bool isBusinessUser;
  final Set<String> likedPops;
  final Set<String> redeemedPopCoupons;


  factory UserData.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final bool isBusinessUser = data['isBusinessUser'];
    if (isBusinessUser == null) {
      return null;
    }

    Set<String> likedPopsSet = data['likedPops'] != null ? Set<String>.from(data['likedPops']) : {};
    Set<String> redeemedPopCouponsSet = data['redeemedPopCoupons'] != null ? Set<String>.from(data['redeemedPopCoupons']) : {};

    return UserData(id: documentId, isBusinessUser: isBusinessUser, likedPops: likedPopsSet, redeemedPopCoupons: redeemedPopCouponsSet);
  }

  Map<String, dynamic> toMap() {
    return {
      'isBusinessUser': isBusinessUser,
      'likedPops': likedPops.toList(),
      'redeemedPopCoupons': redeemedPopCoupons.toList(),
    };
  }

  @override
  int get hashCode => hashValues(id, isBusinessUser);

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final UserData otherUserData = other;
    return id == otherUserData.id &&
        isBusinessUser == otherUserData.isBusinessUser;
  }

  @override
  String toString() => 'id: $id, isBusinessUser: $isBusinessUser';
}
