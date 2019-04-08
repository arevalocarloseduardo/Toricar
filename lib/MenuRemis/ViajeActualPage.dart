import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';


double latIn =-34.9084098;
double longIn=-57.9143879;

double latEnd=-34.91378151933487;
double longEnd=-57.90670998394489;
String selectedUrl = 'https://www.google.com/maps/dir/?api=1&origin=''$latIn,$longIn''&destination=''$latEnd,$longEnd';

class ViajeActualPage extends StatefulWidget {
  @override
  _ViajeActualPageState createState() => _ViajeActualPageState();
}

class _ViajeActualPageState extends State<ViajeActualPage> {
  
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin.close();
  }

  @override
  void dispose() {
    flutterWebViewPlugin.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body:WebviewScaffold(
            url: selectedUrl,
            initialChild: Container(
              color: Colors.redAccent,
              child: Center(
                child: Text('Esperando...'),
              ),
            ),)
          );
  }
 
}

