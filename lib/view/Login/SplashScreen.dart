import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/utils/Images.dart';
import 'package:intrasense/utils/routes/routes.dart';
import 'package:intrasense/utils/routes/routes_name.dart';
import 'package:intrasense/view/service/SplashService.dart';

import 'LoginScreen.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  _SplashScreenState  createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen>{

  SplashService splashService= SplashService();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      splashService.checkAuthentication(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Container(
            color: Colors.white, // Set background color to white
            padding: const EdgeInsets.all(10.0), // Set 10dp padding from all sides
            child: Center(
              child: Image.asset(
                Images.splashScreen,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );

  }
}