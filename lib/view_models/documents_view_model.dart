import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intrasense/model/documents/MyFoldersModel.dart';

import '../repository/document_repository.dart';
import '../utils/Utils.dart';

class DocumentsViewModel with ChangeNotifier{

  final _myRepo = DocumentRepository();
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<List<MyFoldersModel>?> getMyFilesListApi(dynamic data,BuildContext context) async {
    setLoading(true);
    try{
      print("Api params---" + data.toString());
      var response = await _myRepo.getMyFilesApi(data,context);
      List<MyFoldersModel> filesList = (response['data'] as List)
          .map((group) => MyFoldersModel.fromJson(group))
          .toList();
      setLoading(false);
      if (kDebugMode) {
        print("Api Response---" + response.toString());
      }
      return filesList;
    }
    catch (error) {
      setLoading(false);
      if (kDebugMode) {
        print("Api Error--" + error.toString());
      }
      Utils.toastMessage(error.toString());
      return null;
    }
  }

  Future<List<MyFoldersModel>?> getSharedWithMeListApi(dynamic data,BuildContext context) async {
    setLoading(true);
    try{
      print("Api params---" + data.toString());
      var response = await _myRepo.getSharedWithMeFileApi(data,context);
      List<MyFoldersModel> filesList = (response['data'] as List)
          .map((group) => MyFoldersModel.fromJson(group))
          .toList();
      setLoading(false);
      if (kDebugMode) {
        print("Api Response---" + response.toString());
      }
      return filesList;
    }
    catch (error) {
      setLoading(false);
      if (kDebugMode) {
        print("Api Error--" + error.toString());
      }
      Utils.toastMessage(error.toString());
      return null;
    }
  }

  Future<void> createFolderApi(dynamic data, BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    _myRepo.createFolderApi(data,context).then((onValue) {
      setLoading(false);
      if (kDebugMode) {
        print("Api Response---$onValue");
      }
      Map<String, dynamic> response = onValue as Map<String, dynamic>;
      Utils.toastMessage(response['message']);
      if (response['status'] == true) {
        //Navigator.pop(context, true);
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print("Api Error---"+error.toString());
      }
      Utils.toastMessage(error.toString());
    });
  }

}