import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_express/api/clients/index.dart';
import 'package:top_express/common/alert_dialog.dart';
import 'package:top_express/common/loading.dart';
import 'package:top_express/constants.dart';
import 'package:top_express/login/register/register_form.dart';
import 'dart:convert';

class RegisterPage extends StatefulWidget{
  @override
  _RegisterPageState createState() {
    return new _RegisterPageState();
  }
}


class _RegisterPageState extends State<RegisterPage>{
  var _submitData;
  var _controllers;
  var _loading = false;
  final _formKey = GlobalKey<FormState>();
  final HttpClientService _httpClientService = HttpClientService();

  @override
  void initState() {
      super.initState();
      _loading = false;
  }
  onTextChange(inputsIdArray, controllers){
    Map values = Map<String, String>();
    for(var i = 0; i < inputsIdArray.length; i++){
      values[inputsIdArray[i]] = controllers[i].text;
    }
    _controllers = controllers;
    _submitData = values;
  }

  submitSuccess(value){
    //_success = true;
    try{
      int code = value["statusOperation"]["code"];
      
      if(code == 0){
        const title = Text("Registro Exitoso");
        const body = [
          Text("Se ha enviado un correo de activacion, porfavor revisa tu correo para activar tu cuenta")
        ];
        for(var i = 0; i < _controllers.length; i++){
          _controllers[i].text = '';
        } 
        CustomAlertDialog(context,title, body, 2);
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

  submitError(onError){
    alertError(onError);
  }
  
  alertError(String onError){
    const title = Text("Registro Fallid");
    var body = [
      Text("Revisar información ingresada"),
      Text(onError)
    ];
    CustomAlertDialog(context,title, body, 1);
  }

  Future<Map<String, dynamic>> onSubmit() async{
    //_loading = true;
    if (_formKey.currentState.validate()) {
      // If the form is valid, display a Snackbar.
      print('valid');
    } else {
      print('invalid');
      return null;
    }
    
    setState(() {
      _loading = true;
    });
    print('_submitData: ' + _submitData.toString());
    if(_submitData == null){
      setState(() {
        _loading = false;
      });
      throw '_submitDataNull';
    }
    try {
      var clientBody = json.encode({
        'username': _submitData['username'], 
        'password': _submitData['password'],
        'name': _submitData['name'],
        'lastname': _submitData['lastname'],
        'email': _submitData['email'],
        'mothermaidenname': _submitData['mothermaidenname'],
        'phone': _submitData['phone'],
        'idStatus': PENDING_CONFIRMATION_ID
      });
      print('_submitData1: 4');
      var body = jsonEncode({
        'newClient': true,
        'clients': [jsonDecode(clientBody)]
      });
      var a = _httpClientService.processClient( body );
      a.whenComplete(() => {
        setState(() {
          _loading = false;
        })
      });
      a.then((value) {
        print('value: ' + value.toString());
        submitSuccess(value);
      });
      a.catchError((onError) {
        submitError(onError.toString());
        setState(() {
          _loading = false;
        });
      });
      return a;
    } on Exception catch (exception) {
      // only executed if error is of type Exception
      setState(() {
        _loading = false;
      });
      throw 'Exception';
    } catch (error) {
      setState(() {
        _loading = false;
      });
      throw 'Error'; // executed for errors of all types other than Exception
    }
        
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: true);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: DARK_GREEN,
        title: Text("Registrar"),
        leading: BackButton(
          color: Colors.white,  
        ),
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: _loading ? Loading() : FutureBuilder(
          //future: abc(),
          builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            //List<Widget> children = [];
            //  child: Column(children: renderRegister(),)
            //);
            return renderRegister();

          }
        )
      
    );
  }


  renderRegister(){
    return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              SingleChildScrollView(
                child: Container(
                  child: Stack(
                    //fit: StackFit.expand,
                    children: [
                      
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                         child: Align(
                          alignment: Alignment.topLeft,
                          child:  Image.asset(
                            "assets/images/topexpress_logo.png",
                            width: ScreenUtil().setWidth(200),
                            height: ScreenUtil().setHeight(200),
                          ),
                        )
                      ),
                      
                      Padding(
                        padding: EdgeInsets.only( top: 110, bottom: 140, left: 20, right: 20),
                        //child: Visibility(
                        //  visible: !_loading,
                          child: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: RegisterForm(
                                callback: (id, controller) => { this.onTextChange(id, controller)},
                              ),
                            )
                          ),
                        //)
                      ),
                      
                    ]
                  )
                )
              ), 
              Padding(
                padding: EdgeInsets.only( bottom: 26.0 ),
                //child: Visibility(
                //  visible: !_loading,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: ScreenUtil().setWidth(330),
                      height: ScreenUtil().setHeight(100),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            LIGHT_GREEN,
                            DARK_GREEN
                          ]),
                          borderRadius: BorderRadius.circular(6.0),
                          boxShadow: [
                            BoxShadow(
                                color: Color(0xFF6078ea).withOpacity(.3),
                                offset: Offset(0.0, 8.0),
                                blurRadius: 8.0)
                          ]),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            onSubmit();
                          },
                          child: RaisedButton(
                            child: Center(
                            child: Text("Registrar",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins-Bold",
                                fontSize: 18,
                                letterSpacing: 1.0)),
                            ),
                          )
                        ),
                      ),
                      
                    ),
                  )
                //)
              )
              //renderLogin(),
              //render(),
            ],
          );
  }

}