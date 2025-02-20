import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intrasense/model/projects/ProjectListModel.dart';
import 'package:intrasense/model/projects/ProjectManagersModel.dart';

import '../model/projects/AddQuotationModel.dart';
import '../model/projects/ProjectTypesModel.dart';
import '../repository/ProjectsRepository.dart';
import '../utils/Utils.dart';

class ProjectsViewModel with ChangeNotifier{
  final _myRepo = ProjectsRepository();
  bool _loading = false;
  bool get loading => _loading;

  bool _payslipLoading = false;
  bool get payslipLoading => _payslipLoading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setPaySlipLoading(bool value) {
    _payslipLoading = value;
    notifyListeners();
  }

  Future<List<ProjectManagersModel>?> getProjectManagersApi(dynamic data, BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }

    try{
      var response = await _myRepo.getProjectManagersApi(data,context);
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
      var response = await _myRepo.getProjectTypesApi(data,context);
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
    _myRepo.addProjectApi(data,context).then((onValue) {
      setLoading(false);
      if (kDebugMode) {
        print("Api Response---$onValue");
      }
      Map<String, dynamic> response = onValue as Map<String, dynamic>;
      Utils.toastMessage(response['message']);
      if (response['status'] == true) {
        Navigator.pop(context, true);
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(error.toString());
      }
      Utils.toastMessage(error.toString());
    });
  }

  Future<AddQuotationModel?> addProjectQuotationApi(dynamic data, BuildContext context) async {
    setPaySlipLoading(true);
    try {
      print("Api params---" + data.toString());

      var response = await _myRepo.addProjectQuotationApi(data, context);

      // Handle JSON object in the response and map it to AddQuotationModel
      AddQuotationModel responseData = AddQuotationModel.fromJson(response['data']);

      setPaySlipLoading(false);

      if (kDebugMode) {
        print("Api Response---" + response.toString());
      }

      return responseData;
    } catch (error) {
      setPaySlipLoading(false);

      if (kDebugMode) {
        print("Api Error--" + error.toString());
      }

      Utils.toastMessage(error.toString());
      return null; // Return null if there is an error
    }
  }
  Future<List<ProjectListModel>?> getProjectListApi(dynamic data,BuildContext context) async {
    setLoading(true);
    try{
      print("Api params---" + data.toString());
      var response = await _myRepo.getProjectListApi(data,context);
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

  Future<void> deleteProjectApi(dynamic data, BuildContext context) async {
    if (kDebugMode) {
      print("Api params---$data");
    }
    await  _myRepo.deleteProjectApi(data,context).then((onValue) {
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
}