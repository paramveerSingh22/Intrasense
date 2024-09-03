import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/view/Home/HomeScreen.dart';
import 'package:intrasense/view_models/user_view_model.dart';

import '../../model/user_model.dart';
import '../Login/LoginScreen.dart';

class SplashService {

  Future<UserModel> getUserData() => UserViewModel().getUser();

  void checkAuthentication(BuildContext context) async {
    getUserData().then((value) {
      if (value.token == null || value.token == '') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
      else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }).onError((error, StackTrace) {
      if (kDebugMode) {
        print(error);
      }
    });
  }
}