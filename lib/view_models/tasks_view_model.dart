import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../model/tasks/TaskDetailModel.dart';
import '../model/tasks/TasksListModel.dart';
import '../repository/tasks_repository.dart';
import '../utils/Utils.dart';

class TasksViewModel with ChangeNotifier{
  final _myRepo = TasksRepository();
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<List<TaskListModel>?> getTasksListApi(dynamic data,BuildContext context) async {
    setLoading(true);
    try{
      var response = await _myRepo.getTasksListApi(data,context);
      List<TaskListModel> groupList = (response['data'] as List)
          .map((group) => TaskListModel.fromJson(group))
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

  Future<void> addTaskApi(dynamic data, BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    _myRepo.addTaskApi(data,context).then((onValue) {
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

  Future<void> deleteTaskApi(dynamic data, BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    _myRepo.deleteTaskApi(data,context).then((onValue) {
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
      try {
        String errorString = error.toString();
        int jsonStartIndex = errorString.indexOf("{");
        if (jsonStartIndex != -1) {
          String jsonPart = errorString.substring(jsonStartIndex);
          Map<String, dynamic> errorResponse = jsonDecode(jsonPart);
          Utils.toastMessage(errorResponse['message']);
        } else {
          Utils.toastMessage(errorString);
        }
      } catch (e) {
        Utils.toastMessage(e.toString());
      }
    });
  }

  Future<TaskDetailModel?> getTasksDetailApi(dynamic data,BuildContext context) async {
    setLoading(true);
    try{
      var response = await _myRepo.taskDetailsApi(data,context);
      setLoading(false);
      if (kDebugMode) {
        print("Api Response---" + response.toString());
      }
      if (response != null && response['data'] != null && response['data'].isNotEmpty) {
        return TaskDetailModel.fromJson(response['data'][0]);
      } else {
        return null; // Handle case where there's no data
      }

      return response;
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