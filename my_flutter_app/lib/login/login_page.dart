import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:top_express/api/clients/index.dart';
import 'package:top_express/common/alert_dialog.dart';
import 'package:top_express/common/loading.dart';
import 'package:top_express/constants.dart';
import 'package:top_express/login/LoginForm.dart';
import 'package:top_express/login/register/register_page.dart';
import 'package:top_express/pages/main_tab_container.dart';
import 'package:top_express/states/client.dart';
import 'package:provider/provider.dart';
import 'package:top_express/utils/database.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Map<String, String> newClient = {};
  Future _clientFuture;
  final HttpClientService _httpClientService = HttpClientService();
  bool _isSelected = false;
  String _username = '';
  String _password = '';
  bool _loading;
    @override
  void initState() {
      super.initState();
      _loading = false;
      _clientFuture = getClient();
  }
  void _radio() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  getClient() async {
    final _clientData = await DBProvider.db.getClient();
    if(_clientData != null){
        _username = _clientData['username'];
        _password = _clientData['password'];
        try {
          var response = await onSubmit();
        if(!(response['statusOperation'].toString() != null &&  response['statusOperation']['code'].toString() == '0')){
          DBProvider.db.deleteClient();
        }
      } catch (error){
        //Usuario esta guardado pero no hay conexxion a internet
        loginError('No existe conexion con el servidor');
      }
    }
    return _clientData;
  }

  login(value){
    if(value['statusOperation'].toString() != null &&  value['statusOperation']['code'].toString() == '0'){
      setState(() {
        _loading = false;
      });
      var clientJson = value['data']['clients'][0];
      if(clientJson["id_status"].toString() == PENDING_CONFIRMATION_ID.toString() ){
        const title = Text("Usuario no confirmado");
        const body = [
          Text("Se envio un correo de confirmacion, favor de confirmar el usuario mediante el correo")
        ];
        CustomAlertDialog(this.context,title, body, 1);
      } else {
        final client = Provider.of<Client>(this.context, listen: false);
        client.setData(clientJson); 
        client.setPassword(_password); 
        if(_isSelected){
          DBProvider.db.newClient(client);
        }
        _username = '';
        _password = '';
        Navigator.push(
          this.context, 
          MaterialPageRoute(builder: (context) => TabViewContainer()),
        );
      }

    } else {
      const title = Text("Error de Ingreso");
      const body = [
        Text("Usuario y/o Contraseña incorrecto")
      ];
      setState(() {
        _loading = false;
      });
      CustomAlertDialog(context,title, body, 1);
    }
  }

  loginError(onError){
    const title = Text("Error de Conexion");
    var body = [
      Text("Error al intentar conectarse con el servidor"),
      Text(onError.toString()),
    ];
    setState(() {
      _loading = false;
    });
    CustomAlertDialog(context,title, body, 1);
  }

  register(){
    Navigator.push(
      this.context,
      MaterialPageRoute(
        builder: (context) => RegisterPage(),
      ),
    );
  }

