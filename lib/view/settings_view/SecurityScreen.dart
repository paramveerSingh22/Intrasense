import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../model/user_model.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomTextField.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../utils/Utils.dart';
import '../../view_models/common_view_model.dart';
import 'package:provider/provider.dart';

import '../../view_models/user_view_model.dart';

class SecurityScreen extends  StatefulWidget{
  @override
  _SecurityScreen createState() => _SecurityScreen();

}

class _SecurityScreen extends State<SecurityScreen>{
  UserModel? _userData;
  bool _isLoading = false;
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _currentPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  void currentPasswordVisibility() {
    setState(() {
      _currentPasswordVisible = !_currentPasswordVisible;
    });
  }


  void newPasswordVisibility() {
    setState(() {
      _newPasswordVisible = !_newPasswordVisible;
    });
  }

  void confirmPasswordVisibility() {
    setState(() {
      _confirmPasswordVisible = !_confirmPasswordVisible;
    });
  }

  bool isPasswordStrong(String password) {
    final bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    final bool hasDigits = password.contains(RegExp(r'[0-9]'));
    return password.length >= 8 && hasUppercase && hasLowercase && hasDigits;
  }

  @override
  void initState() {
    super.initState();
    getUserDetails(context);
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();

  void getUserDetails(BuildContext context) async {
    // Utils.showLoadingDialog(context);
    _userData = await getUserData();
    if (kDebugMode) {
      print(_userData);
    }
  }


  @override
  Widget build(BuildContext context) {
    final commonViewModel = Provider.of<CommonViewModel>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child:SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Current Password',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium'),
                    )),
                const SizedBox(height: 5),
                CustomTextField(
                  controller: _currentPasswordController,
                  hintText: 'Enter Current Password',
                  obscureText: !_currentPasswordVisible,
                  suffixIcon: SizedBox(
                    width: 36,
                    height: 36,
                    child: IconButton(
                      icon: Image.asset(
                        _currentPasswordVisible
                            ? Images.passwordVisible
                            : Images.passwordHide,
                      ),
                      onPressed: currentPasswordVisibility,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'New Password',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium'),
                    )),
                const SizedBox(height: 5),
                CustomTextField(
                  controller: _newPasswordController,
                  hintText: 'Enter New Password',
                  obscureText: !_newPasswordVisible,
                  suffixIcon: SizedBox(
                    width: 36,
                    height: 36,
                    child: IconButton(
                      icon: Image.asset(
                        _newPasswordVisible
                            ? Images.passwordVisible
                            : Images.passwordHide,
                      ),
                      onPressed: newPasswordVisibility,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Confirm New Password',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium'),
                    )),
                const SizedBox(height: 5),
                CustomTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Enter Confirm Password',
                  obscureText: !_confirmPasswordVisible,
                  suffixIcon: SizedBox(
                    width: 36,
                    height: 36,
                    child: IconButton(
                      icon: Image.asset(
                        _confirmPasswordVisible
                            ? Images.passwordVisible
                            : Images.passwordHide,
                      ),
                      onPressed: confirmPasswordVisibility,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                CustomElevatedButton(
                  onPressed: () async{
                    if (_currentPasswordController.text.toString().isEmpty) {
                      Utils.toastMessage("Please enter confirm password");
                    } else if (_newPasswordController.text.toString().isEmpty) {
                      Utils.toastMessage("Please enter new password");
                    }
                    else if (!isPasswordStrong(_newPasswordController.text)) {
                      Utils.toastMessage("Password must be at least 8 characters long, with uppercase, lowercase, and digits.");
                    }

                    else if (_newPasswordController.text != _confirmPasswordController.text) {
                      Utils.toastMessage("Passwords does not match with confirm password");
                    }

                    else if (_confirmPasswordController.text.toString().isEmpty) {
                      Utils.toastMessage("Please enter confirm password");
                    }

                    else {
                      Map data = {
                        'user_id': _userData?.data?.userId.toString(),
                        'current_password': _currentPasswordController.text.toString(),
                        'new_password': _newPasswordController.text.toString(),
                        'confirm_password': _confirmPasswordController.text.toString(),
                      };
                     await commonViewModel.updateProfileApi(data, context);
                     _currentPasswordController.text="";
                      _newPasswordController.text="";
                      _confirmPasswordController.text="";
                    }
                  },
                  buttonText:  'UPDATE',
                  loading: commonViewModel.loading,
                ),
              ],
            )
        ),
      ),
    );
  }

}