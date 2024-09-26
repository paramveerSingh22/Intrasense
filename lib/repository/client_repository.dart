import '../data/network/BaseApiService.dart';
import '../data/network/NetworkApiService.dart';
import '../data/network/app_url.dart';

class ClientRepository{
  BaseApiService apiService = NetworkApiService();

  Future <dynamic> addClientsApi(dynamic data) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.addClientListUrl, data);

      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> getClientListApi(dynamic data) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.clientListUrl, data);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> deleteClientApi(dynamic data) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.deleteClientUrl, data);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> addSubClientApi(dynamic data) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.addSubClientUrl, data);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> getSubClientListApi(dynamic data) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.subClientListUrl, data);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> deleteSubClientApi(dynamic data) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.deleteSubClientUrl, data);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> addContactApi(dynamic data) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.addContactUrl, data);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> getContactListApi(dynamic data) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.contactListUrl, data);
      return response;
    }
    catch (e) {
      throw e;
    }
  }

  Future <dynamic> deleteClientContactApi(dynamic data) async {
    try {
      dynamic response = await apiService.getPostApiResponse(AppUrl.deleteClientContactUrl, data);
      return response;
    }
    catch (e) {
      throw e;
    }
  }
}