import 'package:flutter/material.dart';
import 'core.dart';
import 'home.dart';
import 'maps.dart';
import 'lista.dart';

void main() { runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  title: "alicerce",
  initialRoute: '/server',
    routes: {
      '/server': (context) => ServerInput(),
      '/' : (context) => HomeScreen(),
      '/clientes': (context) => CustomerList(),
      '/mapa': (context) => Mapa(),
    },
 ));
}
