

class Proveedor {// with ChangeNotifier{
  int id;
  String name;

  Proveedor(json){
    print('Proveedor xsd: $json');
    id = json["id"];
    name = json['name'];
  }

  setName(name){
    name = name;
  }
}