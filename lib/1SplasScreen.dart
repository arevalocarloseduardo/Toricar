import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toricar/2LoginPage.dart';
import 'package:toricar/2SelectMode.dart';
import 'package:toricar/3bLoginRemis.dart';
import 'package:toricar/4aMenuCliente.dart';
import 'package:toricar/4bMenuRemis.dart';
import 'package:toricar/auth.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({this.auth});
  final BaseAuth auth;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

enum EstadosAuth { noDeterminado, noRegistrado, registrado }

enum RegistradoEn { cliente, remisero, ninguno, enDos }

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{
  Animation<double>animation;
  AnimationController animationController;
  Animation<double>animationCar;
  AnimationController animationControllerCar;
  EstadosAuth estadosAuth = EstadosAuth.noDeterminado;
  RegistradoEn registradoEn = RegistradoEn.ninguno;
  CollectionReference _refRemiseros;
  CollectionReference _refCliente;
  var db = Firestore.instance.document('remiseros').snapshots();
  var userId;

  void _loguearse() {
    setState(() {
      estadosAuth = EstadosAuth.registrado;
    });
  }

  void _desloguearse() {
    setState(() {
      estadosAuth = EstadosAuth.noRegistrado;
    });
  }

  @override
  void initState() {
    super.initState();
    //420.-380
    
    animationController=AnimationController(vsync: this,duration: Duration(milliseconds: 1300));
animation=CurvedAnimation(parent: animationController,curve: Curves.bounceOut);
animation.addListener((){
  setState(() {
    
  });
  animationCar.addListener((){
    setState(() {
    
  });
  });

});
 animationControllerCar=AnimationController(vsync: this,duration: Duration(milliseconds: 1000));
animationCar=Tween<double>(begin: -420.0,end: 420.0).animate(animationControllerCar);



    _refCliente = Firestore.instance.collection('cliente');
    _refRemiseros = Firestore.instance.collection('remiseros');
    widget.auth.currentUser().then((userMiId) {
      setState(() {
        //guardar el estado de la llamada si esta registrado o no
        estadosAuth = userMiId == null
            ? EstadosAuth.noRegistrado
            : EstadosAuth.registrado;
        userId = userMiId;
      });
    });
    animationController.forward();
    animation.addStatusListener((listener) {
  if(listener==AnimationStatus.completed){
    animationControllerCar.forward();

}});
    //inicializamos un timer que al finalizar navegue a la siguiente screen
    Timer(
      Duration(milliseconds: 3000),
      () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => EstadosAuth.noRegistrado == estadosAuth
                  ? LoginPage(
                      onSignedIn: _loguearse,
                      auth: Auth(),
                    )
                  : registradoEn == RegistradoEn.cliente
                      ? MenuCliente(
                          tabIndex: 0,
                          seDeslogueo: _desloguearse,
                          auth: Auth(),
                        )
                      : registradoEn == RegistradoEn.remisero
                          ? MenuRemis(
                              tabIndex: 0,
                              seDeslogueo: _desloguearse,
                              auth: Auth(),
                            )
                          : registradoEn == RegistradoEn.enDos
                              ? SelectMode(
                                  auth: Auth(),
                                )
                              : SplashScreen(),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var assetsImage = AssetImage('images/icono.png');
    var imagenLogo = Image(
      image: assetsImage,
      width: animation.value*300,
      height: animation.value*300,
      color: Colors.white,
    );
    var assetsImages = AssetImage('images/auto.png');
    var imagenauto = Image(
      image: assetsImages,
      width:50,
      height: 50,
    );
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
         
          fondo,
          Transform.translate(offset: Offset(animationCar.value,150.0,),child: imagenauto,),
          
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    
                    imagenLogo
                  ],
                )),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    StreamBuilder(
                        stream: _refRemiseros.snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text("error");
                          }
                          if (snapshot.hasData) {
                            return Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: snapshot.data.documents
                                    .map((doc) => dibujarContenido(doc, userId))
                                    .toList());
                          }
                          return CircularProgressIndicator();
                        }),
                    StreamBuilder(
                        stream: _refCliente.snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text("error");
                          }
                          if (snapshot.hasData) {
                            return Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: snapshot.data.documents
                                    .map((doc) => dibujarCliente(doc, userId))
                                    .toList());
                          }
                          return CircularProgressIndicator();
                        }),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget fondo = Container(
    decoration: BoxDecoration(
      color: Colors.blue,
      gradient: LinearGradient(
        colors: [Color(0xff17a7ff), Color(0xff1473ae)],
        begin: Alignment.centerRight,
        end: Alignment(-1.0, -1.0),
      ),
    ),
  );

  Widget dibujarContenido(DocumentSnapshot doc, userId) {
    if (doc.documentID == userId) {
      print(registradoEn);
      //guardar el estado de la llamada si esta registrado o no
      registradoEn = RegistradoEn.remisero;

      return Center(
        child: Text(''),
      );
    } else {
      print(registradoEn);
      return Center();
    }
  }

  Widget dibujarCliente(DocumentSnapshot doc, userId) {
    if (doc.documentID == userId) {
      registradoEn == RegistradoEn.remisero
          ? registradoEn = RegistradoEn.enDos
          : registradoEn = RegistradoEn.cliente;
      print(registradoEn);
      return Center(
        child: Text(''),
      );
    } else {
      print(registradoEn);
      return Center();
    }
  }
}
