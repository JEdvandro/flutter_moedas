import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:decimal/decimal.dart';

const request =
    "https://api.hgbrasil.com/finance/quotations?format=json&key=e698abb3";

void main() async {
  print(await getdata());
  runApp(MaterialApp(
    debugShowCheckedModeBanner:false,
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
    ),
  ));
}

Future<Map> getdata() async {
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
  double bitcoin;

   void _resetFields(){
     realController.text = ""; 
     dolarController.text = "";
     euroController.text = "";
  }

  void _realChanged(String text) {
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
         actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed:  _resetFields,
          ),
        ],
      ),
      body: FutureBuilder<Map>(
          future: getdata(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    "Carregando Dados...",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Erro ao Carregar Dados...",
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  bitcoin = snapshot.data["results"]["currencies"]["BTC"]["buy"];
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(
                          Icons.monetization_on,
                          size: 80.0,
                          color: Colors.amber,
                        ),
                        Divider(),
                        buildTextField(
                            "Reais", "R\$ ", realController, _realChanged),
                        Divider(),
                        buildTextField(
                            "Dólares", "US\$ ", dolarController, _dolarChanged),
                        Divider(),
                        buildTextField(
                            "Euro", "€ ", euroController, _euroChanged),
                            Divider(),
                        Text(
              "Cotação do dia",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.amber,
                  fontStyle: FontStyle.normal,
                  fontSize: 20.0),
            ),    
                        Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: FlatButton(
                    child: Text(
                      "Dólar",
                      style: TextStyle(fontSize: 15.0, color: Colors.amber),
                    ),
                    onPressed: () {
                     
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: FlatButton(
                    child: Text(
                      "Euro",
                      style: TextStyle(fontSize: 15.0, color: Colors.amber),
                    ),
                    onPressed: () {
                    
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: FlatButton(
                    child: Text(
                      "BitCoin",
                      style: TextStyle(fontSize: 15.0, color: Colors.amber),
                    ),
                    onPressed: () {
                    
                    },
                  ),
                ),
              ],
            ),    
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(1.0),
                  child: FlatButton(
                    child: Text(
                      "R\$  ${dolar.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 15.0, color: Colors.amber),
                    ),
                    onPressed: () {
                     
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(1.0),
                  child: FlatButton(
                    child: Text(
                      " R\$  ${euro.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 15.0, color: Colors.amber),
                    ),
                    onPressed: () {
                    
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(1.0),
                  child: FlatButton(
                    child: Text(
                      "R\$  ${bitcoin.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 15.0, color: Colors.amber),
                    ),
                    onPressed: () {
                    
                    },
                  ),
                ),
              ],
            ),    
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

Widget buildTextField(
    String label, String prefix, TextEditingController controle, Function f) {
  return TextField(
    controller: controle,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: TextStyle(
      color: Colors.amber,
      fontSize: 20.0,
    ),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}

 