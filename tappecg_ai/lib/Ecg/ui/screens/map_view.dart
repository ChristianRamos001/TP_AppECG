import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tappecg_ai/Ecg/ui/screens/navbar.dart';
import 'package:tappecg_ai/widgets/custom_app_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  final double lat;
  final double lon;
  const MapView(
    this.lat,
    this.lon, {
    Key? key,
  }) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState(lat, lon);
}

class _MapViewState extends State<MapView> {
  _MapViewState(lat, lon) {
    latitud = lat;
    longitud = lon;
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Completer<GoogleMapController> controller = Completer();
  static late double latitud;
  static late double longitud;

  static final CameraPosition cameraPosition =
      CameraPosition(target: LatLng(latitud, longitud), zoom: 14.4746);

  static final Marker marcador = Marker(
      markerId: MarkerId("_marcador"),
      infoWindow: InfoWindow(title: 'Centro de salud'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(latitud, longitud));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(),
        drawer: NavBar(),
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              markers: {marcador},
              initialCameraPosition: cameraPosition,
              onMapCreated: (GoogleMapController _controller) {
                controller.complete(_controller);
              },
            )
          ],
        ));
  }
}




/*




 */