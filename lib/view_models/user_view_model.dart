import 'package:flutter/cupertino.dart';
import 'package:intrasense/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserViewModel with ChangeNotifier {
  Future<bool> saveUser(UserModel user) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    sp.setString('token', user.token.toString());
    sp.setString('user_id', user.data!.userId.toString());
    sp.setString('user_first_name', user.data!.firstName.toString());
    sp.setString('user_last_name', user.data!.lastName.toString());
    sp.setString('user_email', user.data!.email.toString());
    sp.setString('user_role_track_id', user.data!.roleTrackId.toString());
    sp.setString('user_customer_track_id', user.data!.customerTrackId.toString());
    sp.setString('user_type', user.data!.userType.toString());

    notifyListeners();

    return true;
  }

  Future<UserModel> getUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? token = sp.getString('token');

    final UserData data = UserData(
      userId: sp.getString('user_id'),
      firstName: sp.getString('user_first_name'),
      lastName: sp.getString('user_last_name'),
      email: sp.getString('user_email'),
      roleTrackId: sp.getString('user_role_track_id'),
      customerTrackId: sp.getString('user_customer_track_id'),
      userType: sp.getString('user_type'),
    );

    return UserModel(token: token?? "", data: data);

  }

  Future<bool> remove() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    return sp.clear();
  }
}
