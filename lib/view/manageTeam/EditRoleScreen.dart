import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/model/RoleListModel.dart';
import 'package:intrasense/utils/Utils.dart';
import '../../model/user_model.dart';
import '../../res/component/CheckboxWithLabel.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomTextField.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../view_models/UserProvider.dart';
import '../../view_models/teams_view_model.dart';
import '../../view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class EditRoleScreen extends StatefulWidget {
  final RoleListModel roleDetails;

  const EditRoleScreen({Key? key, required this.roleDetails}) : super(key: key);

  _EditRoleScreen createState() => _EditRoleScreen();
}

class _EditRoleScreen extends State<EditRoleScreen> {
  final TextEditingController _roleNameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  List<String> selectedPermissions = [];
  UserModel? _userData;



  @override
  void initState() {
    super.initState();
    getUserDetails(context);
    _roleNameController.text = widget.roleDetails.roleName.toString();
    _notesController.text = widget.roleDetails.description.toString();
    final permissions = widget.roleDetails.permissions.toString();

    // Check if permissions starts and ends with brackets indicating a JSON array
    if (permissions.startsWith('[') && permissions.endsWith(']')) {
      try {
        // Try to decode the JSON array
        selectedPermissions = List<String>.from(jsonDecode(permissions));
      } catch (e) {
        // If decoding fails, fallback to formatting the string
        selectedPermissions = _formatPermissionsString(permissions);
      }
    } else {
      // If permissions are not a valid JSON array, format the string
      selectedPermissions = _formatPermissionsString(permissions);
    }
  }

  List<String> _formatPermissionsString(String permissions) {
    // Clean the string from brackets and extra spaces
    String cleanedPermissions =
    permissions.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '');

    // Split by commas and trim any extra spaces
    List<String> formattedPermissions =
    cleanedPermissions.split(',').map((s) => s.trim()).toList();

    return formattedPermissions;
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
    final teamViewModel = Provider.of<TeamsViewModel>(context);
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
                        'Edit Role',
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
                    'Edit Role',
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
          // Scrollable content wrapped with Expanded widget
          Positioned(
            top: 140,
            left: 20,
            right: 20,
            bottom: 70,
            // Make space for the button at the bottom
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Role Name',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                  CustomTextField(
                    controller: _roleNameController,
                    hintText: 'Role Name',
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Additional Notes',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                  CustomTextField(
                    controller: _notesController,
                    hintText: 'Additional Notes',
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'User Role Permissions',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.secondaryOrange,
                            fontFamily: 'PoppinsMedium'),
                      )),
                  const CheckboxWithLabel(
                    label: 'View',
                    value: true,
                    isDisabled: true,
                    onChanged: null,
                  ),
                  CheckboxWithLabel(
                    label: 'Create',
                    value: selectedPermissions.contains('Create'),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedPermissions.add('Create');
                        } else {
                          selectedPermissions.remove('Create');
                        }
                      });
                    },
                  ),
                  CheckboxWithLabel(
                    label: 'Approve',
                    value: selectedPermissions.contains('Approve'),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedPermissions.add('Approve');
                        } else {
                          selectedPermissions.remove('Approve');
                        }
                      });
                    },
                  ),
                  CheckboxWithLabel(
                    label: 'Manage Support',
                    value: selectedPermissions.contains('Support'),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedPermissions.add('Support');
                        } else {
                          selectedPermissions.remove('Support');
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 15, // Space from the bottom of the screen
            left: 20,
            right: 20,
            child: CustomElevatedButton(
              onPressed: () {
                if(_roleNameController.text.isEmpty){
                  Utils.toastMessage("Please enter role name");
                }
                else if (_notesController.text.isEmpty){
                  Utils.toastMessage("Please enter notes");
                }
                else{
                  final permissionsString = jsonEncode(selectedPermissions);
                  Map data = {
                    'user_id' : _userData?.data?.userId.toString(),
                    'usr_role_track_id' : _userData?.data?.roleTrackId.toString(),
                    'role_name' : _roleNameController.text.toString(),
                    'description' : _notesController.text.toString(),
                    'permission' :  permissionsString,
                    'role_id' : widget.roleDetails.roleId,
                    'token' : _userData?.token.toString(),
                  };
                  teamViewModel.addRoleApi(data,context);
                }
              },
              buttonText: 'Update Role',
              loading: teamViewModel.loading,
            ),
          ),
        ],
      ),
    );
  }
}
