import 'package:flutter/material.dart';

class ThumbShape extends RoundSliderThumbShape {
  final _indicatorShape = const PaddleSliderValueIndicatorShape();

  const ThumbShape();

  @override
  void paint(PaintingContext context, Offset center,
      {Animation<double> activationAnimation,
        Animation<double> enableAnimation,
        bool isDiscrete,
        TextPainter labelPainter,
        RenderBox parentBox,
        SliderThemeData sliderTheme,
        TextDirection textDirection,
        double value}) {
    super.paint(context, center,
        activationAnimation: activationAnimation,
        enableAnimation: enableAnimation,
        sliderTheme: sliderTheme);
    _indicatorShape.paint(context, center,
        activationAnimation: const AlwaysStoppedAnimation(1),
        enableAnimation: enableAnimation,
        labelPainter: labelPainter,
        parentBox: parentBox,
        sliderTheme: sliderTheme);
  }
}