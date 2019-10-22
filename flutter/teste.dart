// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Customer List',
      home: ServerInput(),
      routes: {
        '/cliente': (context) => CustomerList(),
      },
      theme: ThemeData(
          brightness: Brightness.dark,
          accentColor: Colors.orangeAccent
      ),
    );
  }
}

class Server {
  static String serverUrl = "http://192.168.42.176:5000/"; // "192.168.42.176"
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
        if (index == 1)
          Navigator.pushNamed(context, '/cliente');
      },
    );
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
              onPressed: () => Navigator.pushNamed(context, '/cliente')
            ,),
          )
        ],
      ),
    );
  }
}

class CustomerList extends StatefulWidget {
  @override
  CustomerListState createState() => CustomerListState();
}

class CustomerListState extends State<CustomerList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Clientes")
      ),
      bottomNavigationBar: BottomNavigator(1),
      body: FutureBuilder(
          future: http.get("${Server.serverUrl}clientes"),
          builder: (context, snapshot) {
            var customerList;
            if (snapshot.hasData) {
              customerList = json.decode(snapshot.data.body);
              return ListView.separated(
                  separatorBuilder: (context, i) => const Divider(),
                  itemCount: customerList.length,
                  itemBuilder: (context, i) {
                    var clientName = customerList[i];
                    return ListTile(
                        title: Text('$clientName',
                            style: Theme.of(context).textTheme.subhead),
                        onTap: () =>
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    CustomerView(i)
                                ))
                    );
                  }
              );
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CustomerAdd()
            )
        )
      ),
    );
  }
}

class CustomerAdd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Adicionar Cliente"),
      ),
      body: Center(
          child: Text("Hello World!")
      )
      );
  }
}

class CustomerView extends StatefulWidget {
  final int subjectId;

  CustomerView(this.subjectId);

  @override
  CustomerViewState createState() => CustomerViewState();
}


class CustomerViewState extends State<CustomerView> {

  Future< Map<String, dynamic> > _getCustomerData() async {
    var future = await http.get("${Server.serverUrl}clientes/${widget.subjectId}");
    return jsonDecode(future.body);
  }

  @override
  Widget build(BuildContext context) {
    var _customerData = _getCustomerData();
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: _customerData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                snapshot.data["nome"],
                style: TextStyle(fontSize: 18.0),
              );
            }
            return Text(
              "Loading...",
              style: TextStyle(fontSize: 18.0),
            );
          }
        )
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FutureBuilder(
                future: _customerData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data["nome"]+" "+snapshot.data["sobrenome"]);
                  } else {
                    return CircularProgressIndicator();
                  }
                }
            ),
            Text(
            'id: ${widget.subjectId}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic)
            ),
            FutureBuilder(
                future: _customerData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data["telefone"]);
                  } else {
                    return CircularProgressIndicator();
                  }
                }
            )
          ],
        )
    );
  }
}
