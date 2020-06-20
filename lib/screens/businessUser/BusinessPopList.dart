import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:foodiepops/constants/Texts.dart';
import 'package:foodiepops/models/pop.dart';
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
                        return _DetailsPage(pop: pops[index]);
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
            child: ImageUtil.getPopImageWidget(pop, 80.0, 80.0),
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

class _DetailsPage extends StatelessWidget {
  final Pop pop;

  openMapsSheet(context, Pop pop) async {
    try {
      final title = pop.name;
      final description = pop.subtitle;
      final coords = Coords(pop.location.latitude, pop.location.longitude);
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () => map.showMarker(
                          coords: coords,
                          title: title,
                          description: description,
                        ),
                        title: Text(map.mapName),
                        leading: Image(
                          image: map.icon,
                          height: 30.0,
                          width: 30.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  _DetailsPage({Key key, this.pop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pop Details')),
      body: ListView(
        children: <Widget>[
          Container(
            height: 250,
            child: ImageUtil.getPopImageWidget(pop, 200.0, 200.0),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                    child: Text(
                  pop.name,
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                )),
                const SizedBox(height: 10),
                Text(
                  pop.description,
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
                Container(
                    child: ButtonBar(children: <Widget>[
                  FlatButton.icon(
                    icon: Icon(Icons.location_on, color: Color(0xffe51923)),
                    label: Text(""),
                    onPressed: () => openMapsSheet(context, pop),
                  ),
                  FlatButton.icon(
                    textColor: Colors.blue,
                    icon: Icon(Icons.open_in_new, color: Colors.blue),
                    label: Text('Visit Pops website'),
                    onPressed: () {},
                  )
                ])),
                Container(
                    margin: EdgeInsets.all(50.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(width: 3.0, color: Color(0xffe51923)),
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[]))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
