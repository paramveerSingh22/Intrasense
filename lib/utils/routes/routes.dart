import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/utils/routes/routes_name.dart';
import 'package:intrasense/view/Home/HomeScreen.dart';
import 'package:intrasense/view/Login/LoginScreen.dart';

class Routes{
  static Route<dynamic> generateRoute(RouteSettings settings){

    switch (settings.name){
      case RoutesName.login:
        return MaterialPageRoute(builder: (BuildContext context)=> const LoginScreen());

      case RoutesName.home:
        return MaterialPageRoute(builder: (BuildContext context)=> const HomeScreen());
      default:
        return MaterialPageRoute(builder: (_){
          return Scaffold(
            body: Center(
              child: Text('No rout defined'),
            ),
          );
        });
    }
  }
}