import 'dart:ui';

import 'package:meta/meta.dart';

class UserData {
  UserData({@required this.id, @required this.isBusinessUser});
  final String id;
  final bool isBusinessUser;

  factory UserData.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final bool isBusinessUser = data['isBusinessUser'];
    if (isBusinessUser == null) {
      return null;
    }
    return UserData(id: documentId, isBusinessUser: isBusinessUser);
  }

  Map<String, dynamic> toMap() {
    return {
      'isBusinessUser': isBusinessUser,
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
