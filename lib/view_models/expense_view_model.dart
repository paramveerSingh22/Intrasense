import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intrasense/model/expense/ExpenseListModel.dart';

import '../repository/expense_repository.dart';
import '../utils/Utils.dart';

class ExpenseViewModel extends ChangeNotifier{
  final _myRepo = ExpenseRepository();
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<List<ExpenseListModel>?> getExpensesListApi(dynamic data,BuildContext context) async {
    setLoading(true);
    try{
      var response = await _myRepo.getExpenseListApi(data,context);
      List<ExpenseListModel> list = (response['data'] as List)
          .map((group) => ExpenseListModel.fromJson(group))
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


  Future<void> addExpenseApi(dynamic data, BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    _myRepo.addExpenseApi(data,context).then((onValue) {
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
        print("Api Error---"+error.toString());
      }
      Utils.toastMessage(error.toString());
    });
  }

  Future<void> deleteExpenseApi(dynamic data, BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    _myRepo.deleteExpenseApi(data,context).then((onValue) {
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

  Future<void> approveExpenseApi(dynamic data, BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    _myRepo.approveExpenseApi(data,context).then((onValue) {
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
      //Utils.toastMessage(error.toString());
    });
  }

  Future<void> paidExpenseApi(dynamic data, BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    _myRepo.paidExpenseApi(data,context).then((onValue) {
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
      //Utils.toastMessage(error.toString());
    });
  }

}