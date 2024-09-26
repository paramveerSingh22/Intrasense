import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/repository/auth_repository.dart';
import 'package:intrasense/utils/Utils.dart';
import 'package:intrasense/view_models/user_view_model.dart';

import '../model/user_model.dart';
import '../view/Home/HomeScreen.dart';

class AuthViewModel with ChangeNotifier {
  final _myRepo = AuthRepository();
  final UserViewModel userViewModel = UserViewModel();
  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> loginApi(dynamic data, BuildContext context) async {
    setLoading(true);
    _myRepo.loginApi(data).then((onValue) {
      setLoading(false);
      if (kDebugMode) {
        print(onValue.toString());
      }
      UserModel userModel=UserModel.fromJson(onValue);
      userViewModel.saveUser(userModel);

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(error.toString());
      }
      Utils.toastMessage(error.toString());
    });
  }
}
