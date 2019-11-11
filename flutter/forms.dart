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
        body: Center(child: Text("Oie galera")),
        bottomNavigationBar: BottomNavigator(1),
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
