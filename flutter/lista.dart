import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'core.dart';

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
      bottomNavigationBar: BottomNavigator(0),
      body: FutureBuilder(
          future: http.get("${Server.serverUrl}/clientes"),
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
                            Navigator.pushNamed(context, '/')
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

class CustomerAdd extends StatefulWidget {
  @override
  CustomerAddState createState() => CustomerAddState();
}

class CustomerAddState extends State<CustomerAdd> {
  final _formKey = GlobalKey<FormState>();
  final _formContent = null;

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
          title: Text("Adicionar Cliente"),
        ),
        body: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: Builder(
                builder: (context) =>Form(
            key: _formKey,
            child: Column(
              children: <Widget>[TextFormField(
                decoration: InputDecoration(labelText: "Nome",
                contentPadding: EdgeInsets.all(10),),
                validator: (value) {
                  if (value.isEmpty)
                    return "Insira um nome";
                  else
                    return null;
                },
                 onSaved: (String nome) => _formContent.nome = nome,
              ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Telefone",
                  contentPadding: EdgeInsets.all(10)
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value.contains(new RegExp(r"[a..zA..Z]")))
                      return "Esse não é um número válido!";
                    else
                      return null;
                  },
                  onSaved: (String fone ) => _formContent.fone = fone,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Email",
                  contentPadding: EdgeInsets.all(10)
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if ( !(value.contains("@") && value.contains(".")) )
                      return "Email inválido";
                    else
                      return null;
                  },
                   onSaved: (String email) => _formContent.email = email,
                ),
               Padding( 
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                }
              },
              child: Text('Adicionar'),
              textColor: Colors.white,
              color: Theme.of(context).accentColor,),
               ),
              ],
            )
        ),
      ),
        ),
      );
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
