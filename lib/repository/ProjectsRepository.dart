import '../data/network/BaseApiService.dart';
import '../data/network/NetworkApiService.dart';
import '../data/network/app_url.dart';

class ProjectsRepository{
  BaseApiService apiService = NetworkApiService();

  Future <dynamic> getProjectManagersApi(dynamic data) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.projectManagersListUrl, data);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> getProjectTypesApi(dynamic data) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.projectTypesListUrl, data);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> addProjectApi(dynamic data) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.addProjectUrl, data);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> getProjectListApi(dynamic data) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.projectListUrl, data);
      return response;
    }
    catch (e) {
      throw e;
    }
  }
}