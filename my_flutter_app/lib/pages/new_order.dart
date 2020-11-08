
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:io';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:my_flutter_app/api/packages/index.dart';
import 'package:my_flutter_app/api/proveedores/index.dart';
import 'package:my_flutter_app/constants.dart';
import 'package:my_flutter_app/states/address.dart';
import 'package:my_flutter_app/states/proveedor.dart';
import 'package:my_flutter_app/states/proveedores.dart';
import 'package:my_flutter_app/states/user.dart';
import 'package:provider/provider.dart';

  

class NewOrder extends StatefulWidget{
  @override
  _NewOrderState createState() => new _NewOrderState();
}

class _NewOrderState extends State<NewOrder>{

  final _formKey = [ new GlobalKey<FormState>() ];
  final _formkKeyCurrency = [ new GlobalKey<FormState>() ];
  final _formkKeyAddress = [ new GlobalKey<FormState>() ];
  GlobalKey<AutoCompleteTextFieldState<Proveedor>> autoCompleteKey = new GlobalKey();
  final HttpPackagesService _httpPackagesService = HttpPackagesService();
  final HttpSuppliersService _httpSuppliersService = HttpSuppliersService();
  List<Asset> images = List<Asset>();
  String _error;
  File _image;
  final _picker = ImagePicker();
  Proveedores proveedores;
  AutoCompleteTextField<Proveedor> searchTextField;
  final nameProductController = [ new TextEditingController() ];
  final linkProductController = [ new TextEditingController() ];
  final proveedorProductController = [ new TextEditingController() ];
  final priceProductController = [ new TextEditingController() ];
  final dimensionsProductController = [ new TextEditingController() ];
  final refProductController = [ new TextEditingController() ];
  final quantityProductController = [ new TextEditingController() ];
  var selectedSupplier = Proveedor({'id': 0, 'name': ''});
  final products = [ 0 ];
  int finalIndex = 0;

  double subTotal = 0.0;
  double sendCost = 0.0;
  double total = 0.0;

  String selectedCurrency = 'USD';
  Address selectedAddress;
  
