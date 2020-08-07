import 'package:flutter/material.dart';

class FormWidgets {
  static Container formFieldContainer (Widget child) {
    return Container(decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(6.0)),
      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, spreadRadius: 10)],
    ),
     padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 4),
     child: child);
  }
}