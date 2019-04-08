import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:platform/platform.dart';
import 'package:toricar/3aLoginCliente.dart';
import 'package:toricar/3bLoginRemis.dart';
import 'package:toricar/auth.dart';
import 'package:toricar/authProvider.dart';
import 'package:toricar/homePage.dart';
import '4bMenuRemis.dart';
import '4aMenuCliente.dart';
import 'package:android_intent/android_intent.dart';

//Screen para entrar como conductor o cliente
class SelectMode extends StatefulWidget {
  //llamo al auth de firebase
  SelectMode({this.auth});
  final BaseAuth auth;

  @override
  _SelectModeState createState() => _SelectModeState();
}

//enumero 3 estados
enum EstadosAuth { noDeterminado, noRegistrado, registrado }

class _SelectModeState extends State<SelectMode> {
  EstadosAuth estadosAuth = EstadosAuth.noDeterminado;
//inicializamos las siguentes:
  @override
  initState() {
    super.initState();
    //LLamamos al widget auth y le pedimos el user
    widget.auth.currentUser().then((userId) {
      setState(() {
        //guardar el estado de la llamada si esta registrado o no
        estadosAuth =
            userId == null ? EstadosAuth.noRegistrado : EstadosAuth.registrado;
        print(userId);
      });
    });
  }

//nose si sirve
  @override
  void didChangeDependecies() {
    super.didChangeDependencies();
    final BaseAuth auth = AuthProvider.of(context).auth;
    auth.currentUser().then((String userId) {
      setState(() {
        estadosAuth =
            userId == null ? EstadosAuth.noRegistrado : EstadosAuth.registrado;
        print(userId);
      });
    });
  }

//metodo para registar
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

//construimos el widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          fondo,
          Positioned(
            bottom: 180,
            left: 100,
            right: 100,
            child: FlatButton(
                splashColor: Colors.blueAccent,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.work,
                        color: Colors.white54,
                      ),
                      Text(
                        "Quiero Trabajar",
                        style: TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                color: Colors.lightBlue[400],
                onPressed: btnQuieroTrabajar),
          ),
          Positioned(
            bottom: 250,
            left: 100,
            right: 100,
            child: FlatButton(
                splashColor: Colors.amberAccent,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.directions_car,
                        color: Colors.blueGrey[500],
                      ),
                      Text(
                        "Quiero un Remis",
                        style: TextStyle(
                            color: Colors.blueGrey[500],
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                color: Colors.greenAccent,
                onPressed: btnQuieroRemis),
          )
        ],
      ),
    );
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
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
          )));

  void btnQuieroRemis() {
    //cuando no esta registrado que lo envie al sistema registro
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => estadosAuth == EstadosAuth.noRegistrado
            ? LoginCliente(
                onSignedIn: _loguearse,
                auth: Auth(),
              )
            : MenuCliente(tabIndex: 0,
                seDeslogueo: _desloguearse,
                auth: Auth(),
              ),
      ),
    );
  }
   void btnQuieroTrabajar() {
    //cuando no esta registrado que lo envie al sistema registro
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => estadosAuth == EstadosAuth.noRegistrado
            ? LoginRemis(
                onSignedIn: _loguearse,
                auth: Auth(),
              )
            : MenuRemis(tabIndex: 0,
                seDeslogueo: _desloguearse,
                auth: Auth(),
              ),
      ),
    );
  }
}

void abrirMaps() {
  String origin = "123.34,68.56";
  String destination = "-34.9181358,-57.9451325";
  if (new LocalPlatform().isAndroid) {
    final AndroidIntent intent = new AndroidIntent(
        action: 'action_view',
        data: Uri.encodeFull("https://www.google.com/maps/dir/?api=1&origin=" +
            origin +
            "&destination=" +
            destination +
            "&travelmode=driving&dir_action=navigate"),
        package: 'com.google.android.apps.maps');
    intent.launch();
  }
}
