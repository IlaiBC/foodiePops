import 'package:flutter/material.dart';
import 'package:foodiepops/constants/Texts.dart';
import 'package:foodiepops/models/pop.dart';
import 'package:foodiepops/models/popClick.dart';
import 'package:foodiepops/services/fireStoreDatabase.dart';
import 'package:provider/provider.dart';

class BusinessAnalyticsScreen extends StatelessWidget {
  BusinessAnalyticsScreen({Key key, @required this.businessId}) : super(key: key);
  final String businessId;

  @override
  Widget build(BuildContext context) {
      final FirestoreDatabase database =
      Provider.of<FirestoreDatabase>(context, listen: false);
    return Container(child: StreamBuilder<List<Pop>>(
        stream: database.getBusinessPopList(businessId),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            final List<Pop> pops = snapshot.data;
            print('pops result $pops');
            return Scaffold(
              appBar: AppBar(
                title: const Text(Texts.analyticsScreen),
              ),
              body: ListView(
                padding: const EdgeInsets.all(8.0),
                children: <Widget>[
                  ...List<Widget>.generate(pops.length, (int index) {
                    return _showPopClickData(pops[index], database);
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
        }));


  }

  Widget _showPopClickData(Pop pop, FirestoreDatabase database) {
      return Container(height: 20, child: Center(child: 
       StreamBuilder<List<PopClick>>(
        stream: database.getPopClickList(businessId, pop.id),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            final List<PopClick> popClicks = snapshot.data;
            return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Text('Pop name: ${pop.name}'),
              const SizedBox(width: 20),
              Text('Pop clicks: ${popClicks.length}'),
            ]);
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        })));
  }
}


