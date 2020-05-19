import 'dart:async';

import 'package:foodiepops/models/UserData.dart';
import 'package:foodiepops/models/pop.dart';

import 'fireStorePath.dart';
import 'firestoreService.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase {
  final _service = FirestoreService.instance;

  Future<void> setUserInfo(UserData userData, String uid) async => await _service.setData(
        path: FirestorePath.userData(uid),
        data: userData.toMap(),
  );

  Future<void> addPop(Pop pop) async {
    await _service.addData(collectionPath: FirestorePath.addPop(pop.businessId), data: pop.toMap());
  }

    Future<void> addPopClick(Pop pop) async {
      pop.businessId = 'USkhgEtNimT9ILUOq6uQTw36N1z2';
      Map<String, dynamic> data = {
        'date': documentIdFromCurrentDate(),
      };
    await _service.addData(collectionPath: FirestorePath.addPopClick(pop.businessId, pop.id), data: data);
  }

  Stream<UserData> userInfoStream(String uid) => _service.documentStream(
    path: FirestorePath.userData(uid) ,
    builder: (data, documentId) => UserData.fromMap(data, documentId),
  );
}
