import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toricar/1SplasScreen.dart';
import 'package:toricar/2LoginPage.dart';
import 'package:toricar/auth.dart';
import 'package:toricar/crud.dart';

File image;
String filename;

class VerificarCampoEmail {
  static String validar(String valor) {
    return valor.isEmpty ? 'El Campo no puede estar vacio' : null;
  }
}

class VerificarCampoPass {
  static String validar(String valor) {
    return valor.isEmpty ? 'El Campo no puede estar vacio' : null;
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
  Future getImage() async {
    var selectedImage =
        await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      image = selectedImage;
      filename = image.path;
    });
  }

  crudMedthods crudObj = new crudMedthods();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  FormType _formType = FormType.login;

  String _nombre;

  String _dni;

  String _img;
  String _tel;

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
          Navigator.of(context).pushReplacement(CupertinoPageRoute(
              builder: (context) => SplashScreen(
                    auth: Auth(),
                  )));
        } else {
          final String userId = await widget.auth
              .createUserWithEmailAndPassword(_email, _password)
              .then((onValue) {
            crudObj.agregarRemis(
              onValue,
              {
                'nombre': _nombre,
                'correo': _email,
                'patente': _patente,
                'disponible': false,
                'btn': true,
                'lat': 55.5,
                'long': 55.6,
                'precioxk': '25',
                'rankingR': 4.4,
                'tarifaK': 25,
                'tiempoEspera': 0,
                'viajesEnCurso': '0',
                'img': _img,
                'tel': _tel,
                'dni': _dni,
              },
            ).then(
              (results) {
                setState(
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SplashScreen(
                              auth: Auth(),
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

  Future<String> uploadImage() async {
    StorageReference ref = FirebaseStorage.instance.ref().child(filename);
    StorageUploadTask uploadTask = ref.put(image);
    var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    var url = downUrl.toString();
    setState(() {
      _img = url;
    });

    return "";
  }

  void subirFoto() {
    getImage().then((onValue) {
      uploadImage();
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
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          fondo,
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _formType == FormType.login
                      ? Text(
                          "Ingresá tu cuenta para trabajar con nosotros.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 20,
                              fontWeight: FontWeight.w900),
                        )
                      : Text(
                          "Registrá una cuenta en el sistema y completá tus datos.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 20,
                              fontWeight: FontWeight.w900),
                        ),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: buildInputs() + buildSubmitButtons(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildInputs() {
    if (_formType == FormType.login) {
      return <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            key: Key('email'),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                labelText: 'Correo',
                contentPadding: EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                icon: Icon(Icons.email)),
            validator: VerificarCampoEmail.validar,
            onSaved: (String value) => _email = value,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            key: Key('password'),
            decoration: InputDecoration(
                labelText: 'Contraseña',
                contentPadding: EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                icon: Icon(Icons.vpn_key)),
            obscureText: true,
            validator: VerificarCampoPass.validar,
            onSaved: (String value) => _password = value,
          ),
        ),
      ];
    } else {
      return <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 18),
                child: Icon(
                  Icons.insert_photo,
                  color: Colors.black45,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  elevation: 5,
                  color: Colors.blue,
                  child: MaterialButton(
                    child: Text('Subí una foto tuya',
                        style: TextStyle(fontSize: 20.0, color: Colors.white)),
                    onPressed: subirFoto,
                  ),
                ),
              ),
              ClipOval(
                  child: Image.network(
                "$_img",
                fit: BoxFit.cover,
                width: 52.0,
                height: 52.0,
              ))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            key: Key('email'),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                labelText: 'Correo',
                contentPadding: EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                icon: Icon(Icons.email)),
            validator: VerificarCampoEmail.validar,
            onSaved: (String value) => _email = value,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            key: Key('password'),
            decoration: InputDecoration(
                labelText: 'Contraseña',
                contentPadding: EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                icon: Icon(Icons.vpn_key)),
            obscureText: true,
            validator: VerificarCampoPass.validar,
            onSaved: (String value) => _password = value,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            key: Key('nombre'),
            decoration: InputDecoration(
                labelText: 'Nombre y Apelido',
                contentPadding: EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                icon: Icon(Icons.person)),
            validator: VerificarCampoPass.validar,
            onSaved: (String value) => _nombre = value,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            key: Key('tel'),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
                labelText: 'Celular',
                contentPadding: EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                icon: Icon(Icons.phone)),
            validator: VerificarCampoPass.validar,
            onSaved: (String value) => _tel = value,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            key: Key('dni'),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
                labelText: 'Dni',
                contentPadding: EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                icon: Icon(Icons.credit_card)),
            validator: VerificarCampoPass.validar,
            onSaved: (String value) => _dni = value,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            key: Key('patente'),
            decoration: InputDecoration(
                labelText: 'Patente',
                contentPadding: EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                icon: Icon(Icons.call_to_action)),
            validator: VerificarCampoPass.validar,
            onSaved: (String value) => _patente = value,
          ),
        ),
      ];
    }
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 48, top: 8, right: 8),
          child: Material(
            borderRadius: BorderRadius.circular(20),
            elevation: 5,
            color: Colors.orange,
            child: MaterialButton(
              key: Key('signIn'),
              child: Text('Ingresar',
                  style: TextStyle(fontSize: 20.0, color: Colors.white)),
              onPressed: validarEnviar,
            ),
          ),
        ),
        InkWell(
          onTap: irAlRegistro,
          child: Padding(
            padding: const EdgeInsets.only(top: 15, right: 10),
            child: Text(
              '¿Aún no tenés una cuenta?',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 15.0, color: Colors.white54),
            ),
          ),
        ),
        InkWell(
          onTap: irAlRegistroRemis,
          child: Padding(
            padding: const EdgeInsets.only(top: 15, right: 10),
            child: Text(
              'volver al registro cliente',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 15.0, color: Colors.white54),
            ),
          ),
        ),
      ];
    } else {
      return <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 48, top: 8, right: 8),
          child: Material(
            borderRadius: BorderRadius.circular(20),
            elevation: 5,
            color: Colors.orange,
            child: MaterialButton(
              child: Text('Crear cuenta',
                  style: TextStyle(fontSize: 20.0, color: Colors.white)),
              onPressed: validarEnviar,
            ),
          ),
        ),
        InkWell(
          onTap: irAlLogin,
          child: Padding(
            padding: const EdgeInsets.only(top: 15, right: 10),
            child: Text(
              'Ya tengo una cuenta.',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 15.0, color: Colors.white54),
            ),
          ),
        ),
      ];
    }
  }

  void irAlRegistroRemis() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(
              auth: Auth(),
            ),
      ),
    );
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
