import 'package:flutter/material.dart';
import 'package:toricar/auth.dart';
class VerRemises extends StatefulWidget {

  const VerRemises(
      {this.auth, this.longitudeInicial, this.latitudeInicial,this.latitudFinal,this.longitudFinal});
  final BaseAuth auth;
  final double longitudeInicial;
  final double latitudeInicial;  
  final double latitudFinal;
  final double longitudFinal;
  @override
  _VerRemisesState createState() => _VerRemisesState();
}

class _VerRemisesState extends State<VerRemises> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),body: Container(child: Center(child: Text("estos son los datos li:${widget.latitudeInicial}li:${widget.longitudeInicial}lf:${widget.latitudFinal}lf:${widget.longitudFinal}aca muestra los remises disponible. los que estan ocupados y demora"),),      
      ),
    );
  }
}