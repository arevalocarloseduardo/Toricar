import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:toricar/MenuRemis/ConfirmarViajePage.dart';
import 'package:toricar/MenuRemis/InfoRemisPage.dart';
import 'package:toricar/MenuRemis/ViajeActualPage.dart';
import 'package:toricar/MenuRemis/ViajesEnColaPage.dart';
import 'package:toricar/auth.dart';
import 'package:toricar/authProvider.dart';

class MenuRemis extends StatefulWidget {
  const MenuRemis({this.seDeslogueo, this.auth, this.tabIndex});
  final VoidCallback seDeslogueo;
  final BaseAuth auth;
  final int tabIndex;

  Future<void> _signOut(BuildContext context) async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      await auth.signOut();
      seDeslogueo();
    } catch (e) {
      print(e);
    }
  }

  @override
  _MenuRemisState createState() => _MenuRemisState();
}

class _MenuRemisState extends State<MenuRemis> {
  //declaro que inicie en el tab 0
  int currentTab = 0;
  //declaro los page
  ViajeActualPage one;
  ViajesEnColaPage two;
  ConfirmarViajePage tree;
  InfoRemisPage four;

  List<Widget> pages;
  Widget currentPage;
  //hasta aca es para hacer los tabs

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
    //inicializo los tabs
    one = ViajeActualPage();
    two = ViajesEnColaPage();
    tree = ConfirmarViajePage();
    four = InfoRemisPage();

    pages = [one, two, tree, four];
    currentTab = widget.tabIndex;
    currentPage = pages[widget.tabIndex];

    super.initState();

    //llamo la funcion de permission con un future
    Future<bool> permisos = location.requestService();
    permisos.then((onValue) {
      setState(() {
        hayPermisos = onValue;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: hayPermisos == false
          ? Center(child: Text("Compruebe permisos"))
          : currentPage,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentTab,
        onTap: (int index) {
          setState(() {
            currentTab = index;
            currentPage = pages[index];
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home), title: Text("Viaje Actual")),
          BottomNavigationBarItem(
              icon: Icon(Icons.directions_car), title: Text("Viajes en cola")),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), title: Text("Confirmar Viaje")),
          BottomNavigationBarItem(
              icon: Icon(Icons.info_outline), title: Text("Información")),
        ],
      ),
    );
  }
}