Future<Map<String, dynamic>> onSubmit() async{  
    if(_username == 'juanalvaro' && _password == 'infinito'){
      const title = Text("TE AMO!!!");
      const body = [
        Text("Quiero que sepas que eres la mujer que mas admiro y mas aprecio."),
        Text("Me implusas a ser mejor persona"),
        Text("Me apoyas incondicionalmente"),
        Text("Te preocupas por mi"),
        Text("Me ensenaste el valor de uno mismo"),
        Text("Eres super hermosa"),
        Text("Me emociona estar contigo"),
        Text("Quiero estar contigo hasta el final"),
        Text("Me emociona un futuro contigo"),
        Text("Amo la pasion que das"),
        Text("Amo el cariño que das"),
        Text("Amo tu manera de amar"),
        Text("Amo lo que hemos crecido juntos"),
        Text("Te amo un monton"),
        Text("Estas son unas de las razones que tengo para amarte"),
        Text("Obvio hay mas pero no hay tiempo ni espacio para decirtelas, solo una vida"),
        Text("Que me ilusiona la idea de que tal vez la tenga para decirtelas"),
        Text("Tenia la idea de hacer algo mas bonito para decirte esto, pero no tuve el tiempo"),
        Text("Pero la idea esta, y cuando yo la tengo nada me detiene para hacerlo."),
        Text("Cuando se presente la oportunidad lo hare"),
        Text("Pero he andado full en chamba y mas en ayudarte a cumplir una meta"),
        Text("Se que la vida no es perfecta y que ni tu ni yo lo somos."),
        Text("Pero quiero aprender y mejorar y lo quiero hacer contigo, si me dejas"),
        Text("Espero estar el uno con el otro por mucho tiempo mas, aunque peleemos y nos enojemos"),
        Text("de eso se trata tambien pero al final que la alegria y el amor sea mayor"),
        Text("Te amo mucho"),
        Text("Te quiero preguntar una cosa"),
        Text("Te quieres ca...."),
        Text("Me harias el hombre mas feliz si dices que si"),
        Text("Quieres ser mi novia?"),
      ];
      CustomAlertDialog(context,title, body, 1);
      return null;
    }
    setState(() {
      _loading = true;
    });
    try{
      var body = jsonEncode({"username": _username, "password": _password});
      var response = await _httpClientService.loginClient( body );
      login(response);
      return response;
    } on Exception catch (exception) {
      // only executed if error is of type Exception
      //loginError(exception);
      print('Error: ' + exception.toString());
      throw 'Exception';
    } catch (error) {
      //loginError(error);
      print('Error: ' + error.toString());
      throw 'Error'; // executed for errors of all types other than Exception
    }
    
  }

  onChangeUsername(data){
    _username = data;
  }

  onChangePassword(data){
    _password = data; 
  }

  Widget radioButton(bool isSelected) => Container(
        width: 16.0,
        height: 16.0,
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2.0, color: Colors.black)),
        child: isSelected
            ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.black),
              )
            : Container(),
      );

  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: ScreenUtil().setWidth(120),
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: true);
    return new Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: _loading ? Loading() : 
      FutureBuilder(  
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          return renderLogin();
        }
      )
    );
  }

  Widget renderBackground(){
    return Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 100.0),
                child: Image.asset(
                  "assets/images/topexpress_logo_title.png",
                  width: ScreenUtil().setWidth(600),
                ),
              ),
              Container(
                //padding: EdgeInsets.only(top: 150.0),
                child: Image.asset(
                  "assets/images/topexpress_logo.png",
                ),
              ),
              
            ],
          );
  }

  Widget renderLoading(){
    return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          renderBackground()
        ],
      );
  }
  

  Widget renderLogin(){
    return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          renderBackground(),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 0.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 150),
                    child: LoginForm(
                      callbackUsernameChange: (val) => { this.onChangeUsername(val)},
                      callbackPasswordChange: (val) => { this.onChangePassword(val)},
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(color: Colors.transparent),
                        child: Row(
                        children: <Widget>[
                          
                          SizedBox(width: 12.0,),
                          GestureDetector(
                            onTap: _radio,
                            child: radioButton(_isSelected),
                          ),
                          SizedBox(width: 8.0,),
                          
                          Text("Remember me",
                              style: TextStyle(
                                  fontSize: 12, fontFamily: "Poppins-Medium", color: Colors.black))
                          
                        ],
                      )
                      ),
                      InkWell(
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
                              onTap: () async {
                                try {
                                  await onSubmit();
                                } catch (e) {
                                  loginError(e);
                                }
                              },
                              child: RaisedButton(
                                child: Center(
                                child: Text("SIGNIN",
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
                    ],
                  ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(40),),
                  SizedBox(height: ScreenUtil().setHeight(30),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "New User? ",
                        style: TextStyle(fontFamily: "Poppins-Medium"),
                      ),
                      InkWell(
                        onTap: () { register(); },
                        child: Text("SignUp",
                            style: TextStyle(
                                color: Color(0xFF5d74e3),
                                fontFamily: "Poppins-Bold")),
                      )
                    ],
                  )
                ],
              ),
            ),
          )       
  
        ],
      );
    
  }

}