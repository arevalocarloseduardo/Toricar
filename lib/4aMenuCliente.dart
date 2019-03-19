import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:toricar/auth.dart';
import 'package:toricar/authProvider.dart';

class MenuCliente extends StatefulWidget {
  const MenuCliente({this.onSignedOut,this.auth});
  final VoidCallback onSignedOut;
   final BaseAuth auth;
  
  Future<void> _signOut(BuildContext context) async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      await auth.signOut();
      onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  _MenuClienteState createState() => _MenuClienteState();
}

class _MenuClienteState extends State<MenuCliente> {
  Completer<GoogleMapController> _controller = Completer();
  

  
//iniicializo Variable

  String id;
  String name="hola";
  Marker laPlata;
  Location location = Location();
  final db = Firestore.instance;
//inicializo variable para guardar map

  var latitude;
  var longitude;
  var email;
  @override
  void initState() {
    super.initState();
    widget.auth.email().then((userId) {
      setState(() {
        email = userId;
      });
    });
    
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
    //muevo la camara a nuestro pocicion actual
    CameraPosition vegasPosition =
        CameraPosition(target: LatLng(latitude, longitude), zoom: 15);

    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              mapType: MapType.normal,
              compassEnabled: true,
              myLocationEnabled: true,
              initialCameraPosition: latitude == null
                  ? CircularProgressIndicator()
                  : vegasPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: {laPlata},
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: FlatButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.pin_drop,
                      color: Colors.white,
                    ),
                    Text(
                      "Confirmar tu posición",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
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
  }
 void _addMarker() async {
   var correos = email;
       DocumentReference ref = await db.collection('posicion_inicial').add({'latitud':'$name ','longitud':'$name ','cliente':'$correos'});
    setState(() {
     id=ref.documentID;
     print(ref.documentID);
    });

  }
}
