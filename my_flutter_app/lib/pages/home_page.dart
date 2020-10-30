import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:my_flutter_app/api/packages/index.dart';
import 'package:my_flutter_app/common/loading.dart';
import 'package:my_flutter_app/pages/main_tab_container.dart';
import 'package:my_flutter_app/pages/new_order.dart';
import 'package:my_flutter_app/states/package.dart';
import 'package:my_flutter_app/states/proveedores.dart';
import 'package:provider/provider.dart';

List<Package> activeList = [];

List<Package> deliveredList = [];

class HomePage extends StatefulWidget{
    @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage>{
  final HttpPackagesService _httpPackagesService = HttpPackagesService();
  bool _loading;
  Future<Map <String, dynamic>> _myList;
  @override
  void initState() {
      super.initState();
      _loading = false;
      _myList = loadPackages();
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
    activeList = [];
    deliveredList = [];
    for(var i = 0; i < active.length; i++){
      activeList.add(Package(active[i]));
    }
    for(var i = 0; i < delivered.length; i++){
      deliveredList.add(Package(delivered[i]));
    }
    print(activeList);
    setState(() {
      _loading = false;
    });
  }

  loadPackageError(error){
    print('error $error');
    setState(() {
      _loading = false;
    });
  }

  Future<Map <String, dynamic>> loadPackages() async {
    setState(() {
      _loading = true;
    });
    try{
      var body = json.encode({ "idUser": 1});
      var response = _httpPackagesService.getPackages(body);
      response.then((value) => {
        loadPackagesSuccess(value)    
      });
      response.catchError((onError) => {
        loadPackageError(onError)
      });
      return response;
    } on Exception catch (exception) {
      setState(() {
        _loading = false;
      });
      throw 'Exception';
    } catch (error) {
      setState(() {
        _loading = false;
      });
      throw 'Error';
    }
  }

  @override
  Widget build(BuildContext context){
    //loadPackages();
    return new Scaffold(
      body: FutureBuilder(
        future: _myList,
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if(!snapshot.hasData){
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
                child: _showProductsList(activeList),
              ),
            ),
            Divider(color: Colors.black),
            Text("Productos Entregados", style: TextStyle(fontSize: 20.0),),
            Expanded(
              child: Container(
                child: _showProductsList(deliveredList),
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