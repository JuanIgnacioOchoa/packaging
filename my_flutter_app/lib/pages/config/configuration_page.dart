import 'package:flutter/material.dart';
import 'package:my_flutter_app/pages/config/user/profile_user_page.dart';
import 'package:my_flutter_app/states/user.dart';
import 'package:provider/provider.dart';
final List<String> subTitles = ['Mi cuenta', 'Cerrar Sesión'];

class ConfigurationPage extends StatelessWidget{


  optionSelected(context, index){
    switch (index){
      case 0:
        //final user = Provider.of<User>(context);
      
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserProfilePage()),
        );
        break;
      case 1: 
      /*
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MaterialApp(
              debugShowCheckedModeBanner: false,
              home: LoginPage(),
            ),
          ),
        );
      */
        final user = Provider.of<User>(context, listen: false);
        user.logoutUser(); 
        Navigator.pop(context);
        break;
      default:
        print(index.toString() + ' d');
    }
  }
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 60.0),
        child: Column(
          children: [
            //Divider(color: Colors.black),
            Expanded(
              child: Container(
                child: _showDeliveredProductsList(),
              ),
            )
          ]
        ),
      ),
    );
  }

  Widget _showDeliveredProductsList() {
    return ListView.builder(
      //padding: const EdgeInsets.all(8),
      itemCount: subTitles.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: (){
            optionSelected(context, index);
          },
          child: Container(
          
            //height: 70,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.0, color: Colors.grey)
              )//Border.all(width: 2.0, color: Colors.black)
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(subTitles[index])
            ),
            
          ),
        );
      }
    );
  } 
}
