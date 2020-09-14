import 'package:flutter/material.dart';

class NewOrder extends StatefulWidget{
  @override
  _NewOrderState createState() => new _NewOrderState();
}

class _NewOrderState extends State<NewOrder>{

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: AppBar(
        title: Text("Nueva Orden"),
        leading: BackButton(
          color: Colors.white,  
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 14.0),
                        child: Icon(Icons.delete),
                      ),
                      Expanded(
                        child: ExpansionTile(
                          title: Text("Nombre del Producto"),
                          children: getNewOrderWidgets(),
                        ),
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 14.0),
                        child: Icon(Icons.delete),
                      ),
                      Expanded(
                        child: ExpansionTile(
                          title: Text("Nombre del Producto"),
                          children: getNewOrderWidgets(),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: FloatingActionButton(
                onPressed: (){ print("Add"); },
                child: Icon(Icons.add),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left:50.0, right: 10.0, bottom: 40.0),
              child: Table(
                children: [
                  TableRow(
                    children: [
                      Align(alignment: Alignment.centerRight, child: Text("Subtotal: "),),
                      Align(alignment: Alignment.centerRight, child: Text("1,000.00"),),
                    ],
                  ),
                  TableRow(
                    children: [
                      Align(alignment: Alignment.centerRight, child: Text("Costo de Envio: "),),
                      Align(alignment: Alignment.centerRight, child: Text("100.00"),),
                    ],
                  ),
                  TableRow(
                    children: [
                      Align(alignment: Alignment.centerRight, child: Text("Total: "),),
                      Align(alignment: Alignment.centerRight, child: Text("1,100.00"),),
                    ],
                  ),
                ],
              ),
            ),
            
          ]
        ),
      ),
    );
  }

  List<Widget> getNewOrderWidgets(){
    return [
      TextField(
        decoration: InputDecoration(
          hintText: "Nombre del Producto",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
      ),
      TextField(
        decoration: InputDecoration(
          hintText: "Link del Producto",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
      ),
      TextField(
        decoration: InputDecoration(
          hintText: "Proveedor",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
      ),
      TextField(
        decoration: InputDecoration(
          hintText: "Costo del Producto",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
      ),
      TextField(
        decoration: InputDecoration(
          hintText: "Dimensiones",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
      ),
      TextField(
        decoration: InputDecoration(
          hintText: "Referencia de Rastreo",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
      ),
    ];
  }
}
