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
  }

  Address.localAddress(int type){
    switch(type){
      case 1:
      default:
        id = 1;
        addressLine1 = 'Recoger en Oficina';
        intNumber = '';
        extNumber = 'Torre ICON';
        addressLine2 = '';
        city = 'Guadalajara';
        state = 'Jalisco';
        country = 'Mexico';
        additionalInfo = '';
        idStatus = 0;
        contactName = '';
        contactNumber = '';
    }
  }

  void setData(json){
    print('setData: ');
  }
}