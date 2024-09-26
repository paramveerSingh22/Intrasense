import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intrasense/repository/teams_repository.dart';

import '../model/RoleListModel.dart';
import '../model/teams/EmployeesListModel.dart';
import '../model/teams/GroupListModel.dart';
import '../utils/Utils.dart';

class TeamsViewModel with ChangeNotifier{
  final _myRepo = TeamsRepository();
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  /// for roles///
  Future<void> addRoleApi(dynamic data, BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    _myRepo.addRoleApi(data).then((onValue) {
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

  List<RoleListModel> _roleList = [];
  List<RoleListModel> get roleList => _roleList;

  Future<void> getRoleListApi(dynamic data,BuildContext context) async {
    setLoading(true);
    await _myRepo.getRoleListApi(data).then((onValue) {
      if (kDebugMode) {
        print("Api Response---"+onValue.toString());
      }
      List<dynamic> dataList = onValue['data'] as List<dynamic>;
      List<RoleListModel> roleList = dataList
          .map((json) => RoleListModel.fromJson(json as Map<String, dynamic>))
          .toList();
      _roleList = roleList;
      notifyListeners();
      setLoading(false);
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print("Api Error--"+error.toString());
      }
      Utils.toastMessage(error.toString());
    });
  }

  Future<void> deleteRoleApi(dynamic data, BuildContext context) async {
    if (kDebugMode) {
      print("Api params---$data");
    }
    await  _myRepo.deleteRoleApi(data).then((onValue) {
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

  /// for Groups///
  Future<List<EmployeesListModel>?> getEmployeesListApi(dynamic data,BuildContext context) async {
    setLoading(true);
    try{
      var response = await _myRepo.getEmployeesListApi(data);
      List<EmployeesListModel> employees = (response['data'] as List)
          .map((employee) => EmployeesListModel.fromJson(employee))
          .toList();
      setLoading(false);
      if (kDebugMode) {
        print("Api Response---" + response.toString());
      }
      return employees;
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

  Future<void> addGroupApi(dynamic data, BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    _myRepo.addGroupApi(data).then((onValue) {
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


  Future<List<GroupListModel>?> getGroupListApi(dynamic data,BuildContext context) async {
    setLoading(true);
    try{
      var response = await _myRepo.getGroupListApi(data);
      List<GroupListModel> groupList = (response['data'] as List)
          .map((group) => GroupListModel.fromJson(group))
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

  Future<dynamic> getGroupDetailsApi(dynamic data, BuildContext context) async {
    setLoading(true);

    if (kDebugMode) {
      print("Api params---$data");
    }

    try {
      final onValue = await _myRepo.getGroupDetailsApi(data);
      setLoading(false);

      if (kDebugMode) {
        print("Api Response---$onValue");
      }

      return onValue; // Return the API response
    } catch (error, stackTrace) {
      setLoading(false);

      if (kDebugMode) {
        print("Error occurred: $error");
      }

      Utils.toastMessage(error.toString());
      return null; // Return null or a specific error object
    }
  }

  Future<void> updateGroupApi(dynamic data, BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    _myRepo.updateGroupApi(data).then((onValue) {
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

  Future<void> deleteGroupApi(dynamic data, BuildContext context) async {
    if (kDebugMode) {
      print("Api params---$data");
    }
    await  _myRepo.deleteGroupApi(data).then((onValue) {
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