import 'package:flutter/material.dart';
import 'core.dart';
import 'Maps.dart';
import 'lista.dart';
import 'forms.dart';
import 'placeholders.dart';

void main() { runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  title: "alicerce",
  initialRoute: '/server',
    routes: {
      '/server': (context) => ServerInput(),
      '/' : (context) => PlaceholderDia(),
      '/clientes': (context) => CustomerList(),
      '/mapa': (context) => Mapa(),
    },
 ));
}
