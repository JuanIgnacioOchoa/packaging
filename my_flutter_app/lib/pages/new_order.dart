import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NewOrder extends StatefulWidget{
  @override
  _NewOrderState createState() => new _NewOrderState();
}

class _NewOrderState extends State<NewOrder>{
  //List<Asset> images = List<Asset>();
  String _error;
  File _image;
  final _picker = ImagePicker();

  final nameProductController = [ new TextEditingController() ];
  final linkProductController = [ new TextEditingController() ];
  final proveedorProductController = [ new TextEditingController() ];
  final priceProductController = [ new TextEditingController() ];
  final dimensionsProductController = [ new TextEditingController() ];
  final refProductController = [ new TextEditingController() ];
  
  final products = [ 0 ];
  int finalIndex = 0;

  double subTotal = 0.0;
  double sendCost = 0.0;
  double total = 0.0;

  
  _addOrderReceipt(){
    print("Add receipt");
    _getImage();
    //_getImages();
  }

  _addNewElement(){
    finalIndex = finalIndex + 1;

    print("_addNewElement " + finalIndex.toString());
    
    setState(() {
      products.add(finalIndex);
      nameProductController.add(new TextEditingController());
      linkProductController.add(new TextEditingController());
      proveedorProductController.add(new TextEditingController());
      priceProductController.add(new TextEditingController());
      dimensionsProductController.add(new TextEditingController());
      refProductController.add(new TextEditingController());
    });
  }

  _confirmOrder(){
    for(var i = 0; i < products.length; i++){
      print('Name:' + nameProductController[i].text);
    }
  }

  _deleteElement(index){
    print("_deleteElement: " + index.toString());
    setState(() {
      products.removeAt(index);
      nameProductController.removeAt(index);
      linkProductController.removeAt(index);
      proveedorProductController.removeAt(index);
      priceProductController.removeAt(index);
      dimensionsProductController.removeAt(index);
      refProductController.removeAt(index);
    });
    _costChange();
  }

  _costChange(){
    double newValue = 0.0;
    for(var i = 0; i < priceProductController.length; i++){
      String newValueStr = priceProductController[i].text;
      if(newValueStr != ''){
        newValue += int.parse(priceProductController[i].text);
      }
    }
    setState(() {
      subTotal = newValue;
      sendCost = newValue * .1;
      total = newValue * 1.1;
    });
  }

  Future _getImage() async {
    var pickedFile = await _picker.getImage(source: ImageSource.gallery);

    File imgFile = File(pickedFile.path);

    setState(() {
      _image = imgFile;
      print('_image: $_image');
    });
  }
/*
  Future<void> _getImages() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    print("Error: $error");
    print('result $resultList');
    setState(() {
      images = resultList;
      if (error == null) _error = 'No Error Dectected';
    });
  }
*/
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
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (BuildContext context, int index) {
                  return getExpandableWidget(index);
                }
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
              child: FloatingActionButton(
                onPressed: (){ _addNewElement(); },
                child: Icon(Icons.add),
              ),
            ),
            _showImage(),
            Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: RaisedButton(
                child: Center(
                  child: Text("Agregar comprobante de Pedido",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Poppins-Bold",
                      fontSize: 18,
                      letterSpacing: 1.0
                    )
                  ),
                ),
                onPressed: _addOrderReceipt,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left:50.0, right: 10.0, bottom: 30.0),
              child: Table(
                children: [
                  TableRow(
                    children: [
                      Align(alignment: Alignment.centerRight, child: Text("Subtotal: "),),
                      Align(alignment: Alignment.centerRight, child: Text(subTotal.toStringAsFixed(2)),),
                    ],
                  ),
                  TableRow(
                    children: [
                      Align(alignment: Alignment.centerRight, child: Text("Costo de Envio: "),),
                      Align(alignment: Alignment.centerRight, child: Text(sendCost.toStringAsFixed(2)),),
                    ],
                  ),
                  TableRow(
                    children: [
                      Align(alignment: Alignment.centerRight, child: Text("Total: "),),
                      Align(alignment: Alignment.centerRight, child: Text(total.toStringAsFixed(2)),),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30.0),
              child: RaisedButton(
                child: Center(
                  child: Text("Confirmar Orden",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Poppins-Bold",
                      fontSize: 18,
                      letterSpacing: 1.0
                    )
                  ),
                ),
                onPressed: _confirmOrder,
              ),
            )
          ]
        ),
      ),
    );
  }

  Widget _showImage(){
    if(_image != null){
      return Container(
        height: 50,
        width: 50,
        child: Image.file(_image),
      );
    }
    return SizedBox.shrink();
  }
  Widget getExpandableWidget(int index){

    return(
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 14.0),
            child: InkWell(
              onTap: (){ _deleteElement(index); },
              child: Icon(Icons.delete),
            ),
          ),
          Expanded(
            child: ExpansionTile(
              title: Text("Nombre del Producto"),
              children: getNewOrderWidgets(index),
            ),
          )
        ],
      )
    );
  }
  List<Widget> getNewOrderWidgets(int index){
    return [
      TextField(
        controller: nameProductController[index],
        decoration: InputDecoration(
          hintText: "Nombre del Producto",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
      ),
      TextField(
        controller: linkProductController[index],
        decoration: InputDecoration(
          hintText: "Link del Producto",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
      ),
      TextField(
        controller: proveedorProductController[index],
        decoration: InputDecoration(
          hintText: "Proveedor",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
      ),
      TextField(
        controller: priceProductController[index],
        keyboardType: TextInputType.numberWithOptions(
          decimal: true,
        ),
        //inputFormatters: [_amountValidator],
        decoration: InputDecoration(
          hintText: "Costo del Producto",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
        onChanged: (text) {
          _costChange();
        },
      ),
      TextField(
        controller: dimensionsProductController[index],
        decoration: InputDecoration(
          hintText: "Dimensiones",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
      ),
      TextField(
        controller: refProductController[index],
        decoration: InputDecoration(
          hintText: "Referencia de Rastreo",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
      ),
    ];
  }
}
