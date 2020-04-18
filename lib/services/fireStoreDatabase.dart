import 'dart:async';

import 'package:foodiepops/models/example.dart';
import 'package:meta/meta.dart';

import 'fireStorePath.dart';
import 'firestoreService.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  Future<void> setExample(Example example) async => await _service.setData(
        path: FirestorePath.example(uid, example.id),
        data: example.toMap(),
  );
}
