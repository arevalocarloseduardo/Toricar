import 'package:flutter/material.dart';
import 'package:toricar/auth.dart';
class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;
  @override
  _LoginPageState createState() => _LoginPageState();
  
}

class _LoginPageState extends State<LoginPage> {
  
  
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}