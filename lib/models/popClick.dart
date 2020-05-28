import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class PopClick {
  static final String popClickId = "id";
  static final String popClickDate = "date";

  PopClick({
    @required this.date,
    this.id,
  });

  final DateTime date;
  String id;

  Map toMap() {
    Map<String, dynamic> map = {
      popClickId: id,
      popClickDate: date,
    };

    return map;
  }

  static PopClick fromMap(Map map) {
    try {

    return new PopClick(
        id: map[popClickId],
        date: (map[popClickDate] as Timestamp).toDate()
    );
    } catch (e) {
      print('error is $e');
    }
  }
}