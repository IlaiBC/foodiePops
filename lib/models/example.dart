import 'dart:ui';

import 'package:meta/meta.dart';

class Example {
  Example({@required this.id, @required this.name});
  final String id;
  final String name;

  factory Example.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    if (name == null) {
      return null;
    }
    return Example(id: documentId, name: name);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  @override
  int get hashCode => hashValues(id, name);

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Job otherJob = other;
    return id == otherJob.id &&
        name == otherJob.name;
  }

  @override
  String toString() => 'id: $id, name: $name';
}
