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
}