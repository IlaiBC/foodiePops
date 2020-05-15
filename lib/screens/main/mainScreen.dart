import 'package:flutter/material.dart';
import 'package:foodiepops/models/swipeCard.dart';
import 'package:swipe_stack/swipe_stack.dart';

class MainScreen extends StatelessWidget {
  final GlobalKey<SwipeStackState> _swipeKey = GlobalKey<SwipeStackState>();

  static const routeName = '/MainScreen';
  MainScreen({Key key}) : super(key: key);

  List<SwipeCard> cardList = [new SwipeCard(title: "Burgers", imageUrl: "assets/burger.jpg"),
  new SwipeCard(title: "Cocktails", imageUrl: "assets/cocktails.jpg"),
  new SwipeCard(title: "Ice Cream", imageUrl: "assets/deserts.jpg"),
  new SwipeCard(title: "Mexican", imageUrl: "assets/tacos.jpg"),
  new SwipeCard(title: "Pizza", imageUrl: "assets/foodie_pizza.png"),
  new SwipeCard(title: "Soup", imageUrl: "assets/soup.jpg"),
  new SwipeCard(title: "Sushi", imageUrl: "assets/foodie_sushi.png")];

  @override
  Widget build(BuildContext context) {

    return Scaffold(appBar: AppBar(
          title: const Text('Pick Favorite Foods'),
        ), body: Column(children: <Widget>[
      Expanded(
          flex: 6,
          child: SwipeStack(
            key: _swipeKey,
            children: cardList.map((SwipeCard swipeCard) {
              return SwiperItem(
                  builder: (SwiperPosition position, double progress) {
                return Material(
                    elevation: 4,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(swipeCard.imageUrl),
                              fit: BoxFit.contain),
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text("${swipeCard.title}",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 24)),
                          ],
                        )));
              });
            }).toList(),
            visibleCount: 3,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            stackFrom: StackFrom.Top,
            translationInterval: 6,
            scaleInterval: 0.03,
            onEnd: null,
            onSwipe: (int index, SwiperPosition position) =>
                debugPrint("onSwipe $index $position"),
            onRewind: (int index, SwiperPosition position) =>
                debugPrint("onRewind $index $position"),
          )),
      Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(10),
              child: Row(
            children: <Widget>[
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  _swipeKey.currentState.rewind();
                },
                child: Image.asset('assets/rewind.png'),
              )),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  _swipeKey.currentState.swipeLeft();
                },
                child: Image.asset('assets/dislike.png'),
              )),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  _swipeKey.currentState.swipeRight();
                },
                child: Image.asset('assets/like.png'),
              ))
            ],
          )))
    ]));
  }
}
