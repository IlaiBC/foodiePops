import 'dart:async';

import 'package:foodiepops/models/UserData.dart';
import 'package:foodiepops/models/pop.dart';
import 'package:meta/meta.dart';

import 'fireStorePath.dart';
import 'firestoreService.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  Future<void> setUserInfo(UserData userData) async => await _service.setData(
        path: FirestorePath.userData(uid),
        data: userData.toMap(),
  );

  Future<void> addPop(Pop pop) async {
    pop.businessId = uid;
    await _service.setData(path: FirestorePath.pop(uid), data: pop.toMap());
  }

  Stream<UserData> userInfoStream() => _service.documentStream(
    path: FirestorePath.userData(uid) ,
    builder: (data, documentId) => UserData.fromMap(data, documentId),
  );
}
