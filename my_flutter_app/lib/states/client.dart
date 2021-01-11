import 'package:flutter/material.dart';
import 'package:top_express/states/address.dart';
import 'package:top_express/states/package.dart';

class Client with ChangeNotifier{
  int id;
  String username;
  String password;
  String name;
  String lastname;
  String email;
  String motherMaidenName;
  String phone;
  int idStatus;
  List<Address> addressesClient = [];
  List<Address> addressesGlobal = [];
  String fullname;
  List<Package> packagesActive = null;
  List<Package> packagesDelivered = null;
  Client();

  String toString(){
    return "{id: $id, username: $username, name: $name, lastname: $lastname, email: $email, motherMaidenName: $motherMaidenName, phone: $phone, idStatus: $idStatus, fullName: $fullname}";
  }

  void setNewAddressClient(json){
    List<dynamic> addressesTmp = json;
    for(var i = 0; i < addressesTmp.length; i++){
      Address tmp = Address(addressesTmp[i]);
      addressesClient.add(tmp);
    }
    notifyListeners();
  }

    void setNewAddressGlobal(json){
    List<dynamic> addressesTmp = json;
    for(var i = 0; i < addressesTmp.length; i++){
      Address tmp = Address(addressesTmp[i]);
      addressesGlobal.add(tmp);
    }
    notifyListeners();
  }

  void setPassword(_password){
    password = _password;
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
    List<dynamic> addressesTmp = client['addressClient'];
    for(var i = 0; i < addressesTmp.length; i++){
      Address tmp = Address(addressesTmp[i]);
      addressesClient.add(tmp);
    }
    addressesTmp = client['addressGlobal'];
    for(var i = 0; i < addressesTmp.length; i++){
      Address tmp = Address(addressesTmp[i]);
      addressesGlobal.add(tmp);
    }
  }

  void setNewPackage(activeJson, deliveredJson){
    List<dynamic> packageTmpActive =  activeJson;
    List<dynamic> packageTmpDelivered = deliveredJson;
    packagesActive = [];
    packagesDelivered = [];
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
    addressesGlobal = [];
    addressesClient = [];

    notifyListeners();
    
  }
}