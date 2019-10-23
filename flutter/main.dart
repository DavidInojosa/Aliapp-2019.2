import 'package:aulas/Home.dart';
import 'package:flutter/material.dart';

import 'Maps.dart';
import 'Home.dart';

void main() { runApp(MaterialApp(
  title: "alicerce",
  initialRoute: '/home',
    routes: {
      // When navigating to the "/" route, build the FirstScreen widget.
      '/home': (context) => Home(),
      // When navigating to the "/second" route, build the SecondScreen widget.
      '/mapa': (context) => Map(),
    },
 ));
}
