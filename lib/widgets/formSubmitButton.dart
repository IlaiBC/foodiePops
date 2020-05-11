import 'package:flutter/material.dart';
import 'customRaisedButton.dart';

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({
    Key key,
    String text,
    bool loading = false,
    VoidCallback onPressed,
  }) : super(
          key: key,
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          height: 44.0,
          color: Color(0xffe51923),
          textColor: Colors.black87,
          loading: loading,
          onPressed: onPressed,
        );
}