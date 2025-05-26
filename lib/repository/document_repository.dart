import 'package:flutter/cupertino.dart';

import '../data/network/BaseApiService.dart';
import '../data/network/NetworkApiService.dart';
import '../data/network/app_url.dart';

class DocumentRepository{
  BaseApiService apiService = NetworkApiService();

  Future <dynamic> getMyFilesApi(dynamic data,BuildContext context) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.myFilesListUrl, data,context);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> getSharedWithMeFileApi(dynamic data,BuildContext context) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.sharedWithMeFileListUrl, data,context);
      return response;
    }
    catch (e) {
      throw e;
    }
  }


  Future <dynamic> createFolderApi(dynamic data,BuildContext context) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.createFolderUrl, data,context);
      return response;
    }
    catch (e) {
      throw e;
    }

  }

  Future <dynamic> getFileDetailApi(dynamic data,BuildContext context) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.fileDetailUrl, data,context);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> uploadFileApi(dynamic data,BuildContext context,String? filePath) async {
    try {
      dynamic response = await apiService.getPostWithFileApiResponse(AppUrl.uploadFileUrl, data,context,filePath);
      return response;
    }
    catch (e) {
      throw e;
    }

  }

}