import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class NoticiasPage extends StatefulWidget {
  @override
  _NoticiasPageState createState() => _NoticiasPageState();
}

class _NoticiasPageState extends State<NoticiasPage> {
  Completer<GoogleMapController> _controller = Completer();

  Marker laPlata;
  Location location = Location();
  final db = Firestore.instance;

  var hayPermisos = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: hayPermisos == false
          ? Center(child: Text("Compruebe permisos"))
          : Stack(
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                    stream:
                        Firestore.instance.collection('remiseros').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("error");
                      }
                      if (snapshot.hasData) {
                        return Stack(
                            children: snapshot.data.documents
                                .map((doc) =>
                                    traerfoto(doc, "b0xFkZHmWPJgBpCmigUc"))
                                .toList());
                      }
                      return CircularProgressIndicator();
                    }),
              ],
            ),
    );
  }

  Future<void> _hacerTrack(lat, long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, long), zoom: 15)));
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
      return Center(child: CircularProgressIndicator());
    }
  }
}
