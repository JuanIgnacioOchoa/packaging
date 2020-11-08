import 'package:flutter/material.dart';

const inputsIdArray = ['username', 'password', 'password_2','name', 'lastname', 'mothermaidenname', 'email', 'phone'];
List<String> inputsLabelArray = ['Usuario', 'Contraseña', 'Confirmar Contraseña', 'Nombre', 'Apellido P.', 'Apellido M.', 'Correo', 'Teléfono'];
List<TextEditingController> controllers = initailizeControllers();

initailizeControllers() {
  List<TextEditingController> result = [
    new TextEditingController(),
    new TextEditingController(),
    new TextEditingController(),
    new TextEditingController(),
    new TextEditingController(),
    new TextEditingController(),
    new TextEditingController(),
    new TextEditingController(),
  ];
    
  return result;
}

typedef void StringCallback(List<String> id, List<TextEditingController> controllers);

class RegisterForm extends StatelessWidget {
  final StringCallback callback;
  RegisterForm({this.callback});
  onChange(value){
    Map values = Map<String, String>();
    for(var i = 0; i < inputsIdArray.length; i++){
      values[inputsIdArray[i]] = controllers[i].text;
    }
    callback(inputsIdArray, controllers);
  }
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        child: Column(
          children: [ Column(
            children: getInputs(),
          ),
          ],
        ),
      ),
    );
  }

  List<Widget> getInputs(){

    List <Widget> cells = List<Widget>();
    for(var i = 0; i < inputsIdArray.length; i++){
      cells.add(
        Row(
          children: [
            Container(
              width: 100,
              child: Text(inputsLabelArray[i]),
            ),
            Expanded(
              child: TextFormField(
                obscureText: (i == 1 || i == 2 ? true : false),
                controller: controllers[i],
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Campo obligatorio';
                  } else if(value.length <= 3){
                    return 'Los valores tienen que ser mayores a 3 caracteres';
                  } else {
                    switch(i){
                      case 1: //passord
                      case 2: //confirm password
                        if(controllers[1].text != controllers[2].text)
                        //return null;
                        return 'Las contraseñas no coinciden';
                        break;
                      case 6:
                        var isEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(controllers[6].text);
                        
                        if(!isEmail){
                          return 'El campo debe ser correo';
                        }
                        break;
                      default:
                        return null;
                    }
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: inputsLabelArray[i],
                  hintStyle: TextStyle( fontSize: 12.0)
                ),
                onChanged: onChange,   
              ),
            ),
          ],
        ),
      );
    }
    return cells;
  }
}