import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:top_express/api/packages/index.dart';
import 'package:top_express/common/alert_dialog.dart';
import 'package:top_express/common/loading.dart';
import 'package:top_express/pages/new_order.dart';
import 'package:top_express/states/proveedores.dart';
import 'package:provider/provider.dart';
import 'package:top_express/states/client.dart';

class HomePage extends StatefulWidget{
    @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage>{
  final HttpPackagesService _httpPackagesService = HttpPackagesService();
  bool _loadingCalled;
  Future<Map <String, dynamic>> _myList;

  Client client;

  @override
  void initState() {
      super.initState();
      _loadingCalled = false;
  }

  floatingActionAdd(BuildContext context){
    /*
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewOrder()),
    );
    */
    /*
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => User()),
    ],
    child: MaterialApp(
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: LIGHT_GREEN,
        primaryColor: DARK_GREEN
      ),
    ),
  )
    */
    /*
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => Provider(
          create: (context) => Proveedores(),
          builder: (context, child) => NewOrder(),
        ),
      ),
    );
    */
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => Proveedores())
          ],
          child: NewOrder(),
        )
      )
    );
  }

  loadPackagesSuccess(value){

    var data = value['data']['packages'];
    print(data);
    var active = data['active'];
    var delivered = data['delivered'];
    print(active);
    client.setNewPackage(active, delivered);
  }

  loadPackageError(error){
    print('error $error');
    const title = Text("Error");
    var body = [
      Text("Hubo un error al cargar los datos."),
      Text(error.toString()),
    ];
    CustomAlertDialog(context,title, body, 1);
  }

  Future<Map <String, dynamic>> loadPackages() async {
    setState(() {
      _loadingCalled = true;
    });
    try{

      print('getPackages : ${client}');
      var body = json.encode({ "idClient": client.id});
      var response = _httpPackagesService.getPackages(body);
      response.then((value) => {
        loadPackagesSuccess(value)    
      });
      response.catchError((onError) => {
        loadPackageError(onError)
      });
      return response;
    } on Exception catch (exception) {
      loadPackageError(exception);
      throw 'Exception';
    } catch (error) {
      loadPackageError(error);
      throw 'Error';
    }
  }

  @override
  Widget build(BuildContext context){
    client = Provider.of<Client>(context);
    print("Client: ${client.packagesActive}");
    print("Client: ${client.packagesDelivered}");
    print("Client: ${client}");
    //loadPackages();
    if(client.packagesActive == null || client.packagesDelivered == null){
      if(!_loadingCalled){
        loadPackages();
      }
      return new Scaffold(
        body: Loading(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            floatingActionAdd(context);
          },
        )
      );
    } else {
      return new Scaffold(
        body: _render(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            floatingActionAdd(context);
          },
        )
      );
    }
    return new Scaffold(
      body: FutureBuilder(
        future: _myList,
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if(client.packagesActive == null || client.packagesDelivered == null){
            //loadPackages();
            return Loading();
          } 
          return _render();
        }
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          floatingActionAdd(context);
        },
      )
    );
  }

  Widget _render(){
    return Padding(
        padding: EdgeInsets.only(top: 60.0),
        child: Column(
          children: [
            Divider(color: Colors.black),
            Text("Productos Activos", style: TextStyle(fontSize: 20.0)),
            Expanded(
              child: Container(
                child: _showProductsList(client.packagesActive),
              ),
            ),
            Divider(color: Colors.black),
            Text("Productos Entregados", style: TextStyle(fontSize: 20.0),),
            Expanded(
              child: Container(
                child: _showProductsList(client.packagesDelivered),
              ),
            )
          ]
        ),
      );
  }
    Widget _showProductsList(entries) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: entries.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.only(top: 2.0),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              border: Border.all(width: 2.0, color: Colors.black)
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Container(
                    child: Image.asset("assets/images/topexpress_logo.png"),
                  )
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Text(( entries[index].description != null ? entries[index].description : '---------'))
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Text("Status: " + ( entries[index].status != null ? entries[index].status : '---------'))
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Text("Numero de Referencia: " + ( entries[index].referenceNumber != null ? entries[index].referenceNumber : '---------'))
                        ),
                      ),
                    ]
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  } 
}