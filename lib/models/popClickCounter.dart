import 'package:meta/meta.dart';

class PopClickCounter {
  static final String popClickCounter = "counter";

  PopClickCounter({
    @required this.counter,
  });

  final int counter;

  Map toMap() {
    Map<String, dynamic> map = {
      popClickCounter: counter,
    };

    return map;
  }

  static PopClickCounter fromMap(Map map) {
    try {

    return new PopClickCounter(
        counter: (map[popClickCounter] as int),
    );
    } catch (e) {
      print('error is $e');
    }
  }
}