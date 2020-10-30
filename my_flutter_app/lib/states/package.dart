import 'package:flutter/material.dart';
import 'package:my_flutter_app/states/address.dart';

class Package{ // with ChangeNotifier{
  int id;
  int idSupplier;
  int idUser;
  int idAddres;
  String referenceNumber;
  String description;
  int quantity;
  String dimensions;
  double totalCost;
  double shippingCost;
  double packageCost;
  String receipt;
  DateTime created;
  DateTime updated;

  String supplierName;
  String status;

  Package(json){
    
    id = json["id"];
    idSupplier = json["id_supplier"];
    idUser = json["id_user"];
    idAddres = json['id_address'];
    referenceNumber = json['reference_number'];
    description = json['description'];
    quantity = json['quantity'];
    dimensions = json['dimensions'];
    totalCost = double.parse(json['total_cost']);
    shippingCost = double.parse(json['shipping_cost']);
    packageCost = double.parse(json['package_cost']);
    receipt = json['receipt'];
    created = DateTime.parse(json['created_timestamp']);
    updated = DateTime.parse(json['updated_timestamp']);

    supplierName = json['supplier_name'];
    status = json['status'];
  }
}