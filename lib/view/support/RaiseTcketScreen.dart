import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/utils/Utils.dart';
import 'package:intrasense/view_models/ticket_view_model.dart';
import 'package:provider/provider.dart';

import '../../model/user_model.dart';
import '../../res/component/ButtonOrangeBorder.dart';
import '../../res/component/CustomDropdown.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomTextField.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../view_models/user_view_model.dart';

class RaiseTicketScreen extends StatefulWidget{
  @override
  _RaiseTicketScreen createState() => _RaiseTicketScreen();
}

class _RaiseTicketScreen extends State<RaiseTicketScreen>{
  UserModel? _userData;
  bool _isLoading = false;

  String? selectIssueTypeValue;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _organisationController = TextEditingController();
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _emailIdController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _desController = TextEditingController();

  @override
  void initState() {
    getUserDetails(context);
    super.initState();
  }

  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    setState(() {});
    if (kDebugMode) {
      print(_userData);
    }
  }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();

  @override
  Widget build(BuildContext context) {
    final ticketViewModel = Provider.of<TicketViewModel>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
          ),
          Positioned(
            top: 90,
            left: 0,
            child: Stack(
              children: [
                Image.asset(
                  Images.curveOverlay,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
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
            top: 36,
            left: 30,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                   'Raise a Ticket',
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
          Positioned(
            top: 110,
            left: 0,
            right: 0,
            bottom: 60,
            // Adjust the bottom to leave space for the button
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      children: [
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Raise a Ticket',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.secondaryOrange,
                                  fontFamily: 'PoppinsMedium'),
                            )),
                        const SizedBox(height: 15),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'First Name',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsMedium'),
                            )),
                          const SizedBox(height: 5),
                        CustomTextField(
                            controller: _firstNameController,
                            hintText: 'First Name'),
                          const SizedBox(height: 15),

                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Last Name',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsMedium'),
                            )),
                        const SizedBox(height: 5),
                        CustomTextField(
                            controller: _lastNameController,
                            hintText: 'Last Name'),
                        const SizedBox(height: 15),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Organisation',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsMedium'),
                            )),
                        const SizedBox(height: 5),
                        CustomTextField(
                            controller: _organisationController,
                            hintText: 'Organisation'),

                        const SizedBox(height: 15),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Employee ID',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsMedium'),
                            )),
                        const SizedBox(height: 5),
                        CustomTextField(
                            controller: _employeeIdController,
                            hintText: 'Employee ID'),

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
                        const SizedBox(height: 5),
                        CustomTextField(
                            controller: _designationController,
                            hintText: 'Designation'),

                        const SizedBox(height: 15),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Email ID',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsMedium'),
                            )),
                        const SizedBox(height: 5),
                        CustomTextField(
                            controller: _emailIdController,
                            hintText: 'Email ID'),

                        const SizedBox(height: 15),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Contact',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsMedium'),
                            )),
                        const SizedBox(height: 5),
                        CustomTextField(
                            controller: _contactController,
                            hintText: 'Contact'),

                        const SizedBox(height: 15),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Issue Type',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsMedium'),
                            )),
                        const SizedBox(height: 5),
                        CustomDropdown(
                          value: selectIssueTypeValue,
                          items: const ["Technical","Functionality"],
                          onChanged: (String? newValue) {
                            setState(() {
                              selectIssueTypeValue = newValue;
                            });
                          },
                          hint: 'Select Leave',
                        ),

                        const SizedBox(height: 15),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Description (Min 20 Characters)',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsMedium'),
                            )),
                        const SizedBox(height: 5),
                        CustomTextField(
                            controller: _desController,
                            hintText: 'Enter description...',
                            minLines: 4,
                            maxLines: 4),
                        const SizedBox(height: 10),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Place the button at the bottom of the screen
          Positioned(
            left: 0,
            right: 0,
            bottom: 10.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                children: [
                  Expanded(
                      flex: 10,
                      child: ButtonOrangeBorder(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        buttonText: 'CANCEL',
                      )),
                  Expanded(
                      flex: 1,
                      child: Container()),
                  Expanded(
                      flex: 10,
                      child:  CustomElevatedButton(
                        onPressed: () {
                          if(_firstNameController.text.toString().isEmpty){
                            Utils.toastMessage("Please enter first name");
                          }
                          else if(_lastNameController.text.toString().isEmpty){
                            Utils.toastMessage("Please enter last name");
                          }
                          else if(_organisationController.text.toString().isEmpty){
                            Utils.toastMessage("Please enter organisation name");
                          }
                          else if(_employeeIdController.text.toString().isEmpty){
                            Utils.toastMessage("Please enter employee Id");
                          }
                          else if(_designationController.text.toString().isEmpty){
                            Utils.toastMessage("Please enter designation name");
                          }
                          else if(_emailIdController.text.toString().isEmpty){
                            Utils.toastMessage("Please enter email id");
                          }
                          else if(_contactController.text.toString().isEmpty){
                            Utils.toastMessage("Please enter contact number");
                          }
                          else if(_desController.text.toString().isEmpty){
                            Utils.toastMessage("Please enter description");
                          }
                          else if (_desController.text.characters.length < 20) {
                            Utils.toastMessage(
                                "Please enter description min 20 characters");
                          }
                          else{
                            Map data = {
                              'user_id': _userData?.data?.userId.toString(),
                              'usr_role_track_id':
                              _userData?.data?.roleTrackId.toString(),
                              'first_name':_firstNameController.text.toString(),
                              'last_name': _lastNameController.text.toString(),
                              'organisation': _organisationController.text.toString(),
                              'designation': _designationController.text.toString(),
                              'issue_type': selectIssueTypeValue,
                              'ticket_description': _desController.text.toString(),
                              'employee_id': _employeeIdController.text.toString(),
                              'email_id': _emailIdController.text.toString(),
                              'contact_no': _contactController.text.toString(),
                              'token': _userData?.token.toString(),
                            };
                            ticketViewModel.addTicketApi(data,context);

                          }

                        },
                        buttonText: 'Submit',
                        loading: ticketViewModel.loading,
                      ))

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}