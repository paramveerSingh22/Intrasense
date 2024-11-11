import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/data/app_exceptions.dart';
import 'package:intrasense/data/network/BaseApiService.dart';
import 'package:http/http.dart' as http;
import 'package:intrasense/utils/Utils.dart';
import 'package:intrasense/view/Login/LoginScreen.dart';

import '../../model/user_model.dart';
import '../../view_models/user_view_model.dart';

class NetworkApiService extends BaseApiService {

  var token;

  @override
  Future getGetApiResponse(String url, BuildContext context) async {
    dynamic responseJson;
    try {
      final response =
          await http.get(
            Uri.parse(url),
              headers: {
                'Authorization': 'Bearer $token',
              }
          ).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response,context);

      if (kDebugMode) {
        print('Api Request URL: ${response.request?.url}');
        print('Api Status Code: ${response.statusCode}');
        print('Api Response Body: ${response.body}');
      }
    } on SocketException {
      throw FetchDataException('No internet connection');
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic data, BuildContext context) async {
    dynamic responseJson;
    try {
        http.Response response = await http.post(
          Uri.parse(url),
          body: data,
          headers: {
            'Authorization': 'Bearer $token',
          },
        ).timeout(const Duration(seconds: 10));
        responseJson = returnResponse(response, context);

      if (kDebugMode) {
        print('Api Request URL: $url');
        print('Api Response Body: $responseJson');
      }
    } on SocketException {
      throw FetchDataException('No internet connection');
    }

    return responseJson;




    /*try {

      http.Response response = await http
          .post(Uri.parse(url), body: data, headers: {
        'Authorization': 'Bearer $token',
      }).timeout(Duration(seconds: 10));
      responseJson = returnResponse(response, context);
      if (kDebugMode) {
        print('Api Request URL: ${response.request?.url}');
        print('Api Status Code: ${response.statusCode}');
        print('Api Response Body: ${response.body}');
      }

    } on SocketException {
      throw FetchDataException('No internet connection');
    }
    return responseJson;*/
  }

  @override
  Future getPostWithFileApiResponse(String url, dynamic data, BuildContext context, String? filePath) async {
    dynamic responseJson;

    try {
      if (filePath != null && filePath.isNotEmpty) {
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.headers['Authorization'] = 'Bearer $token';

        // Add form fields from data map
        data.forEach((key, value) {
          request.fields[key] = value.toString();
        });

        // Add file to the request
        request.files.add(await http.MultipartFile.fromPath('file', filePath));

        // Send the request and capture the response
        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        responseJson = returnResponse(response, context);
      } else {
        http.Response response = await http.post(
          Uri.parse(url),
          body: data,
          headers: {
            'Authorization': 'Bearer $token',
          },
        ).timeout(const Duration(seconds: 10));

        responseJson = returnResponse(response, context);
      }

      if (kDebugMode) {
        print('Api Request URL: $url');
        print('Api Response Body: $responseJson');
      }
    } on SocketException {
      throw FetchDataException('No internet connection');
    }

    return responseJson;

    /*try {

      http.Response response = await http
          .post(Uri.parse(url), body: data, headers: {
        'Authorization': 'Bearer $token',
      }).timeout(Duration(seconds: 10));
      responseJson = returnResponse(response, context);
      if (kDebugMode) {
        print('Api Request URL: ${response.request?.url}');
        print('Api Status Code: ${response.statusCode}');
        print('Api Response Body: ${response.body}');
      }

    } on SocketException {
      throw FetchDataException('No internet connection');
    }
    return responseJson;*/
  }

  dynamic returnResponse(http.Response response, BuildContext context) {
    switch (response.statusCode) {

      case 201:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;

      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;

      case 400:
        throw BadRequestException(response.body.toString());

      case 401:
      Utils.toastMessage("Session expired. Please log in again.");
      UserViewModel().remove();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => LoginScreen()),(Route<dynamic> route) => false,);
        return null;

      case 500:
        throw FetchDataException(
            'internal server error ${response.statusCode}');
        
      case 404:
        throw UnAuthorisedException(response.body.toString());

      default:
       // throw FetchDataException('Error accured while communicating with server with status code ${response.statusCode}');
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
