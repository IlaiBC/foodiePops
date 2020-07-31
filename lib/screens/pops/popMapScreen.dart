import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodiepops/models/pop.dart';
import 'package:foodiepops/models/UserData.dart';
import 'package:foodiepops/screens/pops/PopListScreen.dart';
import 'package:foodiepops/services/fireStoreDatabase.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PopMapScreen extends StatefulWidget {
  const PopMapScreen({Key key, @required this.pops, this.redeemedCouponSet, this.database, this.userData, this.userLocation}) : super(key: key);
  final List<Pop> pops;
  final Set<String> redeemedCouponSet;
  final FirestoreDatabase database; 
  final UserData userData;
  final Position userLocation;

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
ImageConfiguration(size: Size(12, 12)), 'assets/markpic.png');
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
        context, MaterialPageRoute(builder: (context) => DetailsPage(pop: pop, userData: widget.userData, userLocation: widget.userLocation, database: widget.database, redeemedCouponSet: widget.redeemedCouponSet))); },
          infoWindow: InfoWindow(
            title: pop.name,
            snippet: pop.address,
          ),
        );
        _markers[pop.id] = marker;
      }
    });
  }

  LatLng _getMapInitialCameraPosition () {
    if (widget.userLocation != null) {
      return LatLng(widget.userLocation.latitude, widget.userLocation.longitude);
    }

    if (widget.pops.length > 0) {
      return LatLng(widget.pops[0].location.latitude, widget.pops[0].location.longitude);
    }

    return LatLng(32.109333, 34.855499);
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
            target: _getMapInitialCameraPosition(),
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