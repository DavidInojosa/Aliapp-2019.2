import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class Server {
  static String serverUrl = "http://192.168.0.17:5000/"; // "192.168.42.176"
  static set serverAddr(String addr) => serverUrl = "http://"+addr+":5000/";
  
  static Future<bool> testActive() async {
    try {
      var future = await http.get(serverUrl);
      if (future.statusCode == 200)
        return true;
      return false;
    } catch (err) {
      return false;
    }
  }
  
}

class ServidorProMapa {
  //Future<List<Map<String, dynamic>>> 
    Future<void> _ServidorProMapa() async {
      var request = await http.get("${Server.serverUrl}maps/");
      print(jsonDecode(request.body));
    }
}

class _MapState extends State<Map> {

  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _marcadores = {};

  _movimentarCamera() async{

    _controller.future;
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(-8.109329, -34.910584),
          zoom: 20,
          tilt: 45,
          bearing:210
          )
      )
    );

  }

_carregarmarcadores(){
  
  Set<Marker> marcadoresLocal = {};
  Marker marcadorAlicerce = Marker(markerId: MarkerId("marcador Alicerce"),
  position: LatLng(-8.109329, -34.910584)
  );
  Marker marcadorCosta = Marker(markerId: MarkerId("marcador Costa"),
  position: LatLng(-8.112041, -34.910816)
  );
  
  marcadoresLocal.add(marcadorAlicerce);
  marcadoresLocal.add(marcadorCosta);

  setState(() {
    _marcadores = marcadoresLocal;
  });
}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _carregarmarcadores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mapa da Alicerce"),),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.done_all),
          onPressed: _movimentarCamera,
      ),
      body: Container(
        child: GoogleMap(
          mapType: MapType.normal,
          // lat e long da alicerce -> -8.109329, -34.910584
          initialCameraPosition: CameraPosition(
            target: LatLng(-8.109329, -34.910584),
            zoom: 16 
            ),
            onMapCreated: (GoogleMapController controller){
              _controller.complete(controller);
            },
            markers: _marcadores,
        ),
      )

      
    );
  }
}
