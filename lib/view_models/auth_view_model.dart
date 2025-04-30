import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/repository/auth_repository.dart';
import 'package:intrasense/utils/Utils.dart';
import 'package:intrasense/view_models/user_view_model.dart';

import '../model/user_model.dart';
import '../view/Home/HomeScreen.dart';
import '../view/Login/OtpScreen.dart';


class AuthViewModel with ChangeNotifier {
  final _myRepo = AuthRepository();
  final UserViewModel userViewModel = UserViewModel();
  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> loginApi(dynamic data, BuildContext context) async {
    setLoading(true);
    print("Api params---$data");
    _myRepo.loginApi(data,context).then((onValue) {
      setLoading(false);
      if (kDebugMode) {
        print("Api Response---$onValue");
      }
      UserModel userModel=UserModel.fromJson(onValue);
      userViewModel.saveUser(userModel);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => const HomeScreen()),(Route<dynamic> route) => false,);


    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(error.toString());
      }
      Utils.errorMessage(error);
    });
  }

  /*Future<void> forgotPasswordApi(dynamic data, BuildContext context) async {
    setLoading(true);
    _myRepo.forgotPasswordApi(data).then((onValue) {
      setLoading(false);
      if (kDebugMode) {
        print(onValue.toString());
      }
      Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen()));
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(error.toString());
      }
      Utils.toastMessage(error.toString());
    });
  }
*/

  Future<dynamic> forgotPasswordApi(dynamic data,BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    try {
      var response = await _myRepo.forgotPasswordApi(data,context);
      setLoading(false);
        return response;
    } catch (error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print("Error occurred: $error");
      }
      Utils.toastMessage(Utils().extractErrorMessage(error.toString()));

      return null;
    }
  }

  Future<dynamic> forgotPasswordVerifyOtpApi(dynamic data,BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    try {
      var response = await _myRepo.forgotPasswordVerifyOtpApi(data,context);
      setLoading(false);
        return response;

    } catch (error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print("Error occurred: $error");
      }
      Utils.toastMessage(Utils().extractErrorMessage(error.toString()));
      return null;
    }
  }

  Future<dynamic> forgotNewPasswordApi(dynamic data,BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    try {
      var response = await _myRepo.forgotNewPasswordApi(data,context);
      setLoading(false);
      return response;

    } catch (error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print("Error occurred: $error");
      }
     // Utils.toastMessage(error.toString());
      Utils.toastMessage(Utils().extractErrorMessage(error.toString()));
      return null;
    }
  }
}
