
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:io';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:top_express/api/packages/index.dart';
import 'package:top_express/api/proveedores/index.dart';
import 'package:top_express/common/alert_dialog.dart';
import 'package:top_express/constants.dart';
import 'package:top_express/states/address.dart';
import 'package:top_express/states/proveedor.dart';
import 'package:top_express/states/proveedores.dart';
import 'package:top_express/states/client.dart';
import 'package:provider/provider.dart';

  

List<String> inputsLabelArray = ['Descripción', 'Costo del Paquete', 'Moneda', 'Proveedor', 'Referencia de Rastreo', 'Cantidad', 'Direccion'];

String _validator(value, i){
  switch(i){
    case 0: //Descripcion
      if (value.isEmpty) {
        return 'Campo obligatorio';
      } 
      break;
    case 1: //Costo del Paquete
      if (value.isEmpty) {
        return 'Campo obligatorio';
      } else if(double.tryParse(value) == null){
        return 'El campo debe ser numero';
      }
      break;
    case 2: //Moneda
      if(value == null){
        return 'Campo obligatorio';
      }
      break;
    case 3: //Proveedor
      if(value == null){
        return 'Campo obligatorio';
      }
      break;
    case 4: //Referencia
      break;
    case 5: //Cantidad
      if (value.isEmpty) {
        return 'Campo obligatorio';
      } else if( value == int){
        return 'El campo debe ser numero a';
      }
      break;
    case 6: //Direccion
      if(value == null){
        return 'Campo obligatorio';
      }
      break;
    default:
      return null;
  }
  return null;
}
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
  Client client;
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

  loadPackagesSuccess(value){
    print("3--------------3");
    var data = value['data']['packages'];
    var active = data['active'];
    var delivered = data['delivered'];
    print(active);
    client.setNewPackage(active, delivered);

          const title = Text("Registro exitoso");
          var body = [
            Text("Paquete Guardado con exito"),
            //Text(value["statusOperation"]["description"].toString()),
          ];
          CustomAlertDialog(context,title, body, 2);
  }

  loadPackageError(error){
    print('error $error');
    setState(() {
      //_loading = false;
    });
  }

  submitSuccessImage(value){
    //_success = true;
    try{
      int code = value["statusOperation"]["code"];
      
      if(code == 0){
      } else {
        const title = Text("Registro Fallido");
        var body = [
          Text("Hubo un error al guardar los datos."),
          Text(value["statusOperation"]["description"].toString()),
        ];
        CustomAlertDialog(context,title, body, 1);
      }
    } catch(e){
      print("Error: $e");
      const title = Text("Registro Fallido");
      const body = [
        Text("Error en la respuesta del servidor")
      ];
      CustomAlertDialog(context,title, body, 1);
    }

    //Navigator.of(context).pop();
  }
  submitSuccess(value) async {
    print("Submit Success ----- " + value.toString());
    //_success = true;
    try{
      int code = value["statusOperation"]["code"];
      
      if(code == 0){
        var map = new Map<String, dynamic>();
        var p = value["data"]["packages"][0];
        print(p.toString());
        map['id'] = p["id"];
        map['idClient'] = p["id_client"];
        map['idAddress'] = p["id_address"];
        /*
        for(var i = 0; i < images.length; i++){
          var response = await _httpPackagesService.postPackagesImage(map, images[i]);
          submitSuccessImage(response);
        }
        */
        try{
          print("1 hola -------");
          var body = json.encode({ "idClient": client.id});
          var response = await _httpPackagesService.getPackages(body);
          loadPackagesSuccess(response);
        } on Exception catch (exception) {
          loadPackageError(exception);
          throw 'Exception';
        } catch (error) {
          loadPackageError(error);
          throw 'Error';
        }
        
      } else {
        const title = Text("Registro Fallido");
        var body = [
          Text("Hubo un error al guardar los datos."),
          Text(value["statusOperation"]["description"].toString()),
        ];
        CustomAlertDialog(context,title, body, 1);
      }
    } catch(e){
      print("Error: $e");
      const title = Text("Registro Fallido");
      const body = [
        Text("Error en la respuesta del servidor")
      ];
      CustomAlertDialog(context,title, body, 1);
    }

    //Navigator.of(context).pop();
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

  _confirmOrder() async{
    print("_confirmOrder");
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
      print("_confirmOrder 2");
      //var map = new Map<String, dynamic>();
      var packageMap = new Map<String, dynamic>();
      //map['newPackage'] = 'true';
      packageMap["idClient"] = client.id;
      packageMap["idAddress"] = selectedAddress.id;
      packageMap['referenceNumber'] = refProductController[0].text;
      packageMap['description'] = nameProductController[0].text;
      packageMap['quantity'] = quantityProductController[0].text;
      packageMap['totalCost'] = total;
      packageMap['shipCost'] = sendCost;
      packageMap['packageCost'] = subTotal;
      packageMap['idStatus'] = TRANSCURSO_ID;
      packageMap['currency'] = selectedCurrency;
      print('------------');
      if(searchTextField == null){
        packageMap['supplierName'] = proveedorProductController[0].text;
      } else {
        if(searchTextField.textField.controller.text != '' && selectedSupplier.name != ''){
          packageMap["idSupplier"] = selectedSupplier.id;
        } else {
          packageMap['supplierName'] = selectedSupplier.name;
        }
      }
      //map['packages'] = [packageMap];
      //print("_confirmOrder 3: "+ map.toString());

      var response = await _httpPackagesService.postPackages(packageMap, images);
      //print("Response:$response ");
      submitSuccess(response);
      /*
      response.then((value) {
        print("thennn: ${value.toString()}");
        submitSuccess(value);
      });
      response.catchError((onError) {
        print('error::: $onError');
      });
      response.whenComplete(() => {
        print("Complete")
      });
      */
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
    print("Cost change");
    double newValue = 0.0;
    for(var i = 0; i < priceProductController.length; i++){
      String newValueStr = priceProductController[i].text;
      if(newValueStr != ''){
        newValue += int.parse(priceProductController[i].text);
      }
    }
    setState(() {
      subTotal = newValue;
      sendCost = newValue * .2;
      total = newValue * 1.2;
    });
  }

  Future _getImage() async {
    var pickedFile = await _picker.getImage(source: ImageSource.gallery);

    File imgFile = File(pickedFile.path);

    setState(() {
      _image = imgFile;
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
    client = Provider.of<Client>(context, listen: false);
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
                    children: [
                      Column(
                        children: getNewOrderWidgets(0),
                      ),
                      Column(
                        children: [
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
                onPressed: () {_confirmOrder();}
              ),
            )
                        ],
                      )
                    ]
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

  Widget getExpandableWidget(int index){
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
                  child: Column(children: getNewOrderWidgets(index),)
                )
              ],
            ),
          )
        ],
      )
    );
  }

  List<Widget> getNewOrderWidgets(int index){
    List<Address> addressList = [];//[Address.localAddress(0)];
    //addressList.add(Address.localAddress(1));
    client.addressesClient.forEach((element) {addressList.add(element);});
    client.addressesGlobal.forEach((element) {addressList.add(element);});
    return [
      renderTextFormField(nameProductController[index], 0), //Desc
      Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: priceProductController[index],
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: inputsLabelArray[1],
                hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
              validator: (value) {
                return _validator(value, 1); //costo
              },
              onChanged: (text) {
                _costChange();
              },
            ),
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
                validator: (value) {
                  return _validator(value, 2); //Moneda
                },
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
      renderTextFormField(refProductController[index], 4), //Referencia
      TextFormField(
              controller: quantityProductController[index],
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: inputsLabelArray[5],
                hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
              validator: (value) {
                return _validator(value, 5); //Cantidad
              },
            ),
      DropdownButtonFormField<Address>(
                key: _formkKeyAddress[0],
                value: selectedAddress,
                hint: Text(
                  inputsLabelArray[6],
                ),
                onChanged: (address){
                  print(address);
                  setState(() => selectedAddress = address);
                }
                    ,
                validator: (value) {
                  return _validator(value, 6);
                },
                items:
                  addressList.map<DropdownMenuItem<Address>>((Address value) {
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
                  '${address.addressLine1} ${address.extNumber} ',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                  style: TextStyle(
                    color: Colors.grey,
                    //fontWeight: FontWeight.bold,
                    fontSize: 14
                  )
                
    );
  }
  Widget renderTextFormField(controller, i){
    return 
      TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: inputsLabelArray[i],
          hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
        validator: (value) {
          return _validator(value, i);
        },
      );
  }
  Widget renderAutocomplete(){
    var tmp = proveedores.getList();
    if(tmp.length == 0){
      return TextFormField(
        controller: proveedorProductController[0],
        decoration: InputDecoration(
          hintText: inputsLabelArray[3],
          hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
        validator: (value) {
          return _validator(value, 3);
        },
        onChanged: (value){
          selectedSupplier.setName(value);
        },
      );
    }
    searchTextField = AutoCompleteTextField<Proveedor>(
      key: autoCompleteKey,
      suggestions: proveedores.getList(),
      submitOnSuggestionTap: true,
      clearOnSubmit: false,
      style: TextStyle(color: Colors.black, fontSize: 12.0),
      decoration: InputDecoration(
        hintText: inputsLabelArray[3],
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
    print("Search $searchTextField");
    return searchTextField;
  }
}
