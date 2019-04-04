import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toricar/MenuCliente/VerRemises.dart';
import 'package:toricar/auth.dart';
import 'package:geocoder/geocoder.dart';

class SeleccionarDestino extends StatefulWidget {
  const SeleccionarDestino(
      {this.auth, this.longitudeInicial, this.latitudeInicial});
  final BaseAuth auth;
  final double longitudeInicial;
  final double latitudeInicial;

  @override
  _SeleccionarDestinoState createState() => _SeleccionarDestinoState();
}

class _SeleccionarDestinoState extends State<SeleccionarDestino> {
  Completer<GoogleMapController> _controller = Completer();

  String searchAddr;
//inicio Variables
  String id;
  Marker miUbicacion;
  final db = Firestore.instance;
//inicializo variable para guardar map

  var latitude;
  var longitude;
  var email;
  var hayPermisos = true;

  var latitudeFinal;
  var longitudeFinal;

  @override
  void initState() {
    super.initState();

    latitude = widget.latitudeInicial;
    longitude = widget.longitudeInicial;
    miUbicacion = Marker(
      markerId: MarkerId('Tu ubicación'),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(title: 'Tu ubicacion'),
    );
    widget.auth.email().then((userId) {
      setState(() {
        email = userId;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                              target: LatLng(latitude, longitude), zoom: 15),
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                          markers: {miUbicacion},
                          onCameraMove: ((_position) =>
                              _updatePosition(_position)),
                        ),
                ),
                Positioned(
                  top: 11,
                  right: 60,
                  left: 15,
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: 'ingrese dirección',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 10.0, top: 9.0),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: buscarParaNavegar,
                            iconSize: 30.0,
                          )),
                      onChanged: (val) {
                        setState(() {
                          searchAddr = val;
                        });
                      },
                    ),
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
                            "Confirmar posición de destino",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    color: Colors.green,
                    onPressed: _agregarMarcador,
                  ),
                )
              ],
            ),
    );
  }

  Future<void> _irAlLugar(double latitudes, double longitudes) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitudes, longitudes), zoom: 17)));
  }

  void _agregarMarcador() /*async*/ {
  //  buscarNombre();
    buscardestino();
    var correos = email;
    /*DocumentReference ref = await db.collection('posicion_inicial').add({
      'latitud': '$latitude ',
      'longitud': '$longitude ',
      'cliente': '$correos'
    });
    setState(() {
      id = ref.documentID;
      print(ref.documentID);
    });*/
  Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VerRemises(
                  auth: Auth(),
                  latitudeInicial: latitude,
                  longitudeInicial: longitude,
                  latitudFinal:latitudeFinal,
                  longitudFinal:longitudeFinal,
                )));
  }

  buscarParaNavegar() async {
    final query = searchAddr;
    var addresses = await Geocoder.local.findAddressesFromQuery("$query");
    var first = addresses.first;
    _irAlLugar(first.coordinates.latitude, first.coordinates.longitude);
  }

  buscarNombre() async {

    var addresses = await Geocoder.local.findAddressesFromCoordinates(Coordinates(latitude, longitude));
    var first = addresses.first;
    print("cosas");
   // print(first);
   // print(first.addressLine);
    print(first.adminArea);//Buenos Aires
    //print(first.coordinates);
    
    print(first.countryName);    //Argenitna
  
    print(first.locality);//La Plata
    print(first.postalCode);//b1900  
    print(first.subThoroughfare);  //1378
    print(first.thoroughfare);//calle 5
    
  }
  buscardestino() async {
    var addresses = await Geocoder.local.findAddressesFromCoordinates(Coordinates(latitudeFinal, longitudeFinal));
    var first = addresses.first;
    print("cosas");
   // print(first);
   // print(first.addressLine);
    print(first.adminArea);//Buenos Aires
    //print(first.coordinates);
    
    print(first.countryName);    //Argenitna
  
    print(first.locality);//La Plata
    print(first.postalCode);//b1900  
    print(first.subThoroughfare);  //1378
    print(first.thoroughfare);//calle 5
    
  }

  void _updatePosition(CameraPosition _position) {
    longitudeFinal=_position.target.longitude;
    latitudeFinal=_position.target.latitude;

    setState(() {
      miUbicacion = Marker(
        markerId: MarkerId('Tu ubicación'),
        position: LatLng(latitudeFinal, longitudeFinal),
        infoWindow: InfoWindow(title: 'Tu ubicacion'),
      );
    });
  }
}
