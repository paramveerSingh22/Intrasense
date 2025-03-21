import 'package:flutter/cupertino.dart';

import '../data/network/BaseApiService.dart';
import '../data/network/NetworkApiService.dart';
import '../data/network/app_url.dart';

class MeetingRepository{
  BaseApiService apiService = NetworkApiService();

  Future <dynamic> getMeetingListApi(dynamic data,BuildContext context) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.meetingListUrl, data,context);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> getMeetingDetailApi(dynamic data,BuildContext context) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.meetingDetailUrl, data,context);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> getMeetingGroupListApi(dynamic data,BuildContext context) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.meetingGroupListUrl, data,context);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> addMeetingApi(dynamic data,BuildContext context) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.addMeetingUrl, data,context);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> meetingRevertApi(dynamic data,BuildContext context) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.meetingRevertUrl, data,context);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> meetingCancelApi(dynamic data,BuildContext context) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.meetingCancelUrl, data,context);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

}