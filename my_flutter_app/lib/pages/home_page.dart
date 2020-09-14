import 'package:flutter/material.dart';
import 'package:my_flutter_app/pages/main_tab_container.dart';
import 'package:my_flutter_app/pages/new_order.dart';

final List<String> entriesA = <String>['A', 'B', 'C'];

final List<String> entriesB = <String>['1', '2', '3'];

class HomePage extends StatelessWidget{


  floatingActionAdd(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewOrder()),
    );
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 60.0),
        child: Column(
          children: [
            Divider(color: Colors.black),
            Text("Productos Activos", style: TextStyle(fontSize: 20.0)),
            Expanded(
              child: Container(
                child: _showActiveProductsList(),
              ),
            ),
            Divider(color: Colors.black),
            Text("Productos Entregados", style: TextStyle(fontSize: 20.0),),
            Expanded(
              child: Container(
                child: _showDeliveredProductsList(),
              ),
            )
          ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          floatingActionAdd(context);
        },
      ),
    );
  }

    Widget _showActiveProductsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: entriesA.length,
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
                    child: Image.asset("assets/images/logo.png"),
                  )
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Text("Nombre Del Producto: ",)
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Text("Status: ")
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Text("Numero de Referencia: ")
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

  Widget _showDeliveredProductsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: entriesB.length,
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
                    child: Image.asset("assets/images/logo.png"),
                  )
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Text("Nombre Del Producto: ")
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Text("Status: ")
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Text("Numero de Referencia: ")
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
