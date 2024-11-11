import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/res/component/CustomElevatedButton.dart';
import 'package:intrasense/res/component/CustomTextField.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../utils/Utils.dart';
import '../../view_models/auth_view_model.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart' as validator;
import 'OtpScreen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordScreen> {
  TextEditingController _emailController = TextEditingController();

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
            child: Image.asset(
                Images.curveOverlay,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                fit: BoxFit.cover
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
            bottom: 10.0,
            left: 10.0,
            child: Image.asset(
              Images.bubbleImage,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),

          // Header Overlay with Text and Back Button
          Positioned(
            top: 36,
            left: 30,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Forgot Password',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: 'PoppinsMedium',
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),

          // Content Positioned Below Header
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 110.0, 0.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 30.0, right: 20.0),
                  child: Text(
                    'Kindly enter your email to reset password',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textColor,
                      fontFamily: 'PoppinsRegular',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 30.0),
                  child: Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textColor,
                      fontFamily: 'PoppinsRegular',
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: CustomTextField(
                    controller: _emailController,
                    hintText: 'Enter Email',
                    suffixIcon: SizedBox(
                      width: 16,
                      height: 16,
                      child: Image.asset(
                        Images.emailIcon,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: CustomElevatedButton(
                    onPressed: () async {
                      if (_emailController.text.isEmpty) {
                        Utils.toastMessage('Please enter email id');
                      } else if (!validator.isEmail(_emailController.text)) {
                        Utils.toastMessage('Please enter a valid email id');
                      } else {
                        Map data = {
                          'user_email': _emailController.text.toString(),
                        };
                        var response = await authViewModel.forgotPasswordApi(data, context);
                        var otp = response['data']['otp'].toString();
                        if (response != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OtpScreen(
                                email: _emailController.text,
                                otp: otp,
                              ),
                            ),
                          );
                        }
                      }
                    },
                    buttonText: "GET OTP",
                    loading: authViewModel.loading,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
