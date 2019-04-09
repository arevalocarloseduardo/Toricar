import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class ListenPage extends StatefulWidget {
  @override
  _ListenPageState createState() => _ListenPageState();
}

class _ListenPageState extends State<ListenPage> {
//iniicializo Variable
  Marker laPlata;
  Location location = Location();
//inicializo variable para guardar map
  var latitude;
  var longitude;

  @override
  void initState() {
    super.initState();
    //metodo para cuando haya un cambio en la ubicacion actualiza currentLocation
    location.onLocationChanged().listen((LocationData value) {
      setState(() {
        latitude = value.latitude;
        longitude = value.longitude;
        //Creo un Marker inicial
        laPlata = Marker(
          markerId: MarkerId('Tu ubicación'),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(title: 'Tu ubicacion'),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          latitude == null
              ? CircularProgressIndicator()
              : Text("Ubicacion:" +
                  latitude.toString() +
                  " " +
                  longitude.toString()),
        ],
      ),
    );
  }
}
