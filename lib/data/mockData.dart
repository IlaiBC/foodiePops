import 'dart:math';
import 'package:foodiepops/models/news.dart';
import 'package:foodiepops/models/pop.dart';

Random random = Random();


// pops list
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
  new Pop(name: names[0], description: Descriptions[1], photo: "assets/vitrina.jpeg", time: 1588839556732),
  new Pop(name: names[1], description: Descriptions[1], time: 1588839756732),
  new Pop(name: names[2], description: Descriptions[1], photo: "assets/benedicts.png", time: 1588839556732),
  new Pop(name: names[3], description: Descriptions[1], time: 1588839356732),
  new Pop(name: names[4], description: Descriptions[1], photo: "assets/MAGAZZINO-250x250.png", time: 1588839556732),
  new Pop(name: names[5], description: Descriptions[1], time: 1588834556732),
  new Pop(name: names[6], description: Descriptions[1], photo: "assets/wok.jpg", time: 1588839556232),
  new Pop(name: names[7], description: Descriptions[1], time: 1588838556732),
  new Pop(name: names[8], description: Descriptions[1], photo: "assets/frank.gif", time: 1588839556732),
  new Pop(name: names[9], description: Descriptions[1], time: 1589839556732),
  new Pop(name: names[10], description: Descriptions[1], photo: "assets/KFC_LOGO.png", time: 1598839556732),
];

// news list
List<News> mockNews = [
  new News(author: "Tallie Lieberman", title: "An insider guide to Israel's under-the-radar ethnic eateries", description: "Where to find authentic Jewish dishes from around the world", url: "https://www.timeout.com/israel/restaurants/an-insider-guide-to-israels-under-the-radar-ethnic-eateries", date: "20/1/2020"),
  new News(author: "TimeOut team", title: "The best hummus spots in Tel Aviv", description: "Tel Aviv is a hummus haven, but these Middle Eastern hot spots separate the strong from the weak", url: "https://www.timeout.com/israel/restaurants/the-best-hummus-spots-in-tel-aviv", date: "14/2/2020"),
];

// news list icons paths
List<String> newsIcons = ["assets/drink.gif", "assets/fries.gif","assets/pizza.gif","assets/cake.gif"];

