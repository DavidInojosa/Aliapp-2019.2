import 'package:flutter/material.dart';
import 'core.dart';

class PlaceholderDia extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
            title: Text("Ali App"),
            actions: <Widget>[popupMenu(context)],
          ),
        body: Center(child: Column(
          children: <Widget>[
            Text("Oie galera"),
            SizedBox(height: 15,),
            RaisedButton(
              child: Text("TESTE POST"),
              onPressed: () => Cliente.post("Fulanin deTau", fone: "(81) 9 8636-0104", email:"zobarov@rusbe.lalala"),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: InkWell(
                  onTap: () => {},
                  splashColor: Theme.of(context).hoverColor,
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ListTile(
                          leading: CircleAvatar(),
                          title: Text("Fulano de Tal",
                            style: Theme.of(context).textTheme.title),
                          subtitle: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text("(81) 99876-7112\nÚltimo contato 28/07",
                              style: TextStyle(fontStyle: FontStyle.italic),),
                          ),
                      ),
                  ),
                ),
              ),
            ),
          ],
        )),
        bottomNavigationBar: BottomNavigator(Pages.Home),
      );
  Widget popupMenu(BuildContext context) => PopupMenuButton(
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: "server",
          child: Text("Alterar servidor"),
        ),
        PopupMenuItem(
          value: "logout",
          child: Text("Trocar usuário")
        ),
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
                      Center(child: Text("Função ainda não implementada! :(")),
                      SimpleDialogOption(
                          child: Text("OK", textAlign: TextAlign.right,),
                          onPressed: () => Navigator.pop(context)),
                    ],
            ));
            break;
        }
      }
  );
}
