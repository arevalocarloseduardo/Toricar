import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:toricar/MenuCliente/SeleccionarDestino.dart';
import 'package:toricar/auth.dart';
import 'package:toricar/authProvider.dart';

class SeleccionarUbicacion extends StatefulWidget {
  const SeleccionarUbicacion({this.auth});
  final BaseAuth auth;

  @override
  _SeleccionarUbicacionState createState() => _SeleccionarUbicacionState();
}

class _SeleccionarUbicacionState extends State<SeleccionarUbicacion> {
  Completer<GoogleMapController> _controller = Completer();

//inicio Variables
  String id;
  String name = "hola";
  Marker laPlata;
  Location location = Location();
  final db = Firestore.instance;
//inicializo variable para guardar map

  var latitude;
  var longitude;
  var email;
  var hayPermisos = false;
  var cargando = false;
  @override
  void initState() {
    super.initState();
    widget.auth.email().then((userId) {
      setState(() {
        email = userId;
      });
    });

    //llamo la funcion de permission con un future
    Future<bool> permisos = location.hasPermission();

    permisos.then((onValue) => hayPermisos = onValue);
    //cuando termina de hacer la consulta guardamos el esto en hayPermisos permisos.then((onValue)=>hayPermisos=permisos);
    location.onLocationChanged().listen(
      (LocationData value) {
        latitude = value.latitude;
        longitude = value.longitude;
        setState(() {
          //Creo un Marker inicial
          laPlata = Marker(
            markerId: MarkerId('Tu ubicación'),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(title: 'Tu ubicacion'),
          );
          _goToLosAngeles();
        });
      },
    );
    //metodo para cuando haya un cambio en la ubicacion actualiza currentLocation
  }

  @override
  Widget build(BuildContext context) {
    //muevo la camara a nuestro pocicion actual
    // CameraPosition vegasPosition = CameraPosition(target:LatLng(latitude, longitude), zoom: 15);

    return Scaffold(
      body: hayPermisos == false
          ? Center(child: Text("Compruebe permisos"))
          : Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: longitude == null
                      ? Center(child: CircularProgressIndicator())
                      : GoogleMap(
                          mapType: MapType.normal,
                          compassEnabled: true,
                          myLocationEnabled: true,
                          initialCameraPosition: CameraPosition(
                              target: LatLng(latitude, longitude), zoom: 18),
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
                      child: cargando == true
                          ? Text("Cargando datos...")
                          : Column(
                              children: <Widget>[
                                Icon(
                                  Icons.pin_drop,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Confirmar mi posición inicial",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
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

  Future<void> _goToLosAngeles() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitude, longitude), zoom: 18)));
  }

  void _addMarker() async {
    setState(() {
      cargando = true;
    });
    var correos = email;
    DocumentReference ref = await db.collection('posicion_inicial').add({
      'latitud': '$latitude ',
      'longitud': '$longitude ',
      'cliente': '$correos'
    });
    setState(() {
      id = ref.documentID;
      print(ref.documentID);
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SeleccionarDestino(
              auth: Auth(),
              latitudeInicial: latitude,
              longitudeInicial: longitude,
            ),
      ),
    ).then((onValue){
      setState(() {
      cargando = false;
    });});
    
  }
}
