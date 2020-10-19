import 'package:flutter/material.dart';

Future<void> CustomAlertDialog(context, title, texts, acceptType) async {
  accept(){
    for(var i = 0; i < acceptType; i++){
      Navigator.of(context).pop();
    }
  }
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: title,
        content: SingleChildScrollView(
          child: ListBody(
            children: texts,
          ),
        ),
        actions: <Widget>[
          RaisedButton(
            child: Text('Aceptar'),
            onPressed: accept,
          ),
        ],
      );
    },
  );
}