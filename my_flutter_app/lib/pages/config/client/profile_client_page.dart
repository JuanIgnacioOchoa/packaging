import 'package:flutter/material.dart';
import 'package:my_flutter_app/states/address.dart';
import 'package:my_flutter_app/states/client.dart';
import 'package:provider/provider.dart';
import 'new_address_page.dart';

final List<String> subTitles = ['Direcciones', 'Opcion 1', 'Opcion 2', 'Opcion 3', 'Opcion 4'];

class ClientProfilePage extends StatelessWidget{


  @override
  Widget build(BuildContext context){
    final client = Provider.of<Client>(context);
    print(client);
    return new Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
        leading: BackButton(
          color: Colors.white,  
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(bottom: 40, left: 10, right: 10),
              child: Column(
                children: [
                  _renderTitle("Datos del Usuario"),
                  _renderValue("Nombre", client.fullname ?? "N/A"),
                  _renderValue("Email", client.email ?? "N/A"),
                  _renderValue("Phone", client.phone ?? "N/A"),

                  _renderTitle("Direcciones"),
                  for(var item in client.addresses) _renderAddress(item),
                  _renderAddAddressButton(context),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _renderAddress(item){
    //return _renderValue('title', 'subtitle');
    Address address = item;
    return Padding(
      padding: EdgeInsets.only(top: 5),
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white
        ),
        //padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
        child: Padding(
          padding: EdgeInsets.only(top: 10, left: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${address.addressLine1} ${address.extNumber}',
                style: TextStyle(
                  color: Colors.black,
                  //fontWeight: FontWeight.bold,
                  fontSize: 16
                )
              ),
              Padding(
                padding: EdgeInsets.only(top: 3),
                child: Text(
                  '${address.intNumber ?? ''} - ${address.addressLine2} - ${address.city} - ${address.state} - ${address.contactName} - ${address.contactNumber}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                  style: TextStyle(
                    color: Colors.grey,
                    //fontWeight: FontWeight.bold,
                    fontSize: 14
                  )
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

  Widget _renderAddAddressButton(context){
    return  
    Padding(
      padding: EdgeInsets.only(top: 10),
      child: InkWell(
        onTap: () { 
          _newAddress(context); 
        },
        child: Text("Agregar Dirección",
          style: TextStyle(
            color: Color(0xFF5d74e3),
            //fontFamily: "Poppins-Bold")
          ),
        )
      )
    );
  }
  Widget _renderTitle(title){
    return Padding(
      padding: EdgeInsets.only( top: 10, bottom: 5),
      child: Container(
        width: double.infinity,
        //height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.transparent
        ),
        //padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
        child: Text(
          title, 
          style: TextStyle(
            color: Colors.black,
            //fontWeight: FontWeight.bold,
            fontSize: 16
          ))
      ),
    );
  }
  Widget _renderValue(title, subtitle){
    return Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white
                      ),
                      //padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                      child: Padding(
                        padding: EdgeInsets.only(top: 10, left: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                color: Colors.black,
                                //fontWeight: FontWeight.bold,
                                fontSize: 16
                              )
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 3),
                              child: Text(
                                subtitle,
                                style: TextStyle(
                                  color: Colors.grey,
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 14
                                )
                              ),
                            ),
                          ],
                        ),
                      )
                    ),
                  );
  }
  _newAddress(context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewAddressPage()),
    );
  }
}
