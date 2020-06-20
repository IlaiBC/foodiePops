import 'package:flutter/material.dart';
import 'package:foodiepops/constants/Texts.dart';
import 'package:foodiepops/widgets/Avatar.dart';

@immutable
class ClickableImageUpload extends StatelessWidget {
  const ClickableImageUpload({
    Key key,
    this.color,
    this.textColor,
    this.height = 50.0,
    this.borderRadius = 4.0,
    this.spinnerColor = Colors.white70,
    this.loading = false,
    this.onPressed,
    this.photoPath,
  }) : super(key: key);
  final Color color;
  final Color textColor;
  final Color spinnerColor;
  final double height;
  final double borderRadius;
  final bool loading;
  final VoidCallback onPressed;
  final String photoPath;

  Widget buildSpinner(BuildContext context) {
    final ThemeData data = Theme.of(context);
    return Theme(
      data: data.copyWith(accentColor: spinnerColor),
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.red,
          strokeWidth: 3.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: loading
          ? buildSpinner(context)
          : InkWell(
              child: ClipRRect(
                borderRadius: new BorderRadius.circular(4.0),
                child: photoPath == Texts.emptyPath
                    ? Avatar(
                        photoUrl: null,
                        radius: 100,
                        backgroundColor: Colors.white)
                    : Image(
                        image: NetworkImage(photoPath),
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain),
              ),
              onTap: onPressed,
            ),
    );
  }
}
