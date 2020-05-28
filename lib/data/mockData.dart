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
  "Is there anything better than starting the day with a chic breakfast composed of fluffy baked bread, perfectly-poached eggs and piles of pancakes? This one-of-a-kind classy vibe with antique silverware is the spot to open your mornings, but also the place for a fashionable meal at any time of day.",
];

List<Pop> mockPops = [
  new Pop(
      name: "סדנאת טעימות יין בלייב מבלי לקום מהספה",
      description: "בפעם הראשונה בעולם?! טעימת יין עיוורת בלייב, אצלכם בסלון. מה זה אמר בעצם? מזמינים את המארז שכולל 3 בקבוקי יין שבחרנו עבורכם וכו, וכו",
      photo: "assets/event.jpeg",
      time: 1589939556732,
      address: "Shlomo Ibn Gabirol St 36"),
  new Pop(
      name: names[0],
      description: Descriptions[1],
      photo: "assets/vitrina.jpeg",
      time: 1589939556732,
      address: "Shlomo Ibn Gabirol St 36"),
  new Pop(
      name: names[1],
      description: Descriptions[1],
      photo: "assets/frank.gif",
      time: 1589939556732,
      address: "Shlomo Ibn Gabirol St 36"),
  new Pop(
      name: names[2],
      description: Descriptions[1],
      photo: "assets/benedicts.png",
      time: 1589939556732,
      address: "Shlomo Ibn Gabirol St 36"),
  new Pop(
      name: names[3],
      description: Descriptions[1],
      photo: "assets/MAGAZZINO-250x250.png",
      time: 1589939556732,
      address: "Shlomo Ibn Gabirol St 36"),
  new Pop(
      name: names[4],
      description: Descriptions[1],
      photo: "assets/MAGAZZINO-250x250.png",
      time: 1589939556732,
      address: "Shlomo Ibn Gabirol St 36"),
  new Pop(
      name: names[5],
      description: Descriptions[1],
      photo: "assets/KFC_LOGO.png",
      time: 1589939556732,
      address: "Shlomo Ibn Gabirol St 36"),
  new Pop(
      name: names[6],
      description: Descriptions[1],
      photo: "assets/wok.jpg",
      time: 1589939556732,
      address: "Shlomo Ibn Gabirol St 36"),
  new Pop(
      name: names[7],
      description: Descriptions[1],
      photo: "assets/benedicts.png",
      time: 1589939556732,
      address: "Shlomo Ibn Gabirol St 36"),
  new Pop(
      name: names[8],
      description: Descriptions[1],
      photo: "assets/frank.gif",
      time: 1589939556732,
      address: "Shlomo Ibn Gabirol St 36"),
  new Pop(
      name: names[9],
      description: Descriptions[1],
      photo: "assets/vitrina.jpeg",
      time: 1589939556732,
      address: "Shlomo Ibn Gabirol St 36"),
  new Pop(
      name: names[10],
      description: Descriptions[1],
      photo: "assets/KFC_LOGO.png",
      time: 1598939556732,
      address: "Tarshish St 19, Eilat"),
];

