import 'package:flutter/material.dart';
import 'package:foodiepops/constants/Texts.dart';
import 'addPopForm/addPopForm.dart';
import 'package:foodiepops/models/pop.dart';

class PopFormScreen extends StatelessWidget {

  PopFormScreen({Key key, this.pop}) : super(key: key);
  final Pop pop;

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(Texts.popFormScreen),
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: AddPopFormBuilder(popToEdit: pop,),
            ),
          ),
          ],
        ),
      ),
    );
  }
}
