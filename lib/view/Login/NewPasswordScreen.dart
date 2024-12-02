import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/res/component/CustomElevatedButton.dart';
import 'package:intrasense/res/component/CustomTextField.dart';
import 'package:intrasense/utils/Utils.dart';
import 'package:intrasense/view/Login/LoginScreen.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../view_models/auth_view_model.dart';
import 'package:provider/provider.dart';

class NewPasswordScreen extends StatefulWidget {
  final email;

  const NewPasswordScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  _NewPasswordScreen createState() => _NewPasswordScreen();
}

class _NewPasswordScreen extends State<NewPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

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

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const LoginScreen()),
              (Route<dynamic> route) => false,
        );
        return false;
      },
      child:  Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            // Header Image
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Images.headerBg),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 90.0,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                    Images.curveOverlay,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover
                ),
              ),
            ),
            Positioned(
              top: 140,
              left: 0,
              right: 0,
              bottom: 0,
              child: Image.asset(
                Images.curveBg,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 10.0, // adjust as needed
              left: 10.0, // adjust as needed
              child: Image.asset(
                Images.bubbleImage,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),

            Positioned(
              top: 36,
              left: 30,
              right: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Create New Password',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'PoppinsMedium',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                            (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(00.0, 110.0, 00.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.only(left: 30.0),
                    child: Text(
                      'Your new password must be different from previously used password',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsRegular'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.only(left: 30.0),
                    child: Text(
                      'New Password',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsRegular'),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: CustomTextField(
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
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.only(left: 30.0),
                    child: Text(
                      'Confirm Password',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsRegular'),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: CustomTextField(
                      controller: _confirmPasswordController,
                      hintText: 'Confirm Your Password',
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
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: CustomElevatedButton(
                        onPressed: () async {
                          if (_newPasswordController.text.isEmpty) {
                            Utils.toastMessage("Please enter new password");
                          } else if (_confirmPasswordController.text.isEmpty) {
                            Utils.toastMessage("Please enter confirm password");
                          }
                          else if (!isPasswordStrong(_newPasswordController.text)) {
                            Utils.toastMessage("Password must be at least 8 characters long, with uppercase, lowercase, and digits.");
                          }

                          else if (_newPasswordController.text != _confirmPasswordController.text) {
                            Utils.toastMessage("Passwords does not match with confirm password");
                          }

                          else {
                            Map data = {
                              'user_email': widget.email,
                              'newpassword':
                              _newPasswordController.text.toString(),
                              'confirmpassword':
                              _confirmPasswordController.text.toString(),
                            };

                            var response = await authViewModel
                                .forgotNewPasswordApi(data, context);
                            if (response != null) {
                              showPasswordUpdatedDialog(context);
                            }
                          }
                        },
                        buttonText: "SAVE",
                        loading: authViewModel.loading
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  void showPasswordUpdatedDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: AppColors.secondaryOrange.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Password Changed',
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.secondaryOrange,
                        fontFamily: 'PoppinsMedium'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close,
                    color: AppColors.textColor,),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              Images.successTick,
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            const Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Password Changed!',
                    style: TextStyle(
                        fontSize: 18,
                        color: AppColors.darkBlueTextColor,
                        fontFamily: 'PoppinsRegular'),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Your password has been changed successfully.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                        fontFamily: 'PoppinsRegular',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        );
      },
    );
  }

  bool isPasswordStrong(String password) {
    final bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    final bool hasDigits = password.contains(RegExp(r'[0-9]'));
    return password.length >= 8 && hasUppercase && hasLowercase && hasDigits;
  }
}
