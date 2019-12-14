import 'package:flutter/material.dart';
import 'core.dart';

class HomeScreen extends StatefulWidget {
  final DateTime date;

  HomeScreen({this.date});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _date;
  Future<dynamic> _list;

  Widget popupMenu(BuildContext context) => PopupMenuButton(
      itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              value: "server",
              child: Text("Alterar servidor"),
            ),
            PopupMenuItem(value: "logout", child: Text("Trocar usuário")),
          ],
      onSelected: (result) {
        switch (result) {
          case "server":
            Navigator.pushNamed(context, '/server');
            break;
          case "logout":
            showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                      children: <Widget>[
                        Center(
                            child: Text("Função ainda não implementada! :(")),
                        SimpleDialogOption(
                            child: Text(
                              "OK",
                              textAlign: TextAlign.right,
                            ),
                            onPressed: () => Navigator.pop(context)),
                      ],
                    ));
            break;
        }
      });

  Widget dateSelector(BuildContext context) => GestureDetector(
        child: Text(Timestamp.dateString(_date)),
        onTap: () async {
          var _picked = await showDatePicker(
            context: context,
            initialDate: _date,
            firstDate: DateTime(1970),
            lastDate: DateTime(2050),
          );
          if (_picked != null) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreen(date: _picked)));
          }
        },
      );

  Widget cardList(BuildContext context, List<Cliente> list) =>
      ListView.separated(
        itemCount: list.length,
        separatorBuilder: (context, idx) => Divider(),
        itemBuilder: (context, idx) => list[idx].getCard(context),
      );

  @override
  Widget build(BuildContext context) {
    _date = widget.date ?? DateTime.now();
    _list = Cliente.getByDay(_date);
    return Scaffold(
      appBar: AppBar(
        title: dateSelector(context),
        centerTitle: true,
        actions: <Widget>[popupMenu(context)],
      ),
      body: FutureBuilder(
        future: _list,
        builder: (context, snapshot) {
          print(snapshot.toString());
          if (snapshot.hasData) {
            if (snapshot.data.length == 0) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                      child: Icon(
                    Icons.check_circle_outline,
                    size: 40,
                  )),
                  SizedBox(height: 16),
                  Text("Nenhum cliente agendado hoje! :)"),
                ],
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: cardList(context, snapshot.data),
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Icon(Icons.cancel),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: isSameDate(_date, DateTime.now()) || DateTime.now().isBefore(_date) ? FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => AddAction(date: _date),
          );
          setState(() {});
        }
      ) : null,
      bottomNavigationBar: BottomNavigator(Pages.Home),
    );
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    if (date1.day == date2.day && date1.month == date2.month && date1.year == date2.year) {
      return true;
    } else {
      return false;
    }
  }
}

class AddAction extends StatefulWidget {
  final DateTime date;

  AddAction({@required this.date});

  @override
  _AddActionState createState() => _AddActionState();
}

class _AddActionState extends State<AddAction> {
  Cliente _selectedCliente;
  DateTime _selectedDate;

  String getDataString(DateTime _date) =>
      "${_date.day}/${_date.month}/${_date.year}";

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Adicionar evento"),
      children: <Widget>[
        Form(
          child: Container(
            height: 130,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Data:",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 17)),
                      InkWell(
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.calendar_today),
                                  SizedBox(width: 8),
                                  Text(getDataString(_selectedDate ?? widget.date)),
                                ],
                              ),
                            ),
                          ),
                          onTap: () async {
                            _selectedDate = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate ?? widget.date,
                              firstDate: Timestamp.today(),
                              lastDate: DateTime(2050),
                            );
                            setState(() {
                              _selectedDate = _selectedDate;
                            });
                          })
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Cliente:",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 17)),
                      InkWell(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.person),
                                SizedBox(width: 8),
                                Text((_selectedCliente != null)
                                    ? _selectedCliente.nome
                                    : "Selecionar Cliente"),
                              ],
                            ),
                          ),
                        ),
                        onTap: () async => _selectedCliente =
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchCliente())),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            SimpleDialogOption(
              child: Text("CANCELAR"),
              onPressed: () => Navigator.pop(context),
            ),
            SimpleDialogOption(
              child: Text(
                "CONFIRMAR",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                if (_selectedCliente != null) {
                  Cliente.postAction(
                      action: "futuro",
                      clienteId: _selectedCliente.id,
                      timestamp:
                      (_selectedDate != null ? _selectedDate.microsecondsSinceEpoch : widget.date.microsecondsSinceEpoch) ~/ 1000000);
                  Navigator.pop(context);
                } else {
                  showDialog(
                      context: context,
                      builder: (context) => SimpleDialog(
                            title: Text("Selecione um cliente!"),
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  SimpleDialogOption(
                                    child: Text("OK"),
                                    onPressed: () => Navigator.pop(context),
                                  )
                                ],
                              )
                            ],
                          ));
                }
              },
            ),
          ],
        )
      ],
    );
  }
}