// news list
List<News> mockNews = [
  new News(
      author: "Tallie Lieberman",
      title: "An insider guide to Israel's under-the-radar ethnic eateries",
      description:
          "Where to find authentic Jewish dishes from around the world",
      url:
          "https://www.timeout.com/israel/restaurants/an-insider-guide-to-israels-under-the-radar-ethnic-eateries",
      date: "20/1/2020",
      picUrl: "https://media.timeout.com/images/105292242/750/422/image.jpg"),
  new News(
      author: "TimeOut team",
      title: "The best hummus spots in Tel Aviv",
      description:
          "Tel Aviv is a hummus haven, but these Middle Eastern hot spots separate the strong from the weak",
      url:
          "https://www.timeout.com/israel/restaurants/the-best-hummus-spots-in-tel-aviv",
      date: "14/2/2020",
      picUrl: "https://media.timeout.com/images/105378437/750/422/image.jpg"),
  new News(
      author: "Jennifer Greenberg",
      title: "Blissful bakeries in Tel Aviv",
      description:
          "From croissants and macarons to cookies and other irresistible treats, these are the best bakeries in Tel Aviv",
      url:
          "https://www.timeout.com/israel/restaurants/blissful-bakeries-in-tel-aviv",
      date: "14/2/2020",
      picUrl: "https://media.timeout.com/images/104159996/750/422/image.jpg"),
  new News(
      author: "Jennifer Greenberg",
      title: "The best restaurants in Israel to take out-of-towners for...",
      description:
          "Don’t let the stress of visitors get to you. We’ve got a restaurant for every occasion, mood, and location",
      url:
          "https://www.timeout.com/israel/restaurants/the-best-restaurants-in-israel-to-take-out-of-towners-for",
      date: "14/2/2020",
      picUrl: "https://media.timeout.com/images/105420918/750/422/image.jpg"),
  new News(
      author: "TimeOut team",
      title: "Beans of gold: The best cafes in Jerusalem",
      description:
          "Tel Aviv is a hummus haven, but these Middle Eastern hot spots separate the strong from the weak",
      url:
          "https://www.timeout.com/israel/restaurants/beans-of-gold-the-best-cafes-in-jerusalem",
      date: "14/2/2020",
      picUrl: "https://media.timeout.com/images/105477434/750/422/image.jpg"),
  new News(
      author: "Tallie Lieberman",
      title: "An insider guide to Israel's under-the-radar ethnic eateries",
      description:
          "Where to find authentic Jewish dishes from around the world",
      url:
          "https://www.timeout.com/israel/restaurants/an-insider-guide-to-israels-under-the-radar-ethnic-eateries",
      date: "20/1/2020",
      picUrl: "https://media.timeout.com/images/105292242/750/422/image.jpg"),
  new News(
      author: "TimeOut team",
      title: "The best hummus spots in Tel Aviv",
      description:
          "Tel Aviv is a hummus haven, but these Middle Eastern hot spots separate the strong from the weak",
      url:
          "https://www.timeout.com/israel/restaurants/the-best-hummus-spots-in-tel-aviv",
      date: "14/2/2020",
      picUrl: "https://media.timeout.com/images/105378437/750/422/image.jpg"),
  new News(
      author: "Jennifer Greenberg",
      title: "Blissful bakeries in Tel Aviv",
      description:
          "From croissants and macarons to cookies and other irresistible treats, these are the best bakeries in Tel Aviv",
      url:
          "https://www.timeout.com/israel/restaurants/blissful-bakeries-in-tel-aviv",
      date: "14/2/2020",
      picUrl: "https://media.timeout.com/images/104159996/750/422/image.jpg"),
  new News(
      author: "Jennifer Greenberg",
      title: "The best restaurants in Israel to take out-of-towners for...",
      description:
          "Don’t let the stress of visitors get to you. We’ve got a restaurant for every occasion, mood, and location",
      url:
          "https://www.timeout.com/israel/restaurants/the-best-restaurants-in-israel-to-take-out-of-towners-for",
      date: "14/2/2020",
      picUrl: "https://media.timeout.com/images/105420918/750/422/image.jpg"),
  new News(
      author: "TimeOut team",
      title: "Beans of gold: The best cafes in Jerusalem",
      description:
          "Tel Aviv is a hummus haven, but these Middle Eastern hot spots separate the strong from the weak",
      url:
          "https://www.timeout.com/israel/restaurants/beans-of-gold-the-best-cafes-in-jerusalem",
      date: "14/2/2020",
      picUrl: "https://media.timeout.com/images/105477434/750/422/image.jpg"),
];

// news list icons paths
List<String> newsIcons = [
  "assets/drink.gif",
  "assets/fries.gif",
  "assets/pizza.gif",
  "assets/cake.gif"
];
