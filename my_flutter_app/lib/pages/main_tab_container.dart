import 'package:flutter/material.dart';
import 'package:my_flutter_app/pages/home_page.dart';
import 'package:my_flutter_app/states/user.dart';
import 'package:provider/provider.dart';

import 'config/configuration_page.dart';

class  TabViewContainer extends StatelessWidget{
  Widget build(BuildContext context) {
    
    //print(user);
    return new Scaffold(
      body: DefaultTabController(
        length: 4,
        child: new Scaffold(
          body: TabBarView(
            children: [
              HomePage(),
              new Container(
                child: Text('On Construction'),
              ),
              new Container(                
                child: Text('On Construction'),
              ),
              new Container(
                child: ConfigurationPage()
              ),
            ],
          ),
          backgroundColor: Colors.blue,
          bottomNavigationBar: new TabBar(
            tabs: [
              Tab(
                icon: new Icon(Icons.home),
              ),
              Tab(
                icon: new Icon(Icons.rss_feed),
              ),
              Tab(
                icon: new Icon(Icons.perm_identity),
              ),
              Tab(icon: new Icon(Icons.settings),)
            ],
            labelColor: Colors.black,
            unselectedLabelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Colors.black,
          ),
        ),
      ),
      
    );
  }
}