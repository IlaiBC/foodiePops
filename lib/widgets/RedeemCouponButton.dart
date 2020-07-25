import 'package:flutter/material.dart';
import 'customRaisedButton.dart';

class RedeemCouponButton extends CustomRaisedButton {
  RedeemCouponButton({
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
          height: 50.0,
          color: Color(0xffe51923),
          textColor: Colors.white,
          spinnerColor: Colors.white,
          loading: loading,
          onPressed: onPressed,
        );
}