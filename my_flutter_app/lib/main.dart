import 'package:flutter/material.dart';
import 'package:my_flutter_app/constants.dart';
import 'package:my_flutter_app/login/login_page.dart';
import 'package:my_flutter_app/states/client.dart';
import 'package:provider/provider.dart';

/*
void main() => runApp(
  MaterialApp(
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
  ));
*/

void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Client()),
    ],
    child: MaterialApp(
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: LIGHT_GREEN,
        primaryColor: DARK_GREEN
      ),
    ),
  )
);