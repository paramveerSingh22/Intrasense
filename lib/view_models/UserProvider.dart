import 'package:flutter/cupertino.dart';
import 'package:intrasense/view_models/user_view_model.dart';

import '../model/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  Future<void> fetchUserData() async {
    _user = await UserViewModel().getUser();
    notifyListeners();
  }
}