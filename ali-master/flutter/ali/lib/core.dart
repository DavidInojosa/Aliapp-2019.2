import 'dart:convert';
import 'dart:ffi';
import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Server {
  static String serverUrl = "http://192.168.1.5:5000"; // "192.168.42.176"
  static set serverAddr(String addr) => serverUrl = "http://" + addr + ":5000";

  static Future<bool> testActive() async {
    try {
      var future = await http.get(serverUrl);
      if (future.statusCode == 200) return true;
      return false;
    } catch (err) {
      return false;
    }
  }
}

class Cliente {
  final int id;
  final String nome, fone, email;
  final Map<String, dynamic> last;

  Cliente(this.id, this.nome, {this.fone, this.email, this.last});

  static Future<List<Cliente>> getList() async {
    var _response = http.get("${Server.serverUrl}/cliente");
    var _data = jsonDecode((await _response).body);
    List<Cliente> ret = List();
    for (var c in _data) {
      ret.add(Cliente(
        c["uid"],
        c["nome"],
        email: c["email"],
        fone: c["fone"],
        last: c["last"],
      ));
    }
    return ret;
  }

  static Future<List<Cliente>> searchName(String searchQuery) async {
    var _response =
        http.get("${Server.serverUrl}/cliente/${searchQuery ?? ""}");
    var _data = jsonDecode((await _response).body);
    List<Cliente> ret = List();
    for (var c in _data) {
      ret.add(Cliente(
        c["uid"],
        c["nome"],
        email: c["email"],
        fone: c["fone"],
        last: c["last"],
      ));
    }
    return ret;
  }

  static Future<Cliente> getById(int id) async {
    var _response = http.get("${Server.serverUrl}/cliente/$id");
    var _data = jsonDecode((await _response).body);
    return Cliente(
      id,
      _data["nome"],
      fone: _data["fone"],
      email: _data["email"],
      last: _data["last"],
    );
  }

  static Future<List<Cliente>> getByDay(DateTime day) async {
    var _dateString = "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";
    var _response =
        await http.get("${Server.serverUrl}/act/byDay/$_dateString");
    var _data = jsonDecode(_response.body);
    var _return = <Cliente>[];
    for (var act in _data) {
      var cli = await Cliente.getById(act["cliente"]);
      _return.add(cli);
    }
    return _return;
  }

  static Future<Cliente> post(String nome, {String fone, String email}) async {
    var _postBody = "nome=$nome";
    if (!(fone == "" || fone == null)) {
      _postBody += "&fone=$fone";
    }
    if (!(email == "" || email == null)) {
      _postBody += "&email=$email";
    }
    print("Sending POST request with data: $_postBody");
    var _postResponse = await http.post("${Server.serverUrl}/cliente",
        body: _postBody,
        headers: {"content-type": "application/x-www-form-urlencoded"});
    print("Post response: ${_postResponse.headers}");
    var id = int.parse(_postResponse.body);
    print("Id of new customer is: $id");
    return Cliente(id, nome, email: email, fone: fone);
  }

  static Future<void> postAction(
      {@required String action, @required int clienteId, int timestamp}) async {
    var _postBody = "act=$action&cliente=$clienteId";
    if (timestamp != null) {
      _postBody += "&stamp=$timestamp";
    }
    var _postResponse = http.post(
      "${Server.serverUrl}/act",
      headers: {"content-type": "application/x-www-form-urlencoded"},
      body: _postBody,
    );
    print("Post response: ${_postResponse.toString()}");
  }

  static Future<Void> put(int uid, String nome,
      {String fone, String email}) async {
    var _postBody = "nome=$nome";
    if (!(fone == "" || fone == null)) {
      _postBody += "&fone=$fone";
    }
    if (!(email == "" || email == null)) {
      _postBody += "&email=$email";
    }
    print("Sending PUT request with data: $_postBody");
    await http.put("${Server.serverUrl}/cliente/$uid",
        body: _postBody,
        headers: {"content-type": "application/x-www-form-urlencoded"});
    return Void();
  }

  static Future<Void> delete(int uid) async {
    print("Trying to delete cliente #$uid");
    http.delete("${Server.serverUrl}/cliente/$uid");
    return Void();
  }

  Card getCard(BuildContext context, [callback]) => Card(
        elevation: 2.0,
        child: InkWell(
          onTap: () {
            callback();
          },
          splashColor: Theme.of(context).hoverColor,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: ListTile(
              title: Text(this.nome, style: Theme.of(context).textTheme.title),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "${(this.fone) == "" ? this.email : this.fone}" +
                      "\nÚltimo contato ${Timestamp.lastFromStamp(this.last["stamp"])}",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
          ),
        ),
      );
}

