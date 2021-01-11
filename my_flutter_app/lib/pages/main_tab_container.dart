import 'package:flutter/material.dart';
import 'package:top_express/constants.dart';
import 'package:top_express/pages/home_page.dart';
import 'package:top_express/pages/info/info_page.dart';
import 'package:top_express/pages/notification/notification_page.dart';

import 'config/configuration_page.dart';

class  TabViewContainer extends StatelessWidget{
  Widget build(BuildContext context) {
    
    //print(user);
    return new Scaffold(
      body: DefaultTabController(
        //length: 4,
        length: 3,
        child: new Scaffold(
          body: TabBarView(
            children: [
              HomePage(),
              //NotificationPage(),
              InfoPage(),
              ConfigurationPage(),
            ],
          ),
          backgroundColor: DARK_GREEN,
          bottomNavigationBar: new TabBar(
            tabs: [
              Tab(
                icon: new Icon(Icons.home),
              ),/*
              Tab(
                icon: new Icon(Icons.notifications_none),
              ),*/
              Tab(
                icon: new Icon(Icons.info_outline),
              ),
              Tab(icon: new Icon(Icons.more_horiz),)
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