import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData({
    @required String path,
    @required Map<String, dynamic> data,
    @required String documentId,
    bool merge = false,
  }) async {
    final reference = Firestore.instance.document(path);
    data['id'] = documentId;
    await reference.setData(data, merge: merge);
  }

  Future<String> addData({
    @required String collectionPath,
    @required Map<String, dynamic> data,
    bool merge = false,
    String userId,
  }) async {

    // Check special case where userId is provided and document already exists - if so - print error
    if (userId != null) {
      DocumentSnapshot documentSnapshot;
      CollectionReference collectionReference = Firestore.instance.collection(collectionPath);
      try {

      documentSnapshot = await collectionReference.document(userId).get();
      } 
      catch (e) {
      // Ignore this, probably a permission issue.
    }
      if (documentSnapshot != null && documentSnapshot.exists) {
        throw("Document already exists!");
    } 
      
      DocumentReference reference = Firestore.instance.collection(collectionPath).document(userId);
      await reference.setData(data, merge: merge);
      return userId;
    }


    DocumentReference reference = Firestore.instance.collection(collectionPath).document();
    String documentId = reference.documentID;
    data['id'] = documentId;

    await reference.setData(data, merge: merge);

    return documentId;
    }


  Future<void> deleteData({@required String path}) async {
    final reference = Firestore.instance.document(path);
    await reference.delete();
  }

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
    Query queryBuilder(Query query),
    int sort(T lhs, T rhs),
  }) {
    Query query = Firestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final Stream<QuerySnapshot> snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.documents
          .map((snapshot) => builder(snapshot.data, snapshot.documentID))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Stream<T> documentStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
  }) {
    final DocumentReference reference = Firestore.instance.document(path);
    final Stream<DocumentSnapshot> snapshots = reference.snapshots();
    return snapshots
        .map((snapshot) => builder(snapshot.data, snapshot.documentID));
  }
}
