import 'dart:math';

import 'package:foodiepops/model/pop.dart';

Random random = Random();

List names = [
  "Vitrina Special",
  "Papasan's Monthly",
  "Benedict's Underground",
  "GDB Weekly Burger",
  "Magazzino Secret Pizza",
  "Frug & Co Chill Dinner",
  "Woks Weekly Roll",
  "Golda Doctor's Scoop",
  "Frank's Special",
  "Hakosem's Daily Deal",
  "KFC Colonel Monthly",
];

List Descriptions = [
  "Speacial Deal Description",
  "Speacial Deal Description",
];



List<Pop> mockPops = [
  new Pop(name: names[0], description: Descriptions[1], photoUrl: "assets/vitrina.jpeg", time: 1588839556732),
  new Pop(name: names[1], description: Descriptions[1], time: 1588839756732),
  new Pop(name: names[2], description: Descriptions[1], photoUrl: "assets/benedicts.png", time: 1588839556732),
  new Pop(name: names[3], description: Descriptions[1], time: 1588839356732),
  new Pop(name: names[4], description: Descriptions[1], photoUrl: "assets/MAGAZZINO-250x250.png", time: 1588839556732),
  new Pop(name: names[5], description: Descriptions[1], time: 1588834556732),
  new Pop(name: names[6], description: Descriptions[1], photoUrl: "assets/wok.jpg", time: 1588839556232),
  new Pop(name: names[7], description: Descriptions[1], time: 1588838556732),
  new Pop(name: names[8], description: Descriptions[1], photoUrl: "assets/frank.gif", time: 1588839556732),
  new Pop(name: names[9], description: Descriptions[1], time: 1589839556732),
  new Pop(name: names[10], description: Descriptions[1], photoUrl: "assets/KFC_LOGO.png", time: 1598839556732),
];
