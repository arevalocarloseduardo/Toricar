import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class RegistrarseToken extends StatefulWidget {
  @override
  _RegistrarseTokenState createState() => _RegistrarseTokenState();
}

class _RegistrarseTokenState extends State<RegistrarseToken> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLogged = false;

  FirebaseUser myUser;

  Future<FirebaseUser> _loginWithFacebook() async {
    final facebookLogin = new FacebookLogin();
    final result = await facebookLogin.logInWithReadPermissions(['email']);

    debugPrint(result.status.toString());
    if (result.status == FacebookLoginStatus.loggedIn) {
      FirebaseUser user =
          await _auth.signInWithCustomToken(token: result.accessToken.token);
      return user;
    }
    return null;
  }

//Funcion para desloguearse
  void _logOut() async {
    await _auth.signOut().then((response) {
      isLogged = false;
      setState(() {});
    });
  }

//Funcion para loguearse
  void _logIn() {
    _loginWithFacebook().then((response) {
      if (response != null) {
        myUser = response;
        isLogged = true;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.blue,
                gradient: LinearGradient(
                  colors: [Color(0xff622f74), Color(0xffde5cbc)],
                  begin: Alignment.centerRight,
                  end: Alignment(-1.0, -1.0),
                )),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: isLogged
                    ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("noseque pasa"+ myUser.displayName),
            Image.network(myUser.photoUrl),
          ],
        )
          : FacebookSignInButton (
              onPressed: _logIn,
                      ),
              ),
            ],
          )
        ],
      ), /*
    appBar: AppBar(
      //Cuando isLogged es true mortrar jajaj que cool sino mostrar hola
        title: Text(isLogged ? "jajaj que cool" : "hola"),
        actions: <Widget>[
          
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: _logOut,
          )
        ],
    ),
 body: Center(
      
      child: isLogged
        ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("noseque pasa"+ myUser.displayName),
            Image.network(myUser.photoUrl),
          ],
        )
          : FacebookSignInButton (
              onPressed: _logIn,
      ),
    ),*/
    );
  }
}