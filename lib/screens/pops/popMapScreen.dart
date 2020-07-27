import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodiepops/models/pop.dart';
import 'package:foodiepops/screens/pops/PopListScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PopMapScreen extends StatefulWidget {
  const PopMapScreen({Key key, @required this.pops}) : super(key: key);
  final List<Pop> pops;

  @override
  State<PopMapScreen> createState() => PopMapScreenState();
}

class PopMapScreenState extends State<PopMapScreen> {
  final Map<String, Marker> _markers = {};
  BitmapDescriptor markerIcon;

    @override
  void initState() {
    super.initState();
    getMarkerIcons();
  }

  void getMarkerIcons() async {
    BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
ImageConfiguration(size: Size(24, 24)), 'assets/business_login.png');
    setState(() {
      this.markerIcon = markerIcon;
    });
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    
    setState(() {
      _markers.clear();
      for (final Pop pop in widget.pops) {
        final marker = Marker(
          markerId: MarkerId(pop.id),
          icon: markerIcon,
          position: LatLng(pop.location.latitude, pop.location.longitude),
          onTap: () {Navigator.push(
        context, MaterialPageRoute(builder: (context) => DetailsPage(pop: pop,))); },
          infoWindow: InfoWindow(
            title: pop.name,
            snippet: pop.address,
          ),
        );
        _markers[pop.id] = marker;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
            target: LatLng(widget.pops[0].location.latitude, widget.pops[0].location.longitude),
            zoom: 12,
          ),
        onMapCreated: _onMapCreated,
        markers: _markers.values.toSet(),
      ),
      floatingActionButton: Container(height: 90, width: 90, child: Padding(padding: const EdgeInsets.only(bottom: 30.0), child: FloatingActionButton(
        onPressed: () { Navigator.pop(context); },
        child: Icon(Icons.list, size: 36.0,),
      ),
    )));
  }
}