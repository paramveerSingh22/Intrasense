import 'package:flutter/cupertino.dart';

import '../data/network/BaseApiService.dart';
import '../data/network/NetworkApiService.dart';
import '../data/network/app_url.dart';

class ExpenseRepository{
  BaseApiService apiService = NetworkApiService();

  Future <dynamic> getExpenseListApi(dynamic data,BuildContext context) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.expenseListUrl, data,context);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> addExpenseApi(dynamic data,BuildContext context) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.addExpenseUrl, data,context);
      return response;
    }
    catch (e) {
      throw e;
    }

  }

  Future <dynamic> deleteExpenseApi(dynamic data,BuildContext context) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.deleteExpenseUrl, data,context);
      return response;
    }
    catch (e) {
      throw e;
    }

  }

  Future <dynamic> approveExpenseApi(dynamic data,BuildContext context) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.approveExpenseUrl, data,context);
      return response;
    }
    catch (e) {
      throw e;
    }

  }

  Future <dynamic> paidExpenseApi(dynamic data,BuildContext context) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.paidExpenseUrl, data,context);
      return response;
    }
    catch (e) {
      throw e;
    }

  }

}