import 'package:flutter/material.dart';
import 'package:aulas/core.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


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
