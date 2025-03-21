import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/model/teams/SelectedClientsModel.dart';
import 'package:intrasense/model/teams/SelectedEmployeesModel.dart';

import '../../model/client_list_model.dart';
import '../../model/teams/EmployeesListModel.dart';
import '../../model/teams/GroupListModel.dart';
import '../../model/user_model.dart';
import '../../res/component/CheckboxWithLabel.dart';
import '../../res/component/CustomDropdown.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomTextField.dart';
import '../../res/component/MultiSelectDropdown.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../utils/Utils.dart';
import '../../view_models/client_view_model.dart';
import '../../view_models/teams_view_model.dart';
import '../../view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class EditGroupScreen extends StatefulWidget {
  final GroupListModel groupDetails;

  const EditGroupScreen({super.key, required this.groupDetails});

  _EditGroupScreen createState() => _EditGroupScreen();
}

class _EditGroupScreen extends State<EditGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  UserModel? _userData;
  bool _isIndividualSelected = false;
  bool _isClientSelected = false;

  List<EmployeesListModel> employeesList = [];
  List<String> employeeNames = [];
  List<String> selectedEmployeeNames = [];
  List<String> selectedEmployeeIds = [];

  List<ClientListModel> clientList = [];
  List<String> clientNamesList = [];
  List<String> selectedClientNames = [];
  List<String> selectedClientIds = [];

  @override
  void initState() {
    super.initState();
    _groupNameController.text = widget.groupDetails.groupName.toString();
    _descriptionController.text = widget.groupDetails.comments.toString();
    getUserDetails(context);
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();

  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    if (kDebugMode) {
      print(_userData);
    }
    getEmployeesList();

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
                        'Edit Group',
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
                    'Edit Group',
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
                        'Group Name',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                  CustomTextField(
                    controller: _groupNameController,
                    hintText: 'Group Name',
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Description',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                  CustomTextField(
                    controller: _descriptionController,
                    hintText: 'Description',
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Add User(s) to group',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.secondaryOrange,
                            fontFamily: 'PoppinsMedium'),
                      )),
                  CheckboxWithLabel(
                    label: 'Select Individuals',
                    value: _isIndividualSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        _isIndividualSelected = value ?? false;
                      });
                    },
                  ),
                  CheckboxWithLabel(
                    label: 'Select Client',
                    value: _isClientSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        _isClientSelected = value ?? false;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  if (_isIndividualSelected)
                    MultiSelectDropdown(
                      items: employeeNames,
                      selectedItems: selectedEmployeeNames,
                      onChanged: (selectedItems) {
                        setState(() {
                          //employeeNames = selectedItems;
                        });
                      },
                      hint: "Select Employees",
                    ),
                  const SizedBox(height: 15),
                  if (_isClientSelected)
                    MultiSelectDropdown(
                      items: clientNamesList,
                      selectedItems: selectedClientNames,
                      onChanged: (selectedItems) {
                        setState(() {
                          //employeeNames = selectedItems;
                        });
                      },
                      hint: "Select Client",
                    )
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
                if (_groupNameController.text.isEmpty) {
                  Utils.toastMessage("Please enter group name");
                } else if (_descriptionController.text.isEmpty) {
                  Utils.toastMessage("Please enter description");
                } else if (_isIndividualSelected == false &&
                    _isClientSelected == false) {
                  Utils.toastMessage("Please select at least one type of user");
                } else if (_isIndividualSelected == true &&
                    selectedEmployeeNames.isEmpty) {
                  Utils.toastMessage("Please select at least one employee");
                } else if (_isClientSelected == true &&
                    selectedClientNames.isEmpty) {
                  Utils.toastMessage("Please select at least one Client");
                } else {
                  updateSelectedEmployeeIds();
                  updateSelectedClientIds();
                  var individualCheck = 0;
                  var clientCheck = 0;
                  if (_isIndividualSelected) {
                    individualCheck = 1;
                  }
                  if (_isClientSelected) {
                    clientCheck = 1;
                  }

                  Map data = {
                    'user_id': _userData?.data?.userId.toString(),
                    'usr_role_track_id':
                        _userData?.data?.roleTrackId.toString(),
                    'usr_customer_track_id':
                        _userData?.data?.customerTrackId.toString(),
                    'group_name': _groupNameController.text.toString(),
                    'group_notes': _descriptionController.text.toString(),
                    'client_check': clientCheck.toString(),
                    'individual_check': individualCheck.toString(),
                    'group_id': widget.groupDetails.groupId,
                    'token': _userData?.token.toString(),
                  };

                  for (int i = 0; i < selectedEmployeeNames.length; i++) {
                    data['users_ids[$i]'] = selectedEmployeeIds[i];
                  }

                  for (int i = 0; i < selectedClientNames.length; i++) {
                    data['client_ids[$i]'] = selectedClientIds[i];
                  }

                  teamViewModel.updateGroupApi(data, context);
                }
              },
              buttonText: 'Update Group',
              loading: teamViewModel.loading,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getEmployeesList() async {
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'customer_id': _userData?.data?.customerTrackId,
        'token': _userData?.token,
      };
      final teamViewModel = Provider.of<TeamsViewModel>(context, listen: false);
      List<EmployeesListModel>? employees = await teamViewModel.getEmployeesListApi(data, context);
      setState(() {
        if (employees != null) {
          employeesList = employees;
          employeeNames = employees
              .map((employee) =>
                  "${employee.userFirstName} ${employee.userLastName}")
              .toList();
        }
      });
      getClientList();

    } catch (error) {
      print('Error fetching employee list: $error');
    }
  }

  void getClientList() async {
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'customer_id': _userData?.data?.customerTrackId,
        'token': _userData?.token,
      };
      final clientViewModel =
          Provider.of<ClientViewModel>(context, listen: false);
      await clientViewModel.getClientListApi(data, context);
      final response = await clientViewModel.getClientListApi(data, context);
      setState(() {
        if (response != null) {
          clientList = response.toList();
          clientNamesList = clientList.map((item) => item.cmpName.toString()).toList();
        }
      });
      getGroupDetails();
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load client list')),
      );
    }
  }

  void getGroupDetails() async {
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'usr_customer_track_id': _userData?.data?.customerTrackId,
        'group_id': widget.groupDetails.groupId,
        'token': _userData?.token,
      };
      final teamViewModel = Provider.of<TeamsViewModel>(context, listen: false);
      final response = await teamViewModel.getGroupDetailsApi(data, context);

      if (response != null) {
        if (response is Map<String, dynamic>) {
          if (response['data'] != null && response['data'] is List) {
            List<SelectedEmployeesModel> selectedEmp =
                (response['data'] as List)
                    .map((item) => SelectedEmployeesModel.fromJson(item))
                    .toList();

            if (response['clientdata'] != null &&
                response['clientdata'] is List) {
              List<SelectedClientsModel> selectedCL =
                  (response['clientdata'] as List)
                      .map((item) => SelectedClientsModel.fromJson(item))
                      .toList();

              setState(() {
                selectedEmployeeNames = selectedEmp
                    .map((employee) =>
                        "${employee.firstName} ${employee.lastName}")
                    .toList();

                selectedClientNames = selectedCL.map((item) => item.companyName.toString()).toList();

                if (selectedEmployeeNames.isNotEmpty) {
                  _isIndividualSelected = true;
                }
                if (selectedClientNames.isNotEmpty) {
                  _isClientSelected = true;
                }
              });
            }
          }
        }
      }
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
    }
    finally{
      Utils.hideLoadingDialog(context);
    }
  }

  void updateSelectedEmployeeIds() {
    selectedEmployeeIds.clear();

    for (var selectedName in selectedEmployeeNames) {
      var employee = employeesList.firstWhere(
        (employee) =>
            "${employee.userFirstName} ${employee.userLastName}" ==
            selectedName,
        orElse: () => EmployeesListModel
            .empty(), // Return an empty object if no match is found
      );

      if (employee.empId != null) {
        selectedEmployeeIds.add(employee.empId.toString());
      } else {
        if (kDebugMode) {
          print("No employee found for selected name: $selectedName");
        }
      }
    }
  }

  void updateSelectedClientIds() {
    selectedClientIds.clear();
    for (var selectedName in selectedClientNames) {
      var client = clientList.firstWhere(
        (client) => client.cmpName == selectedName,
        orElse: () => ClientListModel.empty(),
      );

      if (client != null) {
        selectedClientIds.add(client.companyId.toString());
      } else {
        if (kDebugMode) {
          print("No employee found for selected name: $selectedName");
        }
      }
    }
  }
}
