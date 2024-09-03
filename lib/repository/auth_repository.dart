import 'package:intrasense/data/network/BaseApiService.dart';
import 'package:intrasense/data/network/NetworkApiService.dart';
import 'package:intrasense/res/app_url.dart';

class AuthRepository {
  BaseApiService apiService = NetworkApiService();

  Future <dynamic> loginApi(dynamic data) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.loginUrl, data);

      return response;
    }
    catch (e) {
      throw e;
    }
  }
}