import 'package:flutter/material.dart';
import 'package:my_flutter_app/login/login_page.dart';
import 'package:my_flutter_app/states/user.dart';
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
      ChangeNotifierProvider(create: (_) => User()),
    ],
    child: MaterialApp(
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
      ),
    )
  );