import 'package:flutter/material.dart';
import 'package:foodiepops/models/pop.dart';
import 'dart:math';

Random random = Random();

class ImageUtil {
  static String getAppLogo() {
    return 'assets/foodiepopsicon.png';
  }

  static Widget getPopTimer(Pop pop, double width, double height) {
    return Image(
        image: AssetImage('assets/clock.gif'),
        width: width,
        height: height,
        fit: BoxFit.fitWidth);
  }

  static Widget getPopImageWidget(
      Pop pop, double width, double height, bool inner) {
    return (pop.photo != null && pop.photo.isNotEmpty)
        ? (inner
            ? FadeInImage(
                image: NetworkImage(pop.innerPhoto), placeholder: AssetImage(ImageUtil.getAppLogo()),
                width: width,
                height: height,
                fit: BoxFit.fitWidth)
            : FadeInImage(
                image: NetworkImage(pop.photo), placeholder: AssetImage(ImageUtil.getAppLogo()),
                width: width,
                height: height,
                fit: BoxFit.fitWidth))
        : Image.asset(
            ImageUtil.getAppLogo(),
            width: width,
            height: height,
          );
  }
}
