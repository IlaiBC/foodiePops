import 'package:flutter/material.dart';
import 'package:foodiepops/models/pop.dart';
import 'package:foodiepops/data/mockData.dart';
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

  static Widget getPopImageWidget(Pop pop, double width, double height) {
    return (pop.photo != null && pop.photo.isNotEmpty)
        ? Image(
            image: NetworkImage(pop.photo),
            width: width,
            height: height,
            fit: BoxFit.fitWidth)
        : Image.asset(
            ImageUtil.getAppLogo(),
            width: width,
            height: height,
          );
  }

  static Widget getNewsIcon() {
    return ImageIcon(AssetImage(newsIcons[0]));
  }


}
