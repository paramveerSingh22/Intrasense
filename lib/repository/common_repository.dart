import 'package:flutter/cupertino.dart';

import '../data/network/BaseApiService.dart';
import '../data/network/NetworkApiService.dart';
import '../data/network/app_url.dart';

class CommonRepository {
  BaseApiService apiService = NetworkApiService();
  Future<dynamic> countryListApi(BuildContext context) async {
    try {
      dynamic response =
          await apiService.getGetApiResponse(AppUrl.countryListUrl,context);
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> industryListApi(BuildContext context) async {
    try {
      dynamic response =
      await apiService.getGetApiResponse(AppUrl.industryListUrl,context);
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> timeZoneListApi(BuildContext context) async {
    try {
      dynamic response =
      await apiService.getGetApiResponse(AppUrl.timeZoneListUrl,context);
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future <dynamic> commonImageUploadApi(dynamic data,BuildContext context) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.commonImageUploadUrl, data,context);
      return response;
    }
    catch (e) {
      throw e;
    }

  }

}
