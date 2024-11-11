import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intrasense/res/component/CustomElevatedButton.dart';
import 'package:intrasense/utils/Utils.dart';
import 'package:intrasense/view/Login/NewPasswordScreen.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../view_models/auth_view_model.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  final String otp;
  const OtpScreen({
    Key? key,
    required this.email,
    required this.otp,
  }) : super(key: key);
  @override
  _OtpScreen createState() => _OtpScreen();

}

class _OtpScreen extends State<OtpScreen> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();
  final TextEditingController _controller5 = TextEditingController();
  final TextEditingController _controller6 = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  final FocusNode _focusNode6 = FocusNode();

  String? _otp;

  @override
  void initState() {
    super.initState();
    _otp= widget.otp;
    _setupTextControllersAndFocusNodes();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode1);
    });

  }

 /* void _setupTextControllersAndFocusNodes() {
    List<TextEditingController> controllers = [
      _controller1,
      _controller2,
      _controller3,
      _controller4,
      _controller5,
      _controller6,
    ];

    List<FocusNode> focusNodes = [
      _focusNode1,
      _focusNode2,
      _focusNode3,
      _focusNode4,
      _focusNode5,
      _focusNode6,
    ];

    for (int i = 0; i < controllers.length; i++) {
      controllers[i].addListener(() {
        if (controllers[i].text.length == 1) {
          // Move focus to next field if a character is entered
          if (i < focusNodes.length - 1) {
            FocusScope.of(context).requestFocus(focusNodes[i + 1]);
          } else {
            focusNodes[i].unfocus(); // Unfocus on last field
          }
        }
      });

      focusNodes[i].addListener(() {
        focusNodes[i].onKey = (FocusNode node, RawKeyEvent event) {
          if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
            if (controllers[i].text.isEmpty && i > 0) {
              FocusScope.of(context).requestFocus(focusNodes[i - 1]);
              controllers[i - 1].clear(); // Clear previous field on first backspace press
            }
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        };
      });
    }
  }*/

  void _setupTextControllersAndFocusNodes() {
    List<TextEditingController> controllers = [
      _controller1,
      _controller2,
      _controller3,
      _controller4,
      _controller5,
      _controller6,
    ];

    List<FocusNode> focusNodes = [
      _focusNode1,
      _focusNode2,
      _focusNode3,
      _focusNode4,
      _focusNode5,
      _focusNode6,
    ];

    for (int i = 0; i < controllers.length; i++) {
      controllers[i].addListener(() {
        if (controllers[i].text.isEmpty) {
          _moveToPreviousField(focusNodes[i]);
        } else if (controllers[i].text.length == 1) {
          _moveToNextField(focusNodes[i]);
        }
      });
    }

    for (int i = 0; i < focusNodes.length; i++) {
      focusNodes[i].addListener(() {
        if (focusNodes[i].hasFocus && controllers[i].text.isNotEmpty) {
          controllers[i].selection = TextSelection(
            baseOffset: 0,
            extentOffset: controllers[i].text.length,
          );
        }
      });
    }
  }


  String _getCurrentText() {
    return _controller1.text +
        _controller2.text +
        _controller3.text +
        _controller4.text +
        _controller5.text +
        _controller6.text;
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
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
                  'Confirm OTP',
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

          Padding(
            padding: const EdgeInsets.fromLTRB(00.0, 110.0, 00.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 30.0,right: 20.0),
                  child: Text(
                    'A one time password(OTP) has been sent to your registered email address, kindly enter your OTP here',
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                        fontFamily: 'PoppinsRegular'),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: RawKeyboardListener(
                    focusNode: FocusNode(),
                    onKey: (event) {
                      if (event is RawKeyDownEvent &&
                          event.logicalKey == LogicalKeyboardKey.backspace) {
                          _handleBackspace();

                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildOTPTextField(_controller1, _focusNode1),
                            _buildOTPTextField(_controller2, _focusNode2),
                            _buildOTPTextField(_controller3, _focusNode3),
                            _buildOTPTextField(_controller4, _focusNode4),
                            _buildOTPTextField(_controller5, _focusNode5),
                            _buildOTPTextField(_controller6, _focusNode6),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    Map data = {
                      'user_email': widget.email,
                    };

                    var response = await authViewModel.forgotPasswordApi(data,context);
                    _otp = response['data']['otp'].toString();

                    _controller1.clear();
                    _controller2.clear();
                    _controller3.clear();
                    _controller4.clear();
                    _controller5.clear();
                    _controller6.clear();
                    FocusScope.of(context).requestFocus(_focusNode1);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Resend Code',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.secondaryOrange,
                        fontFamily: 'PoppinsSemiBold',
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.secondaryOrange,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: CustomElevatedButton(
                    onPressed: () async {

                      if (_getCurrentText().length != 6) {
                        Utils.toastMessage("Please enter valid OTP");
                      }

                      else if(_getCurrentText()==_otp){
                        Map data = {
                          'user_email': widget.email,
                          'otp': _getCurrentText().toString(),
                        };

                        var response = await authViewModel.forgotPasswordVerifyOtpApi(data, context);
                        if (response != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewPasswordScreen(
                                email:widget.email,
                              ),
                            ),
                          );
                        }
                      }

                      else {
                        Utils.toastMessage("OTP is invalid");
                      }
                    },
                    buttonText: "VERIFY OTP",
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

  Widget _buildOTPTextField(
      TextEditingController controller, FocusNode focusNode) {
    return Container(
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: Colors.grey[200], // Set background color here
        borderRadius: BorderRadius.circular(25.0), // Half of 50.0 width
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          counterText: '',
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(25.0)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.secondaryOrange),
              borderRadius: BorderRadius.circular(25.0)),
        ),
      ),
    );
  }

  void _moveToNextField(FocusNode focusNode) {
    if (focusNode == _focusNode1) {
      FocusScope.of(context).requestFocus(_focusNode2);
    } else if (focusNode == _focusNode2) {
      FocusScope.of(context).requestFocus(_focusNode3);
    } else if (focusNode == _focusNode3) {
      FocusScope.of(context).requestFocus(_focusNode4);
    }
    else if (focusNode == _focusNode4) {
      FocusScope.of(context).requestFocus(_focusNode5);
    }
    else if (focusNode == _focusNode5) {
      FocusScope.of(context).requestFocus(_focusNode6);
    }
  }

  void _moveToPreviousField(FocusNode focusNode) {
    if (focusNode == _focusNode2) {
      FocusScope.of(context).requestFocus(_focusNode1);
    } else if (focusNode == _focusNode3) {
      FocusScope.of(context).requestFocus(_focusNode2);
    } else if (focusNode == _focusNode4) {
      FocusScope.of(context).requestFocus(_focusNode3);
    }
    else if (focusNode == _focusNode5) {
      FocusScope.of(context).requestFocus(_focusNode4);
    }
    else if (focusNode == _focusNode6) {
      FocusScope.of(context).requestFocus(_focusNode5);
    }
  }


  void _handleBackspace() {
    List<TextEditingController> controllers = [
      _controller1,
      _controller2,
      _controller3,
      _controller4,
      _controller5,
      _controller6,
    ];

    List<FocusNode> focusNodes = [
      _focusNode1,
      _focusNode2,
      _focusNode3,
      _focusNode4,
      _focusNode5,
      _focusNode6,
    ];

    for (int i = focusNodes.length - 1; i >= 0; i--) {
      if (focusNodes[i].hasFocus && controllers[i].text.isEmpty && i > 0) {
        FocusScope.of(context).requestFocus(focusNodes[i - 1]);
        break;
      }
    }
  }

  /*void _handleBackspace() {
    List<TextEditingController> controllers = [
      _controller1,
      _controller2,
      _controller3,
      _controller4,
      _controller5,
      _controller6,
    ];

    List<FocusNode> focusNodes = [
      _focusNode1,
      _focusNode2,
      _focusNode3,
      _focusNode4,
      _focusNode5,
      _focusNode6,
    ];

    for (int i = focusNodes.length - 1; i >= 0; i--) {
      if (focusNodes[i].hasFocus) {
        if (controllers[i].text.isNotEmpty) {
          controllers[i].clear();
        } else if (i > 0) {
          FocusScope.of(context).requestFocus(focusNodes[i - 1]);
          Future.delayed(Duration(milliseconds: 10), () {
            if (controllers[i - 1].text.isNotEmpty) {
              controllers[i].clear();
            }
          });
        }
        break;
      }
    }
  }*/
}
