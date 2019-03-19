import 'package:flutter/material.dart';
import 'package:toricar/3aLoginCliente.dart';
import 'package:toricar/3bLoginRemis.dart';
import 'package:toricar/auth.dart';
import 'package:toricar/authProvider.dart';
import 'package:toricar/homePage.dart';
import '4bMenuRemis.dart';
import '4aMenuCliente.dart';

class SelectMode extends StatefulWidget {
  SelectMode({this.auth});
  final BaseAuth auth;
  

  @override
  _SelectModeState createState() => _SelectModeState();
}

enum AuthStatus { notDetermined, notSignedIn, signedIn }

class _SelectModeState extends State<SelectMode> {
  AuthStatus authStatus = AuthStatus.notDetermined;

  @override
  initState() {
    super.initState();
    
    widget.auth.currentUser().then((userId) {
      setState(() {
        authStatus =
            userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  @override
  void didChangeDependecies() {
    super.didChangeDependencies();
    final BaseAuth auth = AuthProvider.of(context).auth;
    auth.currentUser().then((String userId) {
      setState(() {
        authStatus =
            userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
        print(userId);
      });
    });
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

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
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              color: Colors.lightBlue[400],
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            authStatus == AuthStatus.notSignedIn
                                ? LoginRemis()
                                : MenuRemis()),
                  ),
            ),
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              color: Colors.greenAccent,
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            authStatus == AuthStatus.notSignedIn
                                ? LoginCliente(
                                    onSignedIn: _signedIn,
                                  )
                                : MenuCliente(onSignedOut: _signedOut,auth: Auth()))
                  ),
            ),
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
}
