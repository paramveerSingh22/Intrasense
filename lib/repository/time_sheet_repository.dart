import 'package:flutter/cupertino.dart';

import '../data/network/BaseApiService.dart';
import '../data/network/NetworkApiService.dart';
import '../data/network/app_url.dart';

class TimeSheetRepository{
  BaseApiService apiService = NetworkApiService();

  Future <dynamic> getTimeSheetActivityApi(dynamic data,BuildContext context) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.timeSheetActivityUrl, data,context);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> addTimeSheetApi(dynamic data,BuildContext context) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.addTimeSheetUrl, data,context);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> getTimeSheetListApi(dynamic data,BuildContext context) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.timeSheetListUrl, data,context);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

}