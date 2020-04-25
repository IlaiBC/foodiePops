import 'package:flutter/material.dart';
import 'customTimerPainter.dart';

class CountDownTimer extends StatefulWidget {
  final int duration;

  CountDownTimer({@required this.duration});

  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer>
    with TickerProviderStateMixin {
  AnimationController controller;

  String get timerString {
    Duration duration = (controller.duration) * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    );
    controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
      width: 150,
      height: 150,
      child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.center,
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                  child: CustomPaint(
                                      painter: CustomTimerPainter(
                                    animation: controller,
                                    backgroundColor: Colors.white,
                                    color: themeData.indicatorColor,
                                  )),
                                ),
                                Align(
                                  alignment: FractionalOffset.center,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Time Left",
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        timerString,
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
//                      AnimatedBuilder(
//                          animation: controller,
//                          builder: (context, child) {
//                            return FloatingActionButton.extended(
//                                onPressed: () {
//                                  if (controller.isAnimating)
//                                    controller.stop();
//                                  else {
//                                    controller.reverse(
//                                        from: controller.value == 0.0
//                                            ? 1.0
//                                            : controller.value);
//                                  }
//                                },
//                                icon: Icon(controller.isAnimating
//                                    ? Icons.pause
//                                    : Icons.play_arrow),
//                                label: Text(
//                                    controller.isAnimating ? "Pause" : "Play"));
//                          }),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
