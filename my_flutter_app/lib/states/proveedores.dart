import 'package:flutter/material.dart';
import 'package:top_express/states/proveedor.dart';

class Proveedores with ChangeNotifier{
  List<Proveedor> proveedores;

  Proveedores(){
    proveedores = [];
  }

  add(json){
    var tmp = proveedores;
    print('------------ $tmp');
    tmp.add(Proveedor(json));
    proveedores = [];
    proveedores = tmp;
    notifyListeners();
  }

  List<Proveedor> getList(){
    return proveedores;
  }
}