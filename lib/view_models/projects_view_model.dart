import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intrasense/model/projects/ProjectListModel.dart';
import 'package:intrasense/model/projects/ProjectManagersModel.dart';

import '../model/projects/ProjectTypesModel.dart';
import '../repository/ProjectsRepository.dart';
import '../utils/Utils.dart';

class ProjectsViewModel with ChangeNotifier{
  final _myRepo = ProjectsRepository();
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<List<ProjectManagersModel>?> getProjectManagersApi(dynamic data, BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }

    try{
      var response = await _myRepo.getProjectManagersApi(data);
      List<ProjectManagersModel> groupList = (response['data'] as List)
          .map((group) => ProjectManagersModel.fromJson(group))
          .toList();
      setLoading(false);
      if (kDebugMode) {
        print("Api Response---" + response.toString());
      }
      return groupList;
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

  Future<List<ProjectTypesModel>?> getProjectTypesApi(dynamic data, BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    try{
      var response = await _myRepo.getProjectTypesApi(data);
      List<ProjectTypesModel> projectTypeList = (response['data'] as List)
          .map((group) => ProjectTypesModel.fromJson(group))
          .toList();
      setLoading(false);
      if (kDebugMode) {
        print("Api Response---" + response.toString());
      }
      return projectTypeList;
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

  Future<void> addProjectApi(dynamic data, BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    _myRepo.addProjectApi(data).then((onValue) {
      setLoading(false);
      if (kDebugMode) {
        print("Api Response---$onValue");
      }
      Map<String, dynamic> response = onValue as Map<String, dynamic>;
      Utils.toastMessage(response['message']);

    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(error.toString());
      }
      Utils.toastMessage(error.toString());
    });
  }

  Future<List<ProjectListModel>?> getProjectListApi(dynamic data,BuildContext context) async {
    setLoading(true);
    try{
      var response = await _myRepo.getProjectListApi(data);
      List<ProjectListModel> projectList = (response['data'] as List)
          .map((group) => ProjectListModel.fromJson(group))
          .toList();
      setLoading(false);
      if (kDebugMode) {
        print("Api Response---" + response.toString());
      }
      return projectList;
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
}