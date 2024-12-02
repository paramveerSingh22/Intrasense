import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intrasense/model/timesheet/TimeSheetActivityModel.dart';
import 'package:intrasense/repository/time_sheet_repository.dart';

import '../model/timesheet/TimeSheetModel.dart';
import '../utils/Utils.dart';

class TimeSheetViewModel extends ChangeNotifier{
  final _myRepo = TimeSheetRepository();
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<List<TimeSheetActivityModel>?> getTimeSheetActivityApi(dynamic data,BuildContext context) async {
    setLoading(true);
    try{
      var response = await _myRepo.getTimeSheetActivityApi(data,context);
      List<TimeSheetActivityModel> list = (response['data'] as List)
          .map((group) => TimeSheetActivityModel.fromJson(group))
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

  Future<void> addTimeSheetApi(dynamic data, BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    _myRepo.addTimeSheetApi(data,context).then((onValue) {
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

  Future<List<TimeSheetModel>?> getTimeSheetListApi(dynamic data, BuildContext context) async {
    if (kDebugMode) {
      print("Api params---" + data.toString());
    }
    setLoading(true);

    try {
      var response = await _myRepo.getTimeSheetListApi(data, context);

      if (response['data'] != null && response['data'] is List) {
        List<TimeSheetModel> list = (response['data'] as List)
            .map((group) => TimeSheetModel.fromJson(group as Map<String, dynamic>))
            .toList();
        setLoading(false);

        if (kDebugMode) {
          print("Api Response--in viewmodel----" + response.toString());
          print("Api Response--in viewmodel in list----" + jsonEncode(list));
        }
        return list;
      }

     /* if (response['data'] != null && response['data'] is List) {
        List<TimeSheetModel> list = (response['data'] as List)
            .map((group) => TimeSheetModel.fromJson(group))
            .toList();
        setLoading(false);

        if (kDebugMode) {
          print("Api Response--in viewmodel----" + response.toString());
          print("Api Response--in viewmodel in list----" + jsonEncode(list));
        }
        return list;
      }*/ else {
        setLoading(false);
        Utils.toastMessage("Invalid response format");
        return null;
      }
    } catch (error) {
      setLoading(false);
      if (kDebugMode) {
        print("Api Error--" + error.toString());
      }
      Utils.toastMessage(error.toString());
      return null;
    }
  }


  /*Future<List<TimeSheetModel>?> getTimeSheetListApi(dynamic data,BuildContext context) async {
    Utils.toastMessage("Api is called now");
    print("Api params---" + data.toString());
    setLoading(true);
    try{
      var response = await _myRepo.getTimeSheetListApi(data,context);

      List<TimeSheetModel> list = (response['data'] as List)
          .map((group) => TimeSheetModel.fromJson(group))
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

  }*/

}