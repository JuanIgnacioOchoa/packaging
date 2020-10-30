import 'package:flutter/material.dart';
import 'package:my_flutter_app/states/address.dart';

class User with ChangeNotifier{
  int id;
  String username;
  String name;
  String lastname;
  String email;
  String motherMaidenName;
  String phone;
  int idStatus;
  List<Address> addresses = [];
  String fullname;

  User();

  String toString(){
    return "{id: $id, username: $username, name: $name, lastname: $lastname, email: $email, motherMaidenName: $motherMaidenName, phone: $phone, idStatus: $idStatus, fullName: $fullname}";
  }

  void setNewAddress(json){
    //print("New Address $json");
    List<dynamic> addressesTmp = json;
    for(var i = 0; i < addressesTmp.length; i++){
      Address tmp = Address(addressesTmp[i]);
      addresses.add(tmp);
    }
    notifyListeners();
  }
  void setData(json){
    var user = json['users'][0];
    id = user['id'];
    username = user['username'];
    name = user['name'];
    lastname = user['lastname'];
    email = user['email'];
    motherMaidenName = user['mothermaidenname'];
    phone = user['phone'];
    idStatus = user['id_status'];
    fullname = "$name $lastname $motherMaidenName";
    List<dynamic> addressesTmp = user['address'];
    for(var i = 0; i < addressesTmp.length; i++){
      Address tmp = Address(addressesTmp[i]);
      addresses.add(tmp);
    }
  }

  void logoutUser(){
    id = null;
    username = null;
    name = null;
    lastname = null;
    email = null;
    motherMaidenName = null;
    phone = null;
    idStatus = null;
    fullname = null;
    addresses = [];

    notifyListeners();
    
  }
}