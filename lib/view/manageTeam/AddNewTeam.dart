import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/utils/Utils.dart';
import '../../model/RoleListModel.dart';
import '../../model/country_list_model.dart';
import '../../model/user_model.dart';
import '../../res/component/CustomDropdown.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomTextField.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../view_models/common_view_model.dart';
import '../../view_models/teams_view_model.dart';
import '../../view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class AddNewTeam extends StatefulWidget{
  @override
  _AddNewTeam createState()=> _AddNewTeam();

}

class _AddNewTeam extends State<AddNewTeam> {
  UserModel? _userData;
  bool _isLoading = false;
  List<RoleListModel> roleList = [];
  List<String> roleNamesList = [];

  String? selectRoleValue;
  String? selectCountryValue;

  List<String> countryNamesList = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController dojController = TextEditingController();
  TextEditingController employeeIdController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController skypeIdController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController doaController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    getUserDetails(context);
    fetchCountries();
  }

  void fetchCountries() async {
    final commonViewModel = Provider.of<CommonViewModel>(context, listen: false);
    await commonViewModel.countryListApi(context);
    setState(() {
     final  countryList = commonViewModel.countryList;
      countryNamesList= countryList.map((country) => country.countryName).toList();
    });
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();
  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    if (kDebugMode) {
      print(_userData);
    }
    getRoleList();
  }

  void getRoleList() async {
    setLoading(true);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'token': _userData?.token,
      };
      final teamViewModel = Provider.of<TeamsViewModel>(context, listen: false);
      await teamViewModel.getRoleListApi(data, context);
      setState(() {
        roleList= teamViewModel.roleList;
        if(roleList.isNotEmpty){
          roleNamesList = roleList.map((item) => item.roleName.toString()).toList();
        }

      });
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load Role list')),
      );
    } finally {
      setLoading(false);
    }
  }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                        'Add Team',
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
                    'Add Team',
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
            bottom: 70, // Make space for the button at the bottom
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                    hintText: 'Name',
                    controller: nameController,
                  ),
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
                    hintText: 'Designation',
                    controller: designationController,
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Date of Joining',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                   CustomTextField(
                     controller: dojController,
                    hintText: 'Date of Joining',
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Select Role',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                  CustomDropdown(
                    value: selectRoleValue,
                    items: roleNamesList,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectRoleValue = newValue;
                      });
                    },
                    hint: 'Select Role',
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Select Manager',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                  CustomDropdown(
                    value: null,
                    items: ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
                    onChanged: (String? newValue) {
                      setState(() {
                       // selectRoleValue = newValue;
                      });
                    },
                    hint: 'Select Manager',
                  ),
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
                   CustomTextField(
                     controller: employeeIdController,
                    hintText: 'Employee ID',
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Phone Number',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                   CustomTextField(
                     controller: phoneController,
                    hintText: 'Phone Number',
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
                     controller: emailController,
                    hintText: 'Email',
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'SkypeId',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                   CustomTextField(
                     controller: skypeIdController,
                    hintText: 'SkypeId',
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Date of Birth',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                   CustomTextField(
                    hintText: 'Date of Birth',
                     controller: dobController,
                   readOnly: true,
                    onTap: () async{
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );

                      if (pickedDate != null) {
                        String formattedDate = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                        setState(() {
                          dobController.text = formattedDate; // Set the selected date to the text field
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Date of  Anniversary',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                   CustomTextField(
                    hintText: 'Date of Anniversary',
                    controller: doaController,
                    readOnly: true,
                    onTap: () async{
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );

                      if (pickedDate != null) {
                        String formattedDate = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                        setState(() {
                          doaController.text = formattedDate; // Set the selected date to the text field
                        });
                      }

                    },

                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Address 1',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                   CustomTextField(
                     controller: address1Controller,
                    hintText: 'Address 1',
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Address 2',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                   CustomTextField(
                     controller: address2Controller,
                    hintText: 'Address 2',
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Country',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                  CustomDropdown(
                    value: selectCountryValue,
                    items: countryNamesList,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectCountryValue = newValue;
                      });
                    },
                    hint: 'Select Country',
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'State',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                   CustomTextField(
                     controller: stateController,
                    hintText: 'State',
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'City',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                   CustomTextField(
                     controller: cityController,
                    hintText: 'City',
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Pincode',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                   CustomTextField(
                     controller: pinCodeController,
                    hintText: 'Pincode',
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Upload ID (Driving License, Passport, Aadhar)',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    color: AppColors.lightBlue,
                    child: Row(
                      children: [
                        Image.asset(
                          Images.attachFile,
                          width: 20.0,
                          height: 20.0, // Update with your asset path
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Attach File',
                          style: TextStyle(
                              fontSize: 15,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsMedium'),
                        ),
                      ],
                    ),
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
                if(nameController.text.toString().isEmpty){
                  Utils.toastMessage("Please enter name");
                }
                else if(designationController.text.toString().isEmpty){
                  Utils.toastMessage("Please enter designation");
                }
                else if(dojController.text.toString().isEmpty){
                  Utils.toastMessage("Please select date of joining");
                }
                else if(employeeIdController.text.toString().isEmpty){
                  Utils.toastMessage("Please enter employee Id");
                }
                else if(phoneController.text.toString().isEmpty){
                  Utils.toastMessage("Please enter phone number");
                }
                else if(emailController.text.toString().isEmpty){
                  Utils.toastMessage("Please enter email Id");
                }
                else if(skypeIdController.text.toString().isEmpty){
                  Utils.toastMessage("Please enter skype Id");
                }
                else if(dobController.text.toString().isEmpty){
                  Utils.toastMessage("Please select date of birth");
                }
                else if(doaController.text.toString().isEmpty){
                  Utils.toastMessage("Please select date of anniversary");
                }
                else if(address1Controller.text.toString().isEmpty){
                  Utils.toastMessage("Please enter address 1");
                }
                else if(address2Controller.text.toString().isEmpty){
                  Utils.toastMessage("Please enter address 2");
                }
                else if(stateController.text.toString().isEmpty){
                  Utils.toastMessage("Please enter state");
                }
                else if(cityController.text.toString().isEmpty){
                  Utils.toastMessage("Please enter city");
                }
                else if(pinCodeController.text.toString().isEmpty){
                  Utils.toastMessage("Please enter pincode");
                }
                else{
                  ///APi
                }
              },
              buttonText: 'Save Team',
            ),
          ),
        ],
      ),
    );
  }
}