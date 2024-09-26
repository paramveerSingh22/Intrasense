import '../data/network/BaseApiService.dart';
import '../data/network/NetworkApiService.dart';
import '../data/network/app_url.dart';

class TeamsRepository{
  BaseApiService apiService = NetworkApiService();

  Future <dynamic> addRoleApi(dynamic data) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.addRoleUrl, data);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> getRoleListApi(dynamic data) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.roleListUrl, data);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> deleteRoleApi(dynamic data) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.deleteRoleUrl, data);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> getEmployeesListApi(dynamic data) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.employeesListUrl, data);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> addGroupApi(dynamic data) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.addGroupUrl, data);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> getGroupListApi(dynamic data) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.groupListUrl, data);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> getGroupDetailsApi(dynamic data) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.groupDetailsUrl, data);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> updateGroupApi(dynamic data) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.updateGroupUrl, data);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> deleteGroupApi(dynamic data) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.deleteGroupUrl, data);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

}