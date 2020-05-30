import 'package:flutter/material.dart';
import 'customRaisedButton.dart';

class FormUploadButton extends CustomRaisedButton {
  FormUploadButton({
    Key key,
    String text,
    bool loading = false,
    VoidCallback onPressed,
  }) : super(
          key: key,
          child: Text(
            text,
            style: TextStyle(color: Colors.black, fontSize: 20.0),
          ),
          height: 50.0,
          color: Colors.white,
          textColor: Colors.black12,
          spinnerColor: Colors.red,
          loading: loading,
          onPressed: onPressed,
        );
}