import 'package:flutter/material.dart';
import 'core.dart';
import 'Maps.dart';
import 'Home.dart';

void main() { runApp(MaterialApp(
  title: "alicerce",
  initialRoute: '/',
    routes: {
      '/': (context) => ServerInput(),
      // When navigating to the "/" route, build the FirstScreen widget.
      '/clientes': (context) => CustomerList(),
      // When navigating to the "/second" route, build the SecondScreen widget.
      '/mapa': (context) => Mapa(),
    },
 ));
}
