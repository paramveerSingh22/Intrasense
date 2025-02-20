import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/model/client_list_model.dart';
import '../../model/user_model.dart';
import '../../res/component/CustomDropdown.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomTextField.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../utils/Utils.dart';
import '../../view_models/client_view_model.dart';
import '../../view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class Addcontact extends StatefulWidget {

  final dynamic clientDetail;

  Addcontact({
    Key? key,
    this.clientDetail,
  }) : super(key: key);

  @override
  _Addcontact createState() => _Addcontact();
}

class _Addcontact extends State<Addcontact> {
  UserModel? _userData;
  TextEditingController _clientNameController = TextEditingController();
  TextEditingController _designationController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _landlineController = TextEditingController();
  TextEditingController _extController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserDetails(context);
    _clientNameController.text= widget.clientDetail.cmpName;
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();
  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    if (kDebugMode) {
      print(_userData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientViewModel = Provider.of<ClientViewModel>(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Images.headerBg),
                fit: BoxFit.cover,
              ),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // Example navigation back
              },
              child: const Padding(
                padding: EdgeInsets.only(top: 50, left: 30),
                child: Align(
                  alignment: Alignment.topLeft,
                  // Top left alignment set karne ke liye
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back, // Back icon ka code
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      // Icon aur text ke beech thoda space dene ke liye
                      Text(
                        'Add Contact',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: 'PoppinsRegular',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 90,
            left: 0,
            child: Stack(
              children: [
                Image.asset(
                  Images.curveOverlay,
                  width: MediaQuery.of(context).size.width,
                ),
                const Positioned(
                  top: 20, // Adjust the position of the text as needed
                  left: 30, // Adjust the position of the text as needed
                  child: Text(
                    'Add Contact',
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.secondaryOrange,
                        fontFamily: 'PoppinsMedium'),
                  ),
                ),
              ],
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
            top: 140,
            left: 20,
            right: 20,
            bottom: 0,
            child: SingleChildScrollView(
                child: Column(
              children: [
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Client Name',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium'),
                    )),
                CustomTextField(
                    controller: _clientNameController,
                    hintText: 'Client Name',
                    readOnly: true),
                const SizedBox(height: 15),

                const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Designation',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium'),
                    )),
                CustomTextField(
                  controller: _designationController,
                  hintText: 'Designation',
                ),
                const SizedBox(height: 15),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Name',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium'),
                    )),
                CustomTextField(
                  controller: _nameController,
                  hintText: 'Name',
                ),
                const SizedBox(height: 15),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Email',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium'),
                    )),
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Email',
                ),
                const SizedBox(height: 15),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Mobile',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium'),
                    )),
                CustomTextField(
                  controller: _mobileController,
                  hintText: 'Mobile',
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Expanded(
                        flex: 10,
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Landline',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsMedium'),
                            ))),
                    Expanded(flex: 1, child: Container()),
                    const Expanded(
                        flex: 10,
                        child: Text(
                          'Ext:',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsMedium'),
                        ))
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                        flex: 10,
                        child: CustomTextField(
                          controller: _landlineController,
                          hintText: 'landline',
                        )),
                    Expanded(flex: 1, child: Container()),
                    Expanded(
                        flex: 10,
                        child: CustomTextField(
                          controller: _extController,
                          hintText: 'Exit',
                        ))
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                        flex: 10,
                        child: CustomElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          buttonText: 'cancel',
                        )),
                    Expanded(flex: 1, child: Container()),
                    Expanded(
                        flex: 10,
                        child: CustomElevatedButton(
                          onPressed: () {
                             if (_designationController.text.isEmpty) {
                              Utils.toastMessage('Please enter designation');
                            } else if (_nameController.text.isEmpty) {
                              Utils.toastMessage('Please enter name');
                            } else if (_emailController.text.isEmpty) {
                              Utils.toastMessage('Please enter email');
                            } else if (_mobileController.text.isEmpty) {
                              Utils.toastMessage('Please enter mobile');
                            } else if (_landlineController.text.isEmpty) {
                              Utils.toastMessage('Please enter landline');
                            } else if (_landlineController.text.isEmpty) {
                              Utils.toastMessage('Please enter landline');
                            } else if (_extController.text.isEmpty) {
                              Utils.toastMessage('Please enter ext:');
                            } else {
                              Map data = {
                                'user_id': _userData?.data?.userId.toString(),
                                'usr_role_track_id':
                                    _userData?.data?.roleTrackId.toString(),
                                'company_id': widget.clientDetail.companyId,
                                'contactName': _nameController.text.toString(),
                                'contactEmail':
                                    _emailController.text.toString(),
                                'contactDesignation':
                                    _designationController.text.toString(),
                                'contactMobile':
                                    _mobileController.text.toString(),
                                'contactLandline':
                                    _landlineController.text.toString(),
                                'contactLandlineExt':
                                    _extController.text.toString(),
                                'token': _userData?.token.toString(),
                              };
                              clientViewModel.addContactApi(data, context);
                            }
                          },
                          buttonText: 'Save Contact',
                          loading: clientViewModel.loading,
                        ))
                  ],
                ),
                const SizedBox(height: 15),
              ],
            )),
          )
        ],
      ),
    );
  }
}
