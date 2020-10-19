import 'package:flutter/material.dart';

class Address {
  int id;
  String addressLine1;
  String intNumber;
  String extNumber;
  String addressLine2;
  String city;
  String state;
  String country;
  String additionalInfo;
  int idStatus;
  String contactName;
  String contactNumber;

  Address(json){
    id = json['id'];
    addressLine1 = json['address_line_1'];
    intNumber = json['int_number'];
    extNumber = json['ext_number'];
    addressLine2 = json['address_line_2'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    additionalInfo = json['additional_info'];
    idStatus = json['id_status'];
    contactName = json['contact_name'];
    contactNumber = json['contact_number'];
    //var address = json['users'][0];
    /*
    id = user['id'];
    username = user['username'];
    name = user['name'];
    lastname = user['lastname'];
    email = user['email'];
    motherMaidenName = user['mothermaidenname'];
    phone = user['phone'];
    idStatus = user['id_status'];
    */
  }


  void setData(json){
    print('setData: ');
  }
}