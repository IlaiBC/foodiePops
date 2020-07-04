import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodiepops/models/UserData.dart';
import 'package:foodiepops/models/pop.dart';
import 'package:foodiepops/models/popClick.dart';
import 'package:foodiepops/models/popClickCounter.dart';
import 'package:geolocator/geolocator.dart';
import 'fireStorePath.dart';
import 'firestoreService.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase {
  final _service = FirestoreService.instance;

  Future<void> setUserInfo(UserData userData, String uid) async => await _service.setData(
        path: FirestorePath.userData(uid),
        data: userData.toMap(),
        documentId: uid,
  );

  Future<void> addPop(Pop pop) async {
    String popId = await _service.addData(collectionPath: FirestorePath.pops(), data: pop.toMap());

    await _service.setData(path: FirestorePath.addPopToBusiness(pop.businessId, popId), data: pop.toMap(), documentId: popId);
  }

  Future<void> updatePop(Pop pop) async {
    await _service.setData(path: FirestorePath.specificPop(pop.id), data: pop.toMap(), documentId: pop.id, merge: true);

    await _service.setData(path: FirestorePath.specificBusinessPop(pop.businessId, pop.id), data: pop.toMap(), documentId: pop.id, merge: true);
  }

  Future<void> addPopClick(Pop pop, Position userLocation) async {
      Map<String, dynamic> data = {
        'date': DateTime.now(),
        'userLocation': GeoPoint(userLocation.latitude, userLocation.longitude)
      };
    await _service.addData(collectionPath: FirestorePath.addPopClick(pop.businessId, pop.id), data: data);
  }

    Future<void> addLikeToPop(Pop pop, Position userLocation, int previousLikeCount) async {
      Map<String, dynamic> likeData = {
        'date': DateTime.now(),
        'userLocation': GeoPoint(userLocation.latitude, userLocation.longitude)
      };

      Map<String, dynamic> counterData = {
        'counter': previousLikeCount + 1,
      };

    await _service.setData(path: FirestorePath.popLikeCount(pop.id), data: counterData, documentId: 'likeCount');
    await _service.setData(path: FirestorePath.businessPopLikeCount(pop.businessId, pop.id), data: counterData, documentId: 'likeCount');

    await _service.addData(collectionPath: FirestorePath.addPopLike(pop.id), data: likeData);
    await _service.addData(collectionPath: FirestorePath.addPopLikeToBusinessAnalytics(pop.businessId, pop.id), data: likeData);
  }

  Stream<UserData> userInfoStream(String uid) => _service.documentStream(
    path: FirestorePath.userData(uid) ,
    builder: (data, documentId) => UserData.fromMap(data, documentId),
  );

  Stream<PopClickCounter> popLikeCounterStream(String popId) => _service.documentStream(
    path: FirestorePath.popLikeCount(popId) ,
    builder: (data, documentId) => PopClickCounter.fromMap(data),
  );

  Future<void> deletePop(String popId, String businessId) async {
    await _service.deleteData(path: FirestorePath.specificBusinessPop(businessId, popId));
    await _service.deleteData(path: FirestorePath.specificPop(popId));
  }

  Stream<List<Pop>> getPopList() => _service.collectionStream(
    path: FirestorePath.pops() ,
    builder: (data, documentId) => Pop.fromMap(data),
    sort: (lhs, rhs) => lhs.expirationTime.millisecondsSinceEpoch.compareTo(rhs.expirationTime.millisecondsSinceEpoch),
  );

  Stream<List<Pop>> getBusinessPopList(String businessId) => _service.collectionStream(
    path: FirestorePath.businessPops(businessId) ,
    builder: (data, documentId) => Pop.fromMap(data),
  );

  Stream<List<PopClick>> getPopClickList(String businessId, String popId) => _service.collectionStream(
    path: FirestorePath.popClicks(businessId, popId) ,
    builder: (data, documentId) => PopClick.fromMap(data),
  );

    Stream<List<PopClick>> getPopLike(String businessId, String popId) => _service.collectionStream(
    path: FirestorePath.popClicks(businessId, popId) ,
    builder: (data, documentId) => PopClick.fromMap(data),
  );
}
