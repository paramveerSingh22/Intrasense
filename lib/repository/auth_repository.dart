import 'package:flutter/cupertino.dart';
import 'package:intrasense/data/network/BaseApiService.dart';
import 'package:intrasense/data/network/NetworkApiService.dart';
import 'package:intrasense/data/network/app_url.dart';

class AuthRepository {
  BaseApiService apiService = NetworkApiService();

  Future <dynamic> loginApi(dynamic data, BuildContext context) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.loginUrl, data,context);

      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> forgotPasswordApi(dynamic data,BuildContext context) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.forgotPasswordUrl, data,context);

      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> forgotPasswordVerifyOtpApi(dynamic data,BuildContext context) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.forgotPasswordVerifyOtpUrl, data,context);

      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> forgotNewPasswordApi(dynamic data,BuildContext context) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.forgotNewPasswordUrl, data,context);

      return response;
    }
    catch (e) {
      throw e;
    }
  }
}