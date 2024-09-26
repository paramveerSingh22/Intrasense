import '../data/network/BaseApiService.dart';
import '../data/network/NetworkApiService.dart';
import '../data/network/app_url.dart';

class CommonRepository {
  BaseApiService apiService = NetworkApiService();
  Future<dynamic> countryListApi() async {
    try {
      dynamic response =
          await apiService.getGetApiResponse(AppUrl.countryListUrl);
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> industryListApi() async {
    try {
      dynamic response =
      await apiService.getGetApiResponse(AppUrl.industryListUrl);
      return response;
    } catch (e) {
      throw e;
    }
  }
}
