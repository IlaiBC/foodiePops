import 'package:flutter/material.dart';

@immutable
class CustomRaisedButton extends StatelessWidget {
  const CustomRaisedButton({
    Key key,
    @required this.child,
    this.color,
    this.textColor,
    this.height = 50.0,
    this.borderRadius = 4.0,
    this.spinnerColor = Colors.white70,
    this.loading = false,
    this.onPressed,
  }) : super(key: key);
  final Widget child;
  final Color color;
  final Color textColor;
  final Color spinnerColor;
  final double height;
  final double borderRadius;
  final bool loading;
  final VoidCallback onPressed;

  Widget buildSpinner(BuildContext context) {
    final ThemeData data = Theme.of(context);
    return Theme(
      data: data.copyWith(accentColor: spinnerColor),
      child: SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(
          strokeWidth: 3.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: RaisedButton(
        child: loading ? buildSpinner(context) : child,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
        ),
        color: color,
        disabledColor: color,
        elevation: 5,
        textColor: textColor,
        onPressed: onPressed,
      ),
    );
  }
}
