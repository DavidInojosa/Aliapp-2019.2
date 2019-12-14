import 'package:flutter/material.dart';
import 'maps.dart';
import 'core.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Adicionar Endereço/CEP';

    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.close),
            onPressed: ()=> Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Mapa()
            ),
            ),
          ),
        ],
        ),
        bottomNavigationBar: BottomNavigator(Pages.Mapa),
        body: MyCustomForm(),
      ),
    );
  }
}
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}
class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                // se o forms estiver vazio
                return 'Escreva algo aqui';
              }
            else{
            print(value);
            return null;
            }
              },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  // Se o form tiver algo inserido vai retornar :
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                }
              },
              child: Text('Adicionar'),
            ),
          ),
        ],
      ),
    );
  }
}
