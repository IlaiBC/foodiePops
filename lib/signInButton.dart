import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  final String buttonText;
  final String buttonIconPath;
  final Color buttonColor;
  final Function buttonOnPressedAction;

  SignInButton({
    @required this.buttonText,
    @required this.buttonIconPath,
    @required this.buttonColor,
    @required this.buttonOnPressedAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: OutlineButton(
        splashColor: buttonColor,
        onPressed: buttonOnPressedAction,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        highlightElevation: 0,
        borderSide: BorderSide(color: buttonColor),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Image(image: AssetImage(buttonIconPath), height: 35.0),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 20,
                    color: buttonColor,
                  ),
                ),
              )
            ],
          )
        ),
      )
    );
  }
}