class Timestamp {
  static String lastFromStamp(int timestamp) {
    if (timestamp == null || timestamp == 0) {
      return "inexistente";
    }
    timestamp = timestamp * 1000;
    var _last = DateTime.fromMillisecondsSinceEpoch(timestamp);
    if (_last.year != DateTime.now().year) {
      return "em ${_last.day}/${_last.month}/${_last.year}";
    } else {
      var _hour = _last.hour.toString().padLeft(2, '0');
      var _min = _last.minute.toString().padLeft(2, '0');
      return "dia ${_last.day}/${_last.month} às $_hour:$_min";
    }
  }

  static String dateString([DateTime _date]) {
    var _day = _date.day.toString().padLeft(2, '0');
    var _month;
    switch (_date.month) {
      case 1:
        _month = "jan";
        break;
      case 2:
        _month = "fev";
        break;
      case 3:
        _month = "mar";
        break;
      case 4:
        _month = "abr";
        break;
      case 5:
        _month = "mai";
        break;
      case 6:
        _month = "jun";
        break;
      case 7:
        _month = "jul";
        break;
      case 8:
        _month = "ago";
        break;
      case 9:
        _month = "set";
        break;
      case 10:
        _month = "out";
        break;
      case 11:
        _month = "nov";
        break;
      case 12:
        _month = "dez";
        break;
    }
    var _year = _date.year.toString();
    return "$_day $_month $_year";
  }

  static today() {
    return DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);
  }
}

// widgets

enum Pages { Lista, Home, Mapa }

class BottomNavigator extends StatelessWidget {
  final Pages _currentPage;

  BottomNavigator([this._currentPage]);

  @override
  Widget build(BuildContext context) {
    var _currentIndex;
    switch (_currentPage) {
      case Pages.Home:
        _currentIndex = 1;
        break;
      case Pages.Lista:
        _currentIndex = 0;
        break;
      case Pages.Mapa:
        _currentIndex = 2;
        break;
    }
    return BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            title: Text("Clientes"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text("Mapa"),
          ),
        ],
        onTap: (index) {
          if (index == _currentIndex) {
            return;
          }
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/clientes');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/mapa');
              break;
            default:
              break;
          }
        });
  }
}

class ServerInput extends StatefulWidget {
  @override
  ServerInputState createState() => ServerInputState();
}

class ServerInputState extends State<ServerInput> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ali App")),
      body: Form(
        key: _formKey,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 250.0, maxWidth: 200),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.phone,
                  autocorrect: false,
                  autofocus: true,
                  style: TextStyle(fontSize: 18.0),
                  decoration: InputDecoration(
                      labelText: "Server IP Address", hintText: "192.168.0.1"),
                  onSaved: (input) => setState(() => Server.serverAddr = input),
                  onFieldSubmitted: (input) => _formKey.currentState.save(),
                ),
                FutureBuilder(
                    future: Server.testActive(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Icon(snapshot.data
                                  ? Icons.check_box
                                  : Icons.cancel),
                            ),
                            Text(snapshot.data ? "Connected!" : "Failed.")
                          ],
                        );
                      }
                      return CircularProgressIndicator();
                    }),
                RaisedButton(
                  child: Text("ENTER"),
                  onPressed: () {
                    _formKey.currentState.save();
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchCliente extends StatefulWidget {
  @override
  _SearchClienteState createState() => _SearchClienteState();
}

class _SearchClienteState extends State<SearchCliente> {
  String searchQuery;

  Widget searchField() {
    return TextField(
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        suffixIcon: Icon(
          Icons.search,
          color: Colors.white,
        ),
      ),
      onChanged: (value) => searchQuery = value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: searchField()),
      body: FutureBuilder(
        future: Cliente.searchName(searchQuery),
        builder: (context, AsyncSnapshot<List<Cliente>> snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemBuilder: (context, idx) => ListTile(
                title: Text(snapshot.data.map((x) => x.nome).toList()[idx]),
                subtitle: Text(
                    "Último contato ${snapshot.data.map((x) => Timestamp.lastFromStamp(x.last["stamp"])).toList()[idx]}"),
                onTap: () => Navigator.pop(context, snapshot.data[idx]),
              ),
              separatorBuilder: (context, index) => Divider(),
              itemCount: snapshot.data.length,
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
