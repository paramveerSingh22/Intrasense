import 'package:flutter/material.dart';
import 'package:intrasense/utils/AppColors.dart';
import 'package:intrasense/utils/Images.dart';
import 'package:intrasense/utils/Utils.dart';
import 'package:intrasense/view/Home/HomeScreen.dart';
import 'package:intrasense/view/Login/ForgotPasswordScreen.dart';
import 'package:intrasense/view_models/auth_view_model.dart';

import '../../res/component/CustomElevatedButton.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isCheckboxChecked = false;

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();


  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
      body: Stack(
        children: [
          // Background Image Container
          Container(
            width: double.infinity,
            height: MediaQuery
                .of(context)
                .size
                .height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Images.headerBg),
                fit: BoxFit.cover,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 50, left: 30),
              child: Text(
                'Sign in to continue',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: 'PoppinsRegular'),
              ),
            ),
          ),
          // Overlay Image on Header
          Positioned(
            top: 90,
            left: 0,
            child: Image.asset(
              Images.curveOverlay,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
            ),
          ),
          // Curve Container
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
          // Content Container
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(00.0, 110.0, 00.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, top: 10.0),
                    child: Image.asset(
                      Images.signInAppLogo,
                      width: 160,
                      height: 22,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.only(left: 30.0),
                    child: Text(
                      'Kindly login to access your account',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsRegular'),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.only(left: 30.0),
                    child: Text(
                      'Email',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsRegular'),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: TextField(
                      controller: _emailController,
                      focusNode: emailFocusNode,
                      onSubmitted: (value) {
                        Utils.fieldFocus(
                            context, emailFocusNode, passwordFocusNode);
                      },
                      style: const TextStyle(
                        fontFamily: 'PoppinsRegular',
                        fontSize: 14.0,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter Email',
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 15.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                        ),
                        suffixIcon: const Icon(Icons.email,
                            color: AppColors.secondaryOrange),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.only(left: 30.0),
                    child: Text(
                      'Password',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsRegular'),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: TextField(
                      controller: _passwordController,
                      focusNode: passwordFocusNode,
                      style: const TextStyle(
                        fontFamily: 'PoppinsRegular',
                        fontSize: 14.0,
                      ),
                      obscureText: _isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: 'Enter Password',
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 15.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.secondaryOrange,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Checkbox(
                              value: _isCheckboxChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isCheckboxChecked = value!;
                                });
                              },
                              activeColor: AppColors.secondaryOrange,
                            ),
                            const SizedBox(width: 0),
                            const Text(
                              'Keep me logged in',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsRegular'),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const ForgotPasswordScreen()),
                            );
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                                fontSize: 14, color: AppColors.secondaryOrange),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: CustomElevatedButton(
                          onPressed: () {
                            if (_emailController.text.isEmpty) {
                              Utils.toastMessage('Please enter email id');
                            } else if (_passwordController.text.isEmpty) {
                              Utils.toastMessage('Please enter password');
                            } else {
                              Map data = {
                                'usr_email' : _emailController.text.toString(),
                                'usr_password' : _passwordController.text.toString()
                              };
                              authViewModel.loginApi(data,context);
                            }
                          },
                          buttonText: 'SIGN IN',
                        loading: authViewModel.loading,
                      ),

                  ),

                  const SizedBox(height: 20),
                  Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'OR, Sign in to continue',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsRegular'),
                      )),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Implement your Facebook login logic here
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  side: const BorderSide(
                                    color: Colors.grey,
                                    width: 0.1,
                                  )),
                            ),
                            icon: const Icon(
                              Icons.facebook,
                              color: Colors.blue,
                            ),
                            label: const Text(
                              'Facebook',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsRegular'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Implement your Google login logic here
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  side: const BorderSide(
                                    color: Colors.grey,
                                    width: 0.1,
                                  )),
                            ),
                            icon: const GoogleIcon(),
                            label: const Text(
                              'Google',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsRegular'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'New to intrasense?',
                            style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsRegular'),
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              // Navigate to the sign-up screen or perform other actions
                            },
                            child: const Text(
                              'Sign Up Here',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                  fontFamily: 'PoppinsRegular'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Positioned bubble image at the bottom left corner
        ],
      ),
    );
  }
}

class GoogleIcon extends StatelessWidget {
  const GoogleIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.0,
      height: 20.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Images.google),
          // Replace with your custom Google icon image path
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
