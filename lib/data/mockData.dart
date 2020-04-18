import 'dart:math';

import 'package:foodiepops/model/pop.dart';

Random random = Random();

List names = [
  "Vitrina Special",
  "Papasan's Monthly",
  "Benedict's Underground Breakfast",
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
  "Speacial Deal Description",
  "Speacial Deal Description",
  "Speacial Deal Description",
  "Speacial Deal Description",
  "Speacial Deal Description",
  "Speacial Deal Description",
  "Speacial Deal Description",
  "Speacial Deal Description",
  "Speacial Deal Description",
];



List mockPops = [
  new Pop(name: names[0], description: Descriptions[1], photoUrl: "assets/mockPics/vitrina.jpeg", time: 2134512514),
  new Pop(name: names[random.nextInt(10)], description: Descriptions[1], time: 2134512514),
  new Pop(name: names[random.nextInt(10)], description: Descriptions[1], time: 2134512514),
  new Pop(name: names[random.nextInt(10)], description: Descriptions[1], time: 2134512514),
  new Pop(name: names[random.nextInt(10)], description: Descriptions[1], time: 2134512514),
  new Pop(name: names[random.nextInt(10)], description: Descriptions[1], time: 2134512514),
  new Pop(name: names[random.nextInt(10)], description: Descriptions[1], time: 2134512514),
  new Pop(name: names[random.nextInt(10)], description: Descriptions[1], time: 2134512514),
];
