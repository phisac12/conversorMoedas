// @dart=2.9

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance";

void main() async {

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
        primaryColor: Colors.white
    ),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();


  double dolar;
  double euro;

  void _realChanged(String text){
    if(text.isEmpty) {
      clearFields();
      return;
    }

    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text){
    if(text.isEmpty) {
      clearFields();
      return;
    }

    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text){
    if(text.isEmpty) {
      clearFields();
      return;
    }

    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("\$ Conversor de Moedas \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: Text("Carregando Dados ...",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25,),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if(snapshot.hasError){
                return const Center(
                  child: Text("Erro ao carregar dados :(",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25,),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dolar = snapshot.data['results']['currencies']['USD']['buy'];
                euro = snapshot.data['results']['currencies']['EUR']['buy'];

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(Icons.monetization_on, size: 150, color: Colors.amber),
                      buildTextField('Reais', 'R\$ ', realController, _realChanged),
                      const Divider(),
                      buildTextField('Dolares', '\$ ', dolarController, _dolarChanged),
                      const Divider(),
                      buildTextField('Euros', '£ ', euroController, _euroChanged)
                    ],
                  ),
                );
              }
          }
        }) ,
    );
  }

  Widget buildTextField(String label, String prefix, TextEditingController c, Function f){
    return TextField(
      controller: c,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).hintColor
              )
          ),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.amber),
          border: const OutlineInputBorder(),
          prefixText: prefix
      ),
      style: const TextStyle(color: Colors.amber, fontSize: 25),
      onChanged: f,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
    );
  }

  clearFields(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }
}





