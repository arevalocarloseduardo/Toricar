import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:toricar/4aMenuCliente.dart';

class NoticiasPage extends StatefulWidget {
  NoticiasPage({this.id});
  final String id;
  @override
  _NoticiasPageState createState() => _NoticiasPageState();
}

class _NoticiasPageState extends State<NoticiasPage> {
  Completer<GoogleMapController> _controller = Completer();

  Marker laPlata;
  Location location = Location();
  final db = Firestore.instance;

  var hayPermisos = true;

  var idRemis;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widget.id == null
            ? Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Aún no tenés ningun viaje en curso"),
                  FlatButton(
                    onPressed: pedirUnViaje,
                    child: Text("Pedir un viaje"),
                    color: Colors.orange,
                  )
                ],
              )
            : Stack(
                children: <Widget>[
                 
                  StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection('remiseros')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text("error");
                        }
                        if (snapshot.hasData) {
                          return Stack(
                              children: snapshot.data.documents
                                  .map((doc) =>
                                      traerfoto(doc, idRemis))
                                  .toList());
                        }
                        return CircularProgressIndicator();
                      }), StreamBuilder<QuerySnapshot>(
                      stream:
                          Firestore.instance.collection('viajes').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text("error");
                        }
                        if (snapshot.hasData) {
                          return Stack(
                              children: snapshot.data.documents
                                  .map((doc) => traerViaje(doc, widget.id))
                                  .toList());
                        }
                        return CircularProgressIndicator();
                      }),
                ],
              ),
      ),
    );
  }

  Future<void> _hacerTrack(lat, long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, long), zoom: 15)));
  }
 Widget traerViaje(DocumentSnapshot doc, String id) {
   if (doc.documentID == id) {
     idRemis=doc.data['remis'];
     return Column(
       children: <Widget>[
         Text(doc.documentID),
         Text(doc.data['remis']),
         Text(doc.data['direccionEnd'])
       ],
     );
   }else {
      return Center();
    }

 }
  Widget traerfoto(DocumentSnapshot docs, idRemisero) {
    if (docs.documentID == idRemisero) {
      _hacerTrack(docs.data['lat'], docs.data['long']);
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: GoogleMap(
          mapType: MapType.normal,
          compassEnabled: true,
          myLocationEnabled: true,
          initialCameraPosition: CameraPosition(
              target: LatLng(docs.data['lat'], docs.data['long']), zoom: 16),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: {
            laPlata = Marker(
              markerId: MarkerId(docs.data['nombre']),
              position: LatLng(docs.data['lat'], docs.data['long']),
              infoWindow: InfoWindow(title: docs.data['nombre']),
            ),
          },
        ),
      );
    } else {
      return Center();
    }
  }

  void pedirUnViaje() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MenuCliente(
                tabIndex: 1,
              )),
    );
  }

 
}
