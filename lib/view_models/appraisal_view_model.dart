import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intrasense/model/appraisal/AppraisalDetailModel.dart';
import 'package:intrasense/model/appraisal/AppraisalRequestListModel.dart';

import '../model/appraisal/AppraisalListModel.dart';
import '../repository/appraisal_repository.dart';
import '../utils/Utils.dart';

class AppraisalViewModel with ChangeNotifier{
  final _myRepo = AppraisalRepository();
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }


  Future<List<AppraisalListModel>?> getAppraisalListApi(dynamic data,BuildContext context) async {
    setLoading(true);
    try{
      print("Api params---" + data.toString());
      var response = await _myRepo.getAppraisalListApi(data,context);
      List<AppraisalListModel> projectList = (response['data'] as List)
          .map((group) => AppraisalListModel.fromJson(group))
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

  Future<List<AppraisalDetailModel>?> getAppraisalDetailApi(dynamic data,BuildContext context) async {
    setLoading(true);
    try{
      print("Api params---" + data.toString());
      var response = await _myRepo.getAppraisalDetailApi(data,context);
      List<AppraisalDetailModel> projectList = (response['data'] as List)
          .map((group) => AppraisalDetailModel.fromJson(group))
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

  Future<List<AppraisalRequestListModel>?> getAppraisalRequestListApi(dynamic data,BuildContext context) async {
    setLoading(true);
    try{
      print("Api params---" + data.toString());
      var response = await _myRepo.getAppraisalRequestListApi(data,context);
      List<AppraisalRequestListModel> projectList = (response['data'] as List)
          .map((group) => AppraisalRequestListModel.fromJson(group))
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