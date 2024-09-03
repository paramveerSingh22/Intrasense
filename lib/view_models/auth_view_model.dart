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


      UserModel userT=UserModel.fromJson(onValue);

     /* UserModel userModel = UserModel(
        token: onValue['token'],
        data: UserData(
          userId: onValue['user_id'],
          firstName: onValue['user_first_name'],
          lastName: onValue['user_last_name'],
          email: onValue['user_email'],
          roleTrackId: onValue['user_role_track_id'],
          customerTrackId: onValue['user_customer_track_id'],
          userType: onValue['user_type'],
          teamTrackId: onValue['usr_team_track_id'],
          isLoggedIn: onValue['is_logged_in'],
            canCreate: onValue['can_create'],
            canView: onValue['can_view'],
            canSupport: onValue['can_support'],
        ),
      );
      */

      userViewModel.saveUser(userT);



      // Navigator.pushNamed(context, RoutesName.home);
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
