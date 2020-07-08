import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer.dart';
import 'package:foodiepops/constants/Texts.dart';
import 'package:foodiepops/models/pop.dart';
import 'package:foodiepops/screens/pops/PopListScreen.dart';
import 'package:foodiepops/services/fireStoreDatabase.dart';
import 'package:foodiepops/util/imageUtil.dart';
import 'package:animations/animations.dart';
import 'package:provider/provider.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:foodiepops/widgets/platformAlertDialog.dart';
import 'package:foodiepops/screens/businessUser/PopFormScreen.dart';

class BusinessPopList extends StatefulWidget {
  BusinessPopList({Key key, @required this.businessId}) : super(key: key);
  final String businessId;

  @override
  _BusinessPopListState createState() => _BusinessPopListState();
}

class _BusinessPopListState extends State<BusinessPopList> {
  ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final FirestoreDatabase database =
        Provider.of<FirestoreDatabase>(context, listen: false);

    return StreamBuilder<List<Pop>>(
        stream: database.getBusinessPopList(widget.businessId),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            final List<Pop> pops = snapshot.data;

            return Scaffold(
              appBar: AppBar(
                title: const Text(Texts.myPops),
                automaticallyImplyLeading: false,
              ),
              body: ListView(
                padding: const EdgeInsets.all(8.0),
                children: <Widget>[
                  ...List<Widget>.generate(pops.length, (int index) {
                    return OpenContainer(
                      transitionType: _transitionType,
                      openBuilder:
                          (BuildContext _, VoidCallback openContainer) {
                        print('clicked on open');
                        return DetailsPage(pop: pops[index]);
                      },
                      tappable: true,
                      closedShape: const RoundedRectangleBorder(),
                      closedElevation: 0.0,
                      closedBuilder:
                          (BuildContext _, VoidCallback openContainer) {
                        return _buildRow(
                            context, pops[index], openContainer, database);
                      },
                    );
                  }),
                ],
              ),
            );
          }

          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}

void _onDeletePop(
    BuildContext context, Pop pop, FirestoreDatabase database) async {
  await PlatformAlertDialog(
    title: Texts.deletePopAlertTitle,
    content: pop.name,
    defaultActionText: Texts.yes,
    cancelActionText: Texts.cancel,
    onDefaultActionPressed: () {
      database.deletePop(pop.id, pop.businessId);
      Navigator.of(context).pop(true);
    },
  ).show(context);
}

void _onEditPop(BuildContext context, Pop pop) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PopFormScreen(pop: pop,)));
}

Widget _buildRow(BuildContext context, Pop pop, VoidCallback openContainer,
    FirestoreDatabase database) {
  return new Card(
      child: ListTile(
    title: Padding(
      padding: const EdgeInsets.all(0.0),
      child: new Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
        new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          new ClipRRect(
            borderRadius: new BorderRadius.circular(4.0),
            child: ImageUtil.getPopImageWidget(pop, 80.0, 80.0, false),
          ),
        ]),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
        ),
        new Expanded(
            child: new Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              new Text(
                pop.name,
//                    textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              )
            ])),
        InkWell(
            onTap: () {
              _onEditPop(context, pop);
            },
            child: Icon(Icons.edit, color: Color(0xffe51923))),
        const SizedBox(width: 20),
        InkWell(
            onTap: () => _onDeletePop(context, pop, database),
            child: Icon(Icons.delete, color: Color(0xffe51923))),
      ]),
    ),
  ));
}
