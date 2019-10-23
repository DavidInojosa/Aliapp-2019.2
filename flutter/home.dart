import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class BottomNavigator extends StatelessWidget {
  final int _currentIndex;
  BottomNavigator([this._currentIndex]);
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.school),
              title: Text("Treinamento")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.contacts),
              title: Text("Clientes")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.map),
              title: Text("Mapeamento")
          ),
        ],

      onTap: (index) {
        if (index == 2)
          Navigator.pushNamed(context, '/mapa');
        if (index == 0)
          Navigator.pushNamed(context, '/home');
      },
    );
  }
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text('First Route'),
      ),
      bottomNavigationBar: BottomNavigator(1),
      );
    }
  }