  @override
  void initState() {
      super.initState();
      _getSupliers();
  }
  _addOrderReceipt(){
    print("Add receipt");
    //_getImage();
    _getImages();
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
      quantityProductController.add(new TextEditingController());
      _formKey.add(new GlobalKey<FormState>());
    });
  }

  _confirmOrder(user){
    var success = true;
    for(var i = 0; i < products.length; i++){
      //print('Name:' + nameProductController[i].text);
      if (_formKey[i].currentState.validate()) {
        // If the form is valid, display a Snackbar.
      } else if(_formkKeyCurrency[i].currentState.validate()) {

      } else if(_formkKeyAddress[i].currentState.validate()){

      } else {
        success = false;
      }
    }
    if(!success){
      return;
    }

    //for(var i = 0; i < products.length; i++){
    //  print('Name:' + nameProductController[i].text);
      
      var map = new Map<String, dynamic>();
      map['newPackage'] = 'true';
      map["idUser"] = user.id;
      map["idAddress"] = selectedAddress.id;
      map['referenceNumber'] = refProductController[0].text;
      map['description'] = nameProductController[0].text;
      map['quantity'] = quantityProductController[0].text;
      map['totalCost'] = total;
      map['shipCost'] = sendCost;
      map['packageCost'] = subTotal;
      map['idStatus'] = TRANSCURSO_ID;
      map['currency'] = selectedCurrency;
      print('------------');
      print(searchTextField.textField.controller.text);
      print(selectedSupplier.name);
      if(searchTextField.textField.controller.text != '' && selectedSupplier.name != ''){
        print("Abc:");
        map['supplierName'] = selectedSupplier.name;
        map["idSupplier"] = selectedSupplier.id;
      }
      var response = _httpPackagesService.postPackages(map, images);
      response.then((value) => {
        print("then: ${value}")
      });
      response.catchError((onError) {
        print('error::: $onError');
      });
      response.whenComplete(() => {
        print("Complete")
      });
      
    //}

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
      _formKey.removeAt(index);
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

  Future<void> _getImages() async {
    setState(() {
      //images = List<Asset>();
    });

    List<Asset> resultList = List<Asset>();
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(maxImages: 200);
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

  _getSupliers() async {
    try{
      var response = await _httpSuppliersService.getPackages(null);
      if(response.toString() != null && response['statusOperation'].toString() != null && response['statusOperation']['code'].toString() == '0'){
        var data = response['data']['suppliers'];
        //List<Proveedor> tmp = [];
        for(var i = 0; i < data.length; i++){
          proveedores.add(data[i]);
        }
        //proveedores.notifyListeners();
      }
    } catch (e){
      print('Error::: $e');
    }
  }
  @override
  Widget build(BuildContext context){
    proveedores = Provider.of<Proveedores>(context);
    final user = Provider.of<User>(context, listen: false);
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
              child: Form(
                key: _formKey[0],
                child: SingleChildScrollView(
                  child: Column(
                    children: getNewOrderWidgets(0, user)
                  )
                )
              )
              //child: Column(
              //  children: getNewOrderWidgets(0)
              //)
              
              /*ListView.builder(
                itemCount: products.length,
                itemBuilder: (BuildContext context, int index) {
                  return getExpandableWidget(index);
                }
              ),*/
            ),
            /*
            Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
              child: FloatingActionButton(
                //onPressed: (){ _addNewElement(); },
                child: Icon(Icons.add),
              ),
            ),
            */
            Container(
              height: 50.0,
              child: buildGridView(),
            ),
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
                onPressed: () {_confirmOrder(user);}
              ),
            )
          ]
        ),
      ),
    );
  }

  Widget buildGridView() {
    if(images.length <= 0){
      return SizedBox.shrink();
    }

    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 50,
          height: 50,
        );
      }),
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

  Widget getExpandableWidget(int index, User user){
    return(
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 14.0),
            child: InkWell(
              //onTap: (){ _deleteElement(index); },
              child: Icon(Icons.delete),
            ),
          ),
          Expanded(
            child: ExpansionTile(
              title: Text("Orden"),
              children: [
                Form(
                  key: _formKey[index],
                  child: Column(children: getNewOrderWidgets(index, user),)
                )
              ],
            ),
          )
        ],
      )
    );
  }

  List<Widget> getNewOrderWidgets(int index, User user){
    List<Address> address = [];//[Address.localAddress(0)];
    address.add(Address.localAddress(1));
    user.addresses.forEach((element) {address.add(element);});
    return [
      renderTextFormField(nameProductController[index], "Descripción"),
      Row(
        children: [
          Expanded(
            child: renderTextFormField(priceProductController[index], "Costo del Paquete"),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: DropdownButtonFormField<String>(
                key: _formkKeyCurrency[0],
                value: selectedCurrency,
                hint: Text(
                  'USD',
                ),
                onChanged: (currency) =>
                    setState(() => selectedCurrency = currency),
                validator: (value) => value == null ? 'Campo Obligatorio' : null,
                items:
                    ['USD', 'MXN'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            )
          )
        ],
      ),
      FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot){
          return renderAutocomplete();
        }
      ),
      renderTextFormField(refProductController[index], "Referencia de Rastreo"),
      renderTextFormField(quantityProductController[index], "Cantidad"),
      DropdownButtonFormField<Address>(
                key: _formkKeyAddress[0],
                value: selectedAddress,
                hint: Text(
                  'Direccion',
                ),
                onChanged: (address) =>
                    setState(() => selectedAddress = address),
                validator: (value) => value == null ? 'Campo Obligatorio' : null,
                items:
                  address.map<DropdownMenuItem<Address>>((Address value) {
                    return DropdownMenuItem<Address>(
                      value: value,
                      child: _renderAddress(value),
                    );
                  }).toList(),
              ),
    ];
  }

  Widget _renderAddress(item){
    //return _renderValue('title', 'subtitle');
    Address address = item;
    return Text(
                  '${address.addressLine1} ${address.extNumber} - ${address.city} - ${address.state}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                  style: TextStyle(
                    color: Colors.grey,
                    //fontWeight: FontWeight.bold,
                    fontSize: 14
                  )
                
    );
  }
  Widget renderTextFormField(controller, hint){
    return 
      TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
        validator: (value) {
          if (value.isEmpty) {
            return 'Campo obligatorio';
          } else {
            return null;
          }
        },
      );
  }
  Widget renderAutocomplete(){
    var tmp = proveedores.getList();
    if(tmp.length == 0){
      return TextFormField(
        //controller: proveedorProductController[0],
        decoration: InputDecoration(
          hintText: "Descripción",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
        validator: (value) {
          if (value.isEmpty) {
            return 'Campo obligatorio';
          } else {
            return null;
          }
        },
        onChanged: (value){
          selectedSupplier.setName(value);
        },
      );
    }
    return searchTextField = AutoCompleteTextField<Proveedor>(
      key: autoCompleteKey,
      suggestions: proveedores.getList(),
      submitOnSuggestionTap: true,
      clearOnSubmit: false,
      style: TextStyle(color: Colors.black, fontSize: 12.0),
      decoration: InputDecoration(
        hintText: 'Proveedor',
        hintStyle: TextStyle(color: Colors.grey),
        //contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0)
      ),
      itemFilter: (item, query){
        return item.name.toLowerCase().startsWith(query.toLowerCase());
      },
      itemSorter: (a, b){
        return a.name.compareTo(b.name);
      },
      itemSubmitted: (item){
        print(item.id);
        print(item.name);
        setState(() {
          searchTextField.textField.controller.text = item.name;
          selectedSupplier = item;
        });
      },
      itemBuilder: (context, item) {
        return Text(item.name);
      },
      
    );
  }
}
