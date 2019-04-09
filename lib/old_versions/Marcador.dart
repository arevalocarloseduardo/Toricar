import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
/*
class GoogleMapsDemo extends StatefulWidget {
  @override
  _GoogleMapsDemoState createState() => _GoogleMapsDemoState();
}

class _GoogleMapsDemoState extends State<GoogleMapsDemo> {
  Completer<GoogleMapController> _controller = Completer();
  Location location = Location();
  //inicializo variable para guardar map
  Map<String, double> currentLocation;
  //inicializo BDD
  Firestore firestore = Firestore.instance;
  Geoflutterfire geo  = Geoflutterfire();
  Marker laPlata;

  @override
  void initState() {
    super.initState();
    location.onLocationChanged().listen((value) {
      setState(() {
        currentLocation = value;
        laPlata=Marker(
      markerId: MarkerId('Tu ubicación'),
      position: LatLng(currentLocation["latitude"], currentLocation["longitude"]),
      infoWindow: InfoWindow(title: 'Tu ubicacion'),
    );
      });
    });

    
  }

  @override
  Widget build(BuildContext context) { 
    CameraPosition vegasPosition =
        CameraPosition(target: LatLng(currentLocation["latitude"], currentLocation["longitude"]), zoom: 15);
   
    CameraPosition losAngelesPosition =
        CameraPosition(target: LatLng(34.0345471, -118.2643037), zoom: 9);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              mapType: MapType.normal,
              compassEnabled: false,
              myLocationEnabled: true,
              initialCameraPosition: currentLocation==null ?Text("nada"):vegasPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: {laPlata},
            ),
          
          ),
          Positioned(bottom: 10,
          left: 10,
          right: 10,
            child: 
            FlatButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[                  
                    Icon(Icons.pin_drop,color: Colors.white,),
                    Text("Confirmar tu posición",style: TextStyle(color: Colors.white,fontSize: 18),),
                  ],
                ),
              ),
              color: Colors.green,
              onPressed: _addMarker,
            ),
          )
        ],
      ),
    );
    

    Future<void> _goToLosAngeles() async {
      final GoogleMapController controller = await _controller.future;
      controller
          .animateCamera(CameraUpdate.newCameraPosition(losAngelesPosition));
    }
  }

  void _addMarker() {
    
   
  }
}*/