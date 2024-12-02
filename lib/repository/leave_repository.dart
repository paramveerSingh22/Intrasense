import 'package:flutter/cupertino.dart';

import '../data/network/BaseApiService.dart';
import '../data/network/NetworkApiService.dart';
import '../data/network/app_url.dart';

class LeaveRepository{
  BaseApiService apiService = NetworkApiService();

  Future <dynamic> getLeavesListApi(dynamic data,BuildContext context) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.leaveListUrl, data,context);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> getLeavesTypeListApi(dynamic data,BuildContext context) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.leaveTypeListUrl, data,context);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> applyLeaveApi(dynamic data,BuildContext context,String? filePath) async {
    try {
      dynamic response = await apiService.getPostWithFileApiResponse(AppUrl.applyLeaveUrl, data,context,filePath);
      return response;
    }
    catch (e) {
      throw e;
    }

  }

  Future <dynamic> getLeavesRequestListApi(dynamic data,BuildContext context) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.leaveRequestListUrl, data,context);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> acceptDeclineLeaveApi(dynamic data,BuildContext context) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.acceptDeclineLeaveUrl, data,context);
      return response;
    }
    catch (e) {
      throw e;
    }

  }
  Future <dynamic> deleteLeaveApi(dynamic data,BuildContext context) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.deleteLeaveUrl, data,context);
      return response;
    }
    catch (e) {
      throw e;
    }

  }
}