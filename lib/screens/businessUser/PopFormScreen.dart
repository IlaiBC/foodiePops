import 'package:flutter/material.dart';
import 'package:foodiepops/constants/Texts.dart';
import 'addPopForm/addPopForm.dart';
import 'package:foodiepops/models/pop.dart';

class PopFormScreen extends StatelessWidget {

  PopFormScreen({Key key, this.pop, this.isDuplicateMode}) : super(key: key);
  final Pop pop;
  final bool isDuplicateMode;

  String _getFormScreenTitle () {
    if (pop != null && isDuplicateMode) {
      return Texts.duplicatePopTitle;
    }

    if (pop != null) {
      return Texts.editPopTitle;
    }

    return Texts.popFormScreen;
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(_getFormScreenTitle()),
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: AddPopFormBuilder(popToEdit: pop, isDuplicateMode: isDuplicateMode),
            ),
          ),
          ],
        ),
      ),
    );
  }
}
