import 'dart:collection';
import 'dart:ui';

import 'package:meta/meta.dart';

class UserData {
  UserData({@required this.id, @required this.isBusinessUser, @required this.likedPops});
  final String id;
  final bool isBusinessUser;
  final Set<String> likedPops;

  factory UserData.fromMap(Map<String, dynamic> data, String documentId) {
    try {
    if (data == null) {
      return null;
    }
    final bool isBusinessUser = data['isBusinessUser'];
    if (isBusinessUser == null) {
      return null;
    }

    Set<String> setstuff = Set<String>.from(data['likedPops']);
    print("****************** setstuff length: ${setstuff.length}");

    return UserData(id: documentId, isBusinessUser: isBusinessUser, likedPops: Set<String>.from(data['likedPops']));

    } catch (e) {
      print("an error ocurred $e");
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'isBusinessUser': isBusinessUser,
      'likedPops': likedPops.toList(),
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
