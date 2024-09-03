import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intrasense/data/app_exceptions.dart';
import 'package:intrasense/data/network/BaseApiService.dart';
import 'package:http/http.dart' as http;

import '../../model/user_model.dart';
import '../../view_models/user_view_model.dart';

class NetworkApiService extends BaseApiService {

  var token;

  @override
  Future getGetApiResponse(String url) async {
    dynamic responseJson;
    try {
      final response =
          await http.get(
            Uri.parse(url),
              headers: {
                'Authorization': 'Bearer $token',
              }
          ).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);

      if (kDebugMode) {
        print('Request URL: ${response.request?.url}');
        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } on SocketException {
      throw FetchDataException('No internet connection');
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      http.Response response = await http
          .post(Uri.parse(url), body: data, headers: {
        'Authorization': 'Bearer $token',
      })
          .timeout(Duration(seconds: 10));
      responseJson = returnResponse(response);
      if (kDebugMode) {
        print('Request URL: ${response.request?.url}');
        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }

    } on SocketException {
      throw FetchDataException('No internet connection');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;

      case 400:
        throw BadRequestException(response.body.toString());

      case 500:
        
      case 404:
        throw UnAuthorisedException(response.body.toString());

      default:
        throw FetchDataException(
            'Error accured while communicating with server with status code ${response.statusCode}');
    }
  }


  Future<UserModel> getUserData() => UserViewModel().getUser();
  void checkAuthentication(BuildContext context) async {
    getUserData().then((value) {
      if (value.token == null || value.token == '') {
        token = '';
      }
      else {
        token = value.token;
      }
    }).onError((error, StackTrace) {
      if (kDebugMode) {
        print(error);
      }
    });
  }
}
