import 'package:flutter/material.dart';
import 'core.dart';

class CustomerList extends StatefulWidget {
  @override
  CustomerListState createState() => CustomerListState();
}

class CustomerListState extends State<CustomerList> {
  @override
  Widget build(BuildContext context) {
    var _list = Cliente.getList();
    return Scaffold(
      appBar: AppBar(
        title: Text("Clientes"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerAdd(),
                )),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigator(Pages.Lista),
      body: FutureBuilder(
          future: _list,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Widget> _cards = List();
              for (var c in snapshot.data) {
                _cards.add(Padding(
                  padding: EdgeInsets.all(8.0),
                  child: c.getCard(
                    context,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomerView(c.id)),
                    ),
                  ),
                ));
              }
              return ListView.builder(
                  itemCount: _cards.length,
                  itemBuilder: (context, index) {
                    return _cards[index];
                  });
            } else if (snapshot.hasError) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(snapshot.error.toString()),
                duration: Duration(seconds: 5),
              ));
              return Spacer();
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

class CustomerAdd extends StatefulWidget {
  @override
  CustomerAddState createState() => CustomerAddState();
}

class CustomerAddState extends State<CustomerAdd> {
  final _formKey = GlobalKey<FormState>();
  var _formHasEmail = false;
  var _formHasFone = false;
  Map<String, dynamic> _formContent = Map();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Adicionar"),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "SALVAR",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  if (!_formHasFone && !_formHasEmail) {
                    showDialog(
                        context: context,
                        builder: (context) => SimpleDialog(
                              title: Text("Precisa de um email ou um telefone"),
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    SimpleDialogOption(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("OK"),
                                    ),
                                  ],
                                ),
                              ],
                            ));
                  } else {
                    _formKey.currentState.save();
                    print(_formContent.toString());
                    Cliente.post(
                      _formContent["nome"],
                      email: _formContent["email"],
                      fone: _formContent["fone"],
                    );
                    Navigator.pop(context);
                  }
                }
              },
            ),
          ],
        ),
        body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: "Nome"),
                    validator: (value) {
                      if (value.isEmpty)
                        return "Insira um nome";
                      else
                        return null;
                    },
                    onSaved: (value) => _formContent["nome"] = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Telefone"),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value.contains(new RegExp(r"[a..zA..Z]")))
                        return "Esse não é um número válido!";
                      else if (value.isEmpty) {
                        _formHasFone = false;
                        return null;
                      } else {
                        _formHasFone = true;
                        return null;
                      }
                    },
                    onSaved: (value) => _formContent["fone"] = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Email"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty) {
                        _formHasEmail = false;
                        return null;
                      } else if (!(value.contains("@") &&
                          value.contains("."))) {
                        return "Email inválido";
                      } else {
                        _formHasEmail = true;
                        return null;
                      }
                    },
                    onSaved: (value) => _formContent["email"] = value,
                  ),
                ],
              ),
            )),
      );
}

class CustomerEdit extends StatefulWidget {
  final Cliente cliente;

  CustomerEdit(this.cliente);

  @override
  CustomerEditState createState() => CustomerEditState();
}

class CustomerEditState extends State<CustomerEdit> {
  final _formKey = GlobalKey<FormState>();
  bool _formHasEmail = false;
  bool _formHasFone = false;
  Map<String, dynamic> _formContent = Map();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller:
                        TextEditingController(text: widget.cliente.nome),
                    decoration: InputDecoration(labelText: "Nome"),
                    validator: (value) {
                      if (value.isEmpty)
                        return "Insira um nome";
                      else
                        return null;
                    },
                    onSaved: (value) => _formContent["nome"] = value,
                  ),
                  TextFormField(
                    controller:
                        TextEditingController(text: widget.cliente.fone),
                    decoration: InputDecoration(labelText: "Telefone"),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value.contains(new RegExp(r"[a..zA..Z]")))
                        return "Esse não é um número válido!";
                      else if (value.isEmpty) {
                        _formHasFone = false;
                        return null;
                      } else {
                        _formHasFone = true;
                        return null;
                      }
                    },
                    onSaved: (value) => _formContent["fone"] = value,
                  ),
                  TextFormField(
                    controller:
                        TextEditingController(text: widget.cliente.email),
                    decoration: InputDecoration(labelText: "Email"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty) {
                        _formHasEmail = false;
                        return null;
                      } else if (!(value.contains("@") &&
                          value.contains("."))) {
                        return "Email inválido";
                      } else {
                        _formHasEmail = true;
                        return null;
                      }
                    },
                    onSaved: (value) => _formContent["email"] = value,
                  ),
                ],
              ),
            )),
        appBar: AppBar(
          title: Text("Adicionar"),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "SALVAR",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  if (!_formHasFone && !_formHasEmail) {
                    showDialog(
                        context: context,
                        builder: (context) => SimpleDialog(
                              title: Text("Precisa de um email ou um telefone"),
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    SimpleDialogOption(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("OK"),
                                    ),
                                  ],
                                )
                              ],
                            ));
                  } else {
                    _formKey.currentState.save();
                    print(_formContent.toString());
                    Cliente.put(
                      widget.cliente.id,
                      _formContent["nome"],
                      email: _formContent["email"],
                      fone: _formContent["fone"],
                    );
                    Navigator.pop(context);
                  }
                }
              },
            ),
          ],
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
  Widget actionButton(IconData icon, callback) {
    var checked = false;
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Colors.blueAccent,
      shape: CircleBorder(),
      elevation: 6,
      child: SizedBox(
        height: 60,
        width: 60,
        child: InkWell(
          onTap: callback,
          child: Icon(
            checked ? Icons.check : icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget infoEntry(key, value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              key + ": ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            Text(
              value ?? "",
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    var _customerData = Cliente.getById(widget.subjectId);
    _customerData.catchError((error) {
      print(error.toString());
    });
    print(
        "viewing subject ${widget.subjectId}\ncontext = ${context.toString()}");
    return Scaffold(
      appBar: AppBar(
          actions: <Widget>[
            FutureBuilder(
                future: _customerData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerEdit(snapshot.data)),
                      ),
                    );
                  } else {
                    return Spacer();
                  }
                }),
          ],
          title: FutureBuilder(
              future: _customerData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data.nome ?? "",
                    style: TextStyle(fontSize: 18.0),
                  );
                } else {
                  return Text(
                    "Loading...",
                    style: TextStyle(fontSize: 18.0),
                  );
                }
              })),
      body: FutureBuilder(
        future: _customerData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var _data = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                      height: 40, child: FittedBox(child: Text(_data.nome))),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      actionButton(Icons.call, () {
                        Cliente.postAction(
                          action: "contato",
                          clienteId: widget.subjectId,
                        );
                        Navigator.pop(context);
                      }),
                      actionButton(Icons.attach_money, () {
                        Cliente.postAction(
                          action: "orcamento",
                          clienteId: widget.subjectId,
                        );
                        Navigator.pop(context);
                      }),
                      actionButton(Icons.shopping_basket, () {
                        Cliente.postAction(
                          action: "venda",
                          clienteId: widget.subjectId,
                        );
                        Navigator.pop(context);
                      }),
                    ],
                  ),
                  Divider(),
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        infoEntry("Email", _data.email),
                        Divider(),
                        infoEntry("Telefone", _data.fone),
                        Divider(),
                        infoEntry("Último Contato", "28/12/1998"),
                        Divider(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          child: OutlineButton(
                            child: Text(
                              "Deletar Cliente",
                              style: TextStyle(color: Colors.red),
                            ),
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                            onPressed: () {
                              Cliente.delete(_data.id);
                              Navigator.pushReplacementNamed(
                                  context, "/clientes");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text("rsrssrrs");
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
