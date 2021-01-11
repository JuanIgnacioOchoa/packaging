import 'package:flutter/material.dart';
import 'package:top_express/pages/new_order.dart';

final List<String> entriesA = <String>['A', 'B', 'C'];

final List<String> entriesB = <String>['1', '2', '3'];

class NotificationPage extends StatelessWidget{


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
            Text("Notificaciones", style: TextStyle(fontSize: 20.0)),
            Expanded(
              child: Container(
                child: _showActiveProductsList(),
              ),
            ),
          ]
        ),
      ),
    );
  }

    Widget _showActiveProductsList() {
    return ListView.builder(
      //padding: const EdgeInsets.all(8),
      itemCount: entriesA.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.only(top: 2.0),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.0, color: Colors.grey),
                bottom: (index == entriesA.length - 1 ? BorderSide(width: 1.0, color: Colors.grey) : BorderSide(width: 0.0, color: Colors.white)),
              )
            ),
            child: Row(
              children: [
                Image.asset('assets/images/topexpress_logo.png'),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Tu paquete esta en curso"),
                      Text("4-Jul-2020 16:05"),
                    ],
                  ),
                )
              ],
            )
          ),
        );
      }
    );
  } 

}
