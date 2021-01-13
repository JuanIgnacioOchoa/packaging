import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:top_express/api/address/index.dart';
import 'package:top_express/common/alert_dialog.dart';
import 'package:top_express/common/loading.dart';
import 'package:top_express/constants.dart';
import 'package:top_express/states/client.dart';
import 'package:provider/provider.dart';

class NewAddressPage extends StatefulWidget{
  @override
    _NewAddressPageState createState() {
      return new _NewAddressPageState();
  }
}

class _NewAddressPageState extends State<NewAddressPage>{
  final products = [ 0 ];
  final _formKey = GlobalKey<FormState>();
  final HttpAddressService _httpAddressService = HttpAddressService();
  var _loading = false;
  var controllerName = new TextEditingController();
  var controllerCP = new TextEditingController();
  var controllerState = new TextEditingController();
  var controllerCity = new TextEditingController();
  var controllerColony = new TextEditingController();
  var controllerStreet = new TextEditingController();
  var controllerExtNum = new TextEditingController();
  var controllerIntNum = new TextEditingController();
  var controllerRef = new TextEditingController();
  var controllerContactNumber = new TextEditingController();
  var controllerCountry = new TextEditingController();
  
  @override
  void initState() {
      super.initState();
      _loading = false;
  }
  
  submitSuccess(value, client){
    if(value['statusOperation'].toString() != null &&  value['statusOperation']['code'].toString() == '0'){
      
      client.setNewAddressClient(value["data"]["address"]);
      const title = Text("Registro Exitoso");
      const body = [
        Text("Ya puedes utilizar la dirección ingresada.")
      ];

      CustomAlertDialog(context, title, body, 2);
    } else {
      const title = Text("Error");
      var body = [
        Text("Error al guardar la dirección, verifique la información"),
        Text(value['statusOperation']['description'].toString())
      ];
      setState(() {
        _loading = false;
      });
      CustomAlertDialog(context,title, body, 1);
    }
    //_success = true;
    
    //Navigator.of(context).pop();
  }

  submitError(onError){
    alertError(onError);
  }

  alertError(String onError){
    const title = Text("Registro de Direccion fallo");
    var body = [
      Text("Revisar información ingresada"),
      Text(onError)
    ];
    CustomAlertDialog(context,title, body, 1);
  }
  Future<Map<String, dynamic>> _onSubmit(client) async{
    if (!_formKey.currentState.validate()) {
      print('invalid');
      return null;
    }
    setState(() {
      _loading = false;
    });

    try{
      var addressBody = json.encode({
        'addressLine1': controllerStreet.text,
        'intNumber': controllerIntNum.text,
        'extNumber': controllerExtNum.text,
        'addressLine2': controllerColony.text,
        'city': controllerCity.text,
        'state': controllerState.text,
        'country': 'Mexico',
        'additionalInfo': controllerRef.text,
        'idClient': client.id,
        'idStatus': ACTIVO_ID,
        'contactNumber': controllerContactNumber.text,
        'contactName': controllerName.text
      });
      var body = jsonEncode({
        'newAddress': true,
        'address': [jsonDecode(addressBody)]
      });

      var response = _httpAddressService.processClient(body);

      response.whenComplete(() => {
        setState(() {
          _loading = false;
        })
      });
      response.then((value) {
        print('Success: ' + value.toString());
        submitSuccess(value, client);
      });
      response.catchError((onError) {
        print("Error: $onError");
        submitError(onError.toString());
        setState(() {
          _loading = false;
        });
      });
      return response;
    } on Exception catch (exception) {
      print("Exception: $exception");
      // only executed if error is of type Exception
      setState(() {
        _loading = false;
      });
      throw 'Exception';
    } catch (error) {
      print("Error: $error");
      setState(() {
        _loading = false;
      });
      throw 'Error'; // executed for errors of all types other than Exception
    }

  }
  @override
  Widget build(BuildContext context){
    final client = Provider.of<Client>(context);
    return new Scaffold(
      appBar: AppBar(
        title: Text("Nueva Direccion"),
        leading: BackButton(
          color: Colors.white,  
        ),
      ),
      body: _loading ? Loading() : FutureBuilder(
        //future: abc(),
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          //List<Widget> children = [];
          //  child: Column(children: renderRegister(),)
          //);
          return _renderForm(client);

        }
      )
    );
  }

  Widget _renderForm(client){
    return Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _renderTextForm('Nombre Y Apellido', controllerName),
                _renderTextForm('Codigo Postal',controllerCP),
                _renderTextForm('Estado', controllerState),
                _renderTextForm('Delegación / Municipio', controllerCity),
                _renderTextForm('Colonia', controllerColony),
                _renderTextForm('Calle', controllerStreet),
                _renderTextForm('Num. Ext', controllerExtNum),
                _renderTextForm('Num. Int (opcional)', controllerIntNum),
                _renderTextForm('Referencias', controllerRef),
                _renderTextForm('Número de Contacto', controllerContactNumber),

                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      _onSubmit(client);
                    },
                    child: RaisedButton(
                      child: Center(
                      child: Text("Agregar Dirección",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins-Bold",
                          fontSize: 18,
                          letterSpacing: 1.0)),
                      ),
                    )
                  ),
                ),
              ],
            ),
          )
        ),
      );
  }

  Widget _renderTextForm(hintText, controller){
    return TextFormField(
      controller: controller,
        decoration: InputDecoration(
          hintText:  hintText,
          //hintStyle: TextStyle( fontSize: 12.0),
          labelText: hintText,
        ),
        validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        } else {
          return null;
        }
      },
    );
  }
}
