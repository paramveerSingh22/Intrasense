import 'package:flutter/cupertino.dart';

import '../data/network/BaseApiService.dart';
import '../data/network/NetworkApiService.dart';
import '../data/network/app_url.dart';

class AppraisalRepository{
  BaseApiService apiService = NetworkApiService();

  Future <dynamic> getAppraisalListApi(dynamic data,BuildContext context) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.appraisalListUrl, data,context);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> getAppraisalDetailApi(dynamic data,BuildContext context) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.appraisalDetailUrl, data,context);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> getAppraisalRequestListApi(dynamic data,BuildContext context) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.appraisalRequestListUrl, data,context);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

}