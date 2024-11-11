import 'package:flutter/material.dart';
import 'package:intrasense/res/component/CustomTextField.dart';
import 'package:intrasense/utils/AppColors.dart';
import 'package:intrasense/utils/Images.dart';
import 'package:intrasense/utils/Utils.dart';
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
  TextEditingController _emailController = TextEditingController(text: "suri@milagro.in");
  TextEditingController _passwordController = TextEditingController(text:"Suri@145");
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
      resizeToAvoidBottomInset: false,
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
                    fontFamily: 'PoppinsMedium'),
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
                fit: BoxFit.cover
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
                    padding: EdgeInsets.only(left: 30.0,right: 20.0),
                    child: Text(
                      'Kindly login to access your account',
                      style: TextStyle(
                          fontSize: 15,
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
                          fontSize: 13,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsRegular'),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: CustomTextField(
                        hintText: "Enter Email",
                      controller: _emailController,
                        suffixIcon: SizedBox(
                          width: 16, // Set the desired width
                          height: 16, // Set the desired height
                          child: Image.asset(
                            Images.emailIcon,
                            fit: BoxFit.contain,
                          ),
                        )
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.only(left: 30.0),
                    child: Text(
                      'Password',
                      style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsRegular'),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child:CustomTextField(
                        hintText: "Enter Password",
                        controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      suffixIcon: SizedBox(
                        width: 36,
                        height: 36,
                        child: IconButton(
                          icon: Image.asset(
                            _isPasswordVisible
                                ? Images.passwordVisible
                                : Images.passwordHide,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            const SizedBox(width: 10),
                            Theme(
                              data: ThemeData(
                                checkboxTheme: CheckboxThemeData(
                                  side: BorderSide(color: Colors.transparent, width: 0),
                                ),
                              ),
                              child: Container(
                                width: 18, // Set to a fixed width to avoid size changes
                                height: 18, // Set to a fixed height to avoid size changes
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _isCheckboxChecked ? Colors.transparent : AppColors.secondaryOrange,
                                    width: 2, // Border width
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: Checkbox(
                                    value: _isCheckboxChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _isCheckboxChecked = value!;
                                      });
                                    },
                                    activeColor: AppColors.secondaryOrange,
                                    checkColor: Colors.white,
                                    materialTapTargetSize: MaterialTapTargetSize.padded, // Retain full click area
                                    visualDensity: VisualDensity.standard, // Standard density for consistent size
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              'Keep me logged in',
                              style: TextStyle(
                                  fontSize: 13,
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
                                fontSize: 12,
                                color: AppColors.secondaryOrange,
                                fontFamily:'PoppinsMedium' ,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
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
                        'OR, Sign in with...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsSemiBold'),
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
                                  fontSize: 13,
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
                                  fontSize: 13,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsRegular'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
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
