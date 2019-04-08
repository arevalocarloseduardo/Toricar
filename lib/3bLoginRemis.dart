import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:toricar/4aMenuCliente.dart';
import 'package:toricar/4bMenuRemis.dart';
import 'package:toricar/auth.dart';
import 'package:toricar/crud.dart';

class VerificarCampoEmail {
  static String validar(String valor) {
    return valor.isEmpty ? 'El correo no puede estar vacio' : null;
  }
}

class VerificarCampoPass {
  static String validar(String valor) {
    return valor.isEmpty ? 'La contraseña no puede estar vacia' : null;
  }
}

class LoginRemis extends StatefulWidget {
  LoginRemis({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;
  @override
  _LoginRemisState createState() => _LoginRemisState();
}

enum FormType { login, register }

class _LoginRemisState extends State<LoginRemis> {
  crudMedthods crudObj = new crudMedthods();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  FormType _formType = FormType.login;

  String _nombre;

  String _dni;

  String _patente;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> validarEnviar() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          final String userId =
              await widget.auth.signInWithEmailAndPassword(_email, _password);
          print('Logueado: $userId');
          Navigator.of(context).pushReplacement(
              CupertinoPageRoute(builder: (context) => MenuRemis()));
        } else {
          final String userId = await widget.auth
              .createUserWithEmailAndPassword(_email, _password)
              .then((onValue) {
                crudObj.agregarRemis(onValue,
              {
                'nombre': _nombre,
                'correo': _email,
                'patente': _patente,
                'disponible': false,
                'btn': true,
                'lat': 55.5,
                'long':55.6,
                'precioxk':'25',
                'rankingR': 4.4,
                'tarifaK':25,
                'tiempoEspera':0,
                'viajesEnCurso':'0'
              },
            ).then(
              (results) {
                setState(
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MenuRemis(
                              tabIndex: 0,
                            ),
                      ),
                    );
                  },

                );
              },
            );
            
          });
          
          
          print('Registrado user: $userId');
        }
        widget.onSignedIn();
      } catch (e) {
        showToast();
        print('Error: $e');
      }
    }
  }

  void irAlLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  void irAlRegistro() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido A Toricar'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buildInputs() + buildSubmitButtons(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildInputs() {
    if (_formType == FormType.login) {
      return <Widget>[
        TextFormField(
          key: Key('email'),
          decoration: InputDecoration(labelText: 'Correo'),
          validator: VerificarCampoEmail.validar,
          onSaved: (String value) => _email = value,
        ),
        TextFormField(
          key: Key('password'),
          decoration: InputDecoration(labelText: 'Contraseña'),
          obscureText: true,
          validator: VerificarCampoPass.validar,
          onSaved: (String value) => _password = value,
        ),
      ];
    } else {
      return <Widget>[
        TextFormField(
          key: Key('email'),
          decoration: InputDecoration(labelText: 'Correo'),
          validator: VerificarCampoEmail.validar,
          onSaved: (String value) => _email = value,
        ),
        TextFormField(
          key: Key('password'),
          decoration: InputDecoration(labelText: 'Contraseña'),
          obscureText: true,
          validator: VerificarCampoPass.validar,
          onSaved: (String value) => _password = value,
        ),
        TextFormField(
          key: Key('nombre'),
          decoration: InputDecoration(labelText: 'nombre y apelido'),
          validator: VerificarCampoPass.validar,
          onSaved: (String value) => _nombre = value,
        ),
        TextFormField(
          key: Key('Dni'),
          decoration: InputDecoration(labelText: 'Dni'),
          validator: VerificarCampoPass.validar,
          onSaved: (String value) => _dni = value,
        ),
        TextFormField(
          key: Key('patente'),
          decoration: InputDecoration(labelText: 'Patente del vehiculo'),
          validator: VerificarCampoPass.validar,
          onSaved: (String value) => _patente = value,
        ),
      ];
    }
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return <Widget>[
        RaisedButton(
          key: Key('signIn'),
          child: Text('Ingresar', style: TextStyle(fontSize: 20.0)),
          onPressed: validarEnviar,
        ),
        FlatButton(
          child: Text('Crear cuenta', style: TextStyle(fontSize: 20.0)),
          onPressed: irAlRegistro,
        ),
      ];
    } else {
      return <Widget>[
        RaisedButton(
          child: Text('Crear cuenta', style: TextStyle(fontSize: 20.0)),
          onPressed: validarEnviar,
        ),
        FlatButton(
          child: Text('Ya tenés cuenta? Ingresá',
              style: TextStyle(fontSize: 20.0)),
          onPressed: irAlLogin,
        ),
      ];
    }
  }
}

Widget fondo = Container(
    decoration: BoxDecoration(
        color: Colors.blue,
        gradient: LinearGradient(
          colors: [Color(0xff17a7ff), Color(0xff1473ae)],
          begin: Alignment.centerRight,
          end: Alignment(-1.0, -1.0),
        )));

showToast() {
  Fluttertoast.showToast(
      msg: "Ocurrio un error en el registro",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Colors.red[300],
      textColor: Colors.white,
      fontSize: 16.0);
}

/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toricar/2SelectMode.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginRemis extends StatefulWidget {
  @override
  _LoginRemisState createState() => _LoginRemisState();
}

class _LoginRemisState extends State<LoginRemis> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var assetsImage = AssetImage('images/icono.png');
    var imagenLogo = Image(
      image: assetsImage,
      width: 300.0,
      height: 300.0,
      color: Colors.white,
    );
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          fondo,
          Positioned(
              top: 50,
              right: 50,
              left: 50,
              child: Text(
                "¿Estás registrado en el sistema? ingresá tu cuenta.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
              )),
          Positioned(
            top: 100,
            left: 50,
            right: 50,
            child: TextField(
              controller: _emailController,
              decoration:
                  InputDecoration(labelText: "Correo", icon: Icon(Icons.email)),
            ),
          ),
          Positioned(
            top: 150,
            left: 50,
            right: 50,
            child: TextField(
              obscureText: true,
              controller: _passwordController,
              decoration: InputDecoration(
                  labelText: "Contraseña", icon: Icon(Icons.vpn_key)),
            ),
          ),
          Positioned(
              top: 220,
              right: 50,
              left: 50,
              child: FlatButton(
                child: Text("Ingresar"),
                color: Colors.orange,
                textColor: Colors.white,
                onPressed: () {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text)
                      .then((FirebaseUser user) {
                    Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(builder: (context) => SelectMode()));
                  }).catchError((e) {
                    showToast();
                    print(e);
                  });
                },
              )),
          Positioned(
              top: 280,
              right: 50,
              left: 50,
              child: FlatButton(
                child: Text("Registrar"),
                color: Colors.orange,
                textColor: Colors.white,
                onPressed: () {
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text)
                      .then((FirebaseUser user) {
                    Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(builder: (context) => SelectMode()));
                  }).catchError((e) {
                    showToast();
                    print(e);
                  });
                },
              )),
          Positioned(
              top: 260,
              right: 50,
              left: 50,
              child: Text(
                "o",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
              )),
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
          )));

  showToast() {
    Fluttertoast.showToast(
        msg: "Ocurrio un error en el registro",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red[300],
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
*/
