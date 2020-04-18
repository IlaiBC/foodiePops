import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:foodiepops/model/pop.dart';

class ImageUtil {
  static String getAppLogo() {
    return 'assets/foodiepopsicon.png';
  }

  static Widget getPopImageWidget(Pop pop, double width, double height) {
    return pop.photoUrl.isNotEmpty
        ? Image(
            image: AssetImage(pop.photoUrl),
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
