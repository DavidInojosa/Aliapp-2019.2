import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'core.dart';
import 'forms.dart';


class Mapa extends StatefulWidget {
  @override
  _MapaState createState() => _MapaState();
}

class _MapaState extends State<Mapa> {

  //Future<List<Map<String, dynamic>>> 
  Future<void> _servidorProMapa() async {
    Future<http.Response> request;
    request = http.get("${Server.serverUrl}maps");
    request.catchError((err) => (print(err)));
    var data = await request;
    print(data.body);
  }

  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _marcadores;

  _movimentarCamera() async {

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
  
  Set<Marker> marcadoresLocal;
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
    _servidorProMapa();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      appBar: AppBar(title: 
      Text("Mapa da Alicerce", 
      textAlign: TextAlign.center,),
      ),
      body: Container(
        child: Stack(children: <Widget>[
          GoogleMap(
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
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.fromLTRB(50, 20, 50,20),
            child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomRight,
            child:FloatingActionButton(
            heroTag: "adicionar",
            onPressed:  _movimentarCamera,
            materialTapTargetSize: MaterialTapTargetSize.padded,
            backgroundColor: Colors.blue,
            child: const Icon(Icons.gps_fixed),
            ),
          ),
        Align(
          alignment: Alignment.bottomLeft,
          child:
            FloatingActionButton(
            heroTag: "tresde",
            onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyApp()
            )
        ),
            materialTapTargetSize: MaterialTapTargetSize.padded,
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add_location),
          ),
        ),
    ],
          ),
          )
          ,)
        ],
        ),
      ), 
      bottomNavigationBar: BottomNavigator(Pages.Mapa),
    );
  }
}
