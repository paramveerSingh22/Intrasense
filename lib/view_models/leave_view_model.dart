import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intrasense/model/leave/LeaveListModel.dart';
import 'package:intrasense/repository/leave_repository.dart';

import '../model/leave/LeaveTypeModel.dart';
import '../utils/Utils.dart';

class LeaveViewModel extends ChangeNotifier{
  final _myRepo = LeaveRepository();
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<List<LeaveListModel>?> getLeaveListApi(dynamic data,BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    try{
      var response = await _myRepo.getLeavesListApi(data,context);
      List<LeaveListModel> list = (response['data'] as List)
          .map((group) => LeaveListModel.fromJson(group))
          .toList();
      setLoading(false);
      if (kDebugMode) {
        print("Api Response---" + response.toString());
      }
      return list;
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

  Future<List<LeaveListModel>?> getLeaveRequestListApi(dynamic data,BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    try{
      var response = await _myRepo.getLeavesRequestListApi(data,context);
      List<LeaveListModel> list = (response['data'] as List)
          .map((group) => LeaveListModel.fromJson(group))
          .toList();
      setLoading(false);
      if (kDebugMode) {
        print("Api Response---" + response.toString());
      }
      return list;
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

  Future<List<LeaveTypeModel>?> getLeaveTypeListApi(dynamic data,BuildContext context) async {
    try{
      var response = await _myRepo.getLeavesTypeListApi(data, context);
      List<LeaveTypeModel> list = (response['data'] as List)
          .map((group) => LeaveTypeModel.fromJson(group))
          .toList();
      if (kDebugMode) {
        print("Api Response---" + response.toString());
      }
      return list;
    }
    catch (error) {
      if (kDebugMode) {
        print("Api Error--" + error.toString());
      }
      Utils.toastMessage(error.toString());
      return null;
    }

  }

  Future<void> applyLeaveWithFileApi(dynamic data, BuildContext context,String? filePath) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    _myRepo.applyLeaveApi(data,context,filePath).then((onValue) {
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
        print("Api error---$error");
      }
      Utils.errorMessage(error);
    });
  }

  Future<void> acceptDeclineLeaveApi(dynamic data, BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    _myRepo.acceptDeclineLeaveApi(data,context).then((onValue) {
      setLoading(false);
      if (kDebugMode) {
        print("Api Response---$onValue");
      }
      Map<String, dynamic> response = onValue as Map<String, dynamic>;
      if (response['status'] == true) {
        Utils.toastMessage("Leave status is updated.");
        Navigator.pop(context, true);
      }
      else{
        Utils.toastMessage(response['message']);
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(error.toString());
      }
      //Utils.toastMessage(error.toString());
    });
  }

  Future<void> deleteLeaveApi(dynamic data, BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    _myRepo.deleteLeaveApi(data,context).then((onValue) {
      setLoading(false);
      if (kDebugMode) {
        print("Api Response---$onValue");
      }
      Map<String, dynamic> response = onValue as Map<String, dynamic>;
      Utils.toastMessage(response['message']);
    }).onError((error, stackTrace) {
      setLoading(false);
      try {
        Utils.toastMessage(Utils().extractErrorMessage(error.toString()));

      } catch (e) {
        print("Error while parsing: $e");
        Utils.toastMessage("Something went wrong1");
      }
    });
  }


}