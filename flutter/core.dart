
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import "Home.dart";


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
        if (index == _currentIndex) {return;}
        if (index == 1)
          Navigator.pushNamed(context, '/clientes');
        if (index == 2)
          Navigator.pushNamed(context, '/mapa');
      },
    );
  }
}

class Server {
  //lembrar de emulador e pc na mesma wifi
  static String serverUrl = "http://172.26.70.123:5000/"; // "192.168.42.176"
  static set serverAddr(String addr) => serverUrl = "http://"+addr+":5000/";
  
  static Future<bool> testActive() async {
    try {
      print('sending get request');
      print(serverUrl);
      var future = await http.get(serverUrl);
      if (future.statusCode == 200)
        return true;
      return false;
    } catch (err) {
      return false;
    }
  }
}

class ServerInput extends StatefulWidget {
  @override
  ServerInputState createState() => ServerInputState();
}

class ServerInputState extends State<ServerInput> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Agexts App")
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 8.0, horizontal: 110.0),
            child: TextField(
                decoration: InputDecoration(
                    labelText: "Server IP Address",
                    hintText: "192.168.0.1"
                ),
                onSubmitted: (input) =>
                    setState(() {
                      Server.serverAddr = input;
                    })
            ),
          ),
          FutureBuilder(
              future: Server.testActive(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Icon(
                            snapshot.data ? Icons.check_box : Icons.cancel),
                      ),
                      Text(snapshot.data ? "Connected!" : "Failed.")
                    ],
                  );
                }
                return CircularProgressIndicator();
              }
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RaisedButton(
              child: Text("GO!",
                style: Theme.of(context).textTheme.button,
              ),
              color: Theme.of(context).accentColor,
              onPressed: () => Navigator.pushNamed(context, '/clientes')
            ,),
          )
        ],
      ),
    );
  }
}