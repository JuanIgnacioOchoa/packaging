import 'package:flutter/material.dart';
import 'package:my_flutter_app/states/address.dart';
import 'package:my_flutter_app/states/package.dart';

class Client with ChangeNotifier{
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
  List<Package> packagesActive = [];
  List<Package> packagesDelivered = [];
  Client();

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
  void setData(client){
    id = client['id'];
    username = client['username'];
    name = client['name'];
    lastname = client['lastname'];
    email = client['email'];
    motherMaidenName = client['mothermaidenname'];
    phone = client['phone'];
    idStatus = client['id_status'];
    fullname = "$name $lastname $motherMaidenName";
    List<dynamic> addressesTmp = client['address'];
    for(var i = 0; i < addressesTmp.length; i++){
      Address tmp = Address(addressesTmp[i]);
      addresses.add(tmp);
    }
  }

  void setNewPackage(activeJson, deliveredJson){
    List<dynamic> packageTmpActive = activeJson;
    List<dynamic> packageTmpDelivered = deliveredJson;
    for(var i = 0; i < packageTmpActive.length; i++){
      Package tmp = Package(packageTmpActive[i]);
      packagesActive.add(tmp);
    }
    for(var i = 0; i < packageTmpDelivered.length; i++){
      Package tmp = Package(packageTmpDelivered[i]);
      packagesDelivered.add(tmp);
    }
    notifyListeners();
  }

  void logoutClient(){
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