import 'package:flutter/material.dart';
import 'package:foodiepops/model/pop.dart';

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

  static Widget getPopImageWidget(Pop pop, double width, double height) {
    return (pop.photo != null && pop.photo.isNotEmpty)
        ? Image(
            image: AssetImage(pop.photo),
            width: width,
            height: height,
            fit: BoxFit.fitWidth)
        : Image.asset(
            ImageUtil.getAppLogo(),
            width: width,
            height: height,
          );
  }


}
