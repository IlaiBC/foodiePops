import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:foodiepops/model/pop.dart';

class ImageUtil {

  static String getAppLogo() {
    return 'assets/google_logo.png';
  }

  static Widget getPopImageWidget(Pop pop, double width, double height) {
    return pop.photoUrl.isNotEmpty
        ? new CachedNetworkImage(
      fit: BoxFit.fitWidth,
      imageUrl: pop.photoUrl,
      placeholder: (context, url) => Image.asset(
        ImageUtil.getAppLogo(),
        width: width,
        height: height,
      ),
      errorWidget: (context, url, error) => new Icon(Icons.error),
      width: width,
      height: height,
    )
        : Image.asset(
      ImageUtil.getAppLogo(),
      width: width,
      height: height,
    );
  }
}