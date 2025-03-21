import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intrasense/data/network/app_url.dart';
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
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;


class AddNewTeam extends StatefulWidget {
  final dynamic employeeId;
  const AddNewTeam({Key? key, this.employeeId}) : super(key: key);

  @override
  _AddNewTeam createState() => _AddNewTeam();
}

class _AddNewTeam extends State<AddNewTeam> {
  UserModel? _userData;
  bool _isLoading = false;
  List<RoleListModel> roleList = [];
  List<String> roleNamesList = [];

  String? selectRoleValue;
  String? selectCountryValue;

  String? selectRoleId;

  List<String> countryNamesList = [];

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
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
  File? _profileImageFile;
  String? profileImageData;
  String? _profileImageUrl;

  File? _idProofImageFile;
  String? idProofFileName;
  String? idProofData;
  bool _isUpdate= false;

  @override
  void initState() {
    super.initState();
    getUserDetails(context);
    fetchCountries();
  }

  void fetchCountries() async {
    final commonViewModel =
        Provider.of<CommonViewModel>(context, listen: false);
    await commonViewModel.countryListApi(context);
    setState(() {
      final countryList = commonViewModel.countryList;
      countryNamesList =
          countryList.map((country) => country.countryName).toList();
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
        roleList = teamViewModel.roleList;
        if (roleList.isNotEmpty) {
          roleNamesList = roleList.map((item) => item.roleName.toString()).toList();
        }
      });
      if(widget.employeeId!=null){
        _isUpdate= true;
        getEmployeeDetail();
      }
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

  void getEmployeeDetail() async {
    setLoading(true);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'customer_id': _userData?.data?.customerTrackId,
        'employee_id': widget.employeeId,
        'token': _userData?.token,
      };
      final teamViewModel = Provider.of<TeamsViewModel>(context, listen: false);
      final response = await teamViewModel.getEmployeeDetailApi(data, context);

      if (response != null) {
        setState(() {
          final employee = response[0];
          firstNameController.text = employee.userFirstName ?? "";
          lastNameController.text = employee.userLastName ?? "";
          designationController.text = employee.usrDesignation ?? "";
          departmentController.text = employee.userDepartment ?? "";
          dojController.text = employee.usrDoj ?? "";

          employeeIdController.text = employee.empId ?? "";
          phoneController.text = employee.usrMobile ?? "";
          emailController.text = employee.usrEmail ?? "";
          skypeIdController.text = employee.usrSkypeId ?? "";
          dobController.text = employee.usrDob ?? "";
          doaController.text = employee.usrDoj ?? "";
          address1Controller.text = employee.usrAddress ?? "";
          address2Controller.text = employee.usrAddress2 ?? "";

          selectCountryValue= employee.usrCountry??"";

          stateController.text = employee.usrState ?? "";
          cityController.text = employee.usrCity ?? "";
          pinCodeController.text = employee.usrZipcode ?? "";


          if(employee.idProof.toString().isNotEmpty){
            idProofFileName="Selected Id Proof";
          }

          selectRoleId= employee.usrRoleTrackId??"";

          selectRoleValue = roleList.firstWhere((item) => item.roleId == selectRoleId).roleName;

          profileImageData=employee.profilePicture;
          _profileImageUrl = AppUrl.imageUrl+profileImageData.toString();

          idProofData= employee.idProof;

        });
      }
      }
     catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load employee detail')),
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

  Future<void> pickProfileImage(String type) async {
    final commonViewModel = Provider.of<CommonViewModel>(context, listen: false);
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {

        if (type == "0") {
          _profileImageFile = File(pickedFile.path);
          String selectedProfileImagePath = pickedFile.path;
          String? base64String = await encodeImageToBase64(selectedProfileImagePath);
          Map data = {'picture': base64String};
         final response = await  commonViewModel.commonImageUploadApi(data, context);
         profileImageData=response.toString();
         _profileImageUrl=AppUrl.imageUrl+profileImageData.toString();


        } else {
          _idProofImageFile = File(pickedFile.path);
          idProofFileName = pickedFile.name;
          String selectedIdProofPath = pickedFile.path;
          String? base64String = await encodeImageToBase64(selectedIdProofPath);
          Map data = {'picture': base64String};
          final response = await  commonViewModel.commonImageUploadApi(data, context);
          idProofData= response.toString();
        }

        setState(() {});

    }
  }

  Future<String?> encodeImageToBase64(String filePath) async {
    try {
      File file = File(filePath);
      List<int> bytes = await file.readAsBytes();
      String base64String = base64Encode(bytes);
      return base64String;
    } catch (e) {
      print('Error encoding image: $e');
      return null;
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
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 50, left: 30),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isUpdate ? 'Edit Team' : 'Add Team',
                        style: const TextStyle(
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
                Positioned(
                  top: 20,
                  left: 30,
                  child: Text(
                    _isUpdate ? 'Edit Team' : 'Add Team',
                    style: const TextStyle(
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
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      await pickProfileImage("0");
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[300],
                      backgroundImage:_profileImageUrl != null
                          ? NetworkImage(_profileImageUrl.toString())  // Load image from URL
                          : AssetImage(Images.profileIcon) as ImageProvider,
                    ),
                  ),
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
                    hintText: 'First Name',
                    controller: firstNameController,
                  ),
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
                    hintText: 'Last Name',
                    controller: lastNameController,
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
                  const SizedBox(height: 5),
                  CustomTextField(
                    hintText: 'Designation',
                    controller: designationController,
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Department',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                  const SizedBox(height: 5),
                  CustomTextField(
                    hintText: 'Department',
                    controller: departmentController,
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
                  const SizedBox(height: 5),
                  CustomTextField(
                      controller: dojController,
                      hintText: 'Date of Joining',
                      suffixIcon: Image.asset(
                        Images.calenderIcon,
                        height: 24,
                        width: 24,
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? startDate =
                        dojController.text.isNotEmpty
                            ? DateTime.parse(dojController.text)
                            : DateTime.now();
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: startDate,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          String formattedDate =
                              "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                          setState(() {
                            dojController.text = formattedDate;
                          });
                        }
                      }),
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
                  const SizedBox(height: 5),
                  CustomDropdown(
                    value: selectRoleValue,
                    items: roleNamesList,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectRoleValue = newValue;
                        selectRoleId = roleList
                            .firstWhere((item) => item.roleName == newValue)
                            .roleId;
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
                  const SizedBox(height: 5),
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
                  const SizedBox(height: 5),
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
                  const SizedBox(height: 5),
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
                  const SizedBox(height: 5),
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
                  const SizedBox(height: 5),
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
                  const SizedBox(height: 5),
                  CustomTextField(
                      controller: dobController,
                      hintText: 'Date of Birth',
                      suffixIcon: Image.asset(
                        Images.calenderIcon,
                        height: 24,
                        width: 24,
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? startDate =
                        dobController.text.isNotEmpty
                            ? DateTime.parse(dobController.text)
                            : DateTime.now();
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: startDate,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          String formattedDate =
                              "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                          setState(() {
                            dobController.text = formattedDate;
                          });
                        }
                      }),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Date of Anniversary',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                  const SizedBox(height: 5),
                CustomTextField(
                    controller: doaController,
                    hintText: 'Date of Anniversary',
                    suffixIcon: Image.asset(
                      Images.calenderIcon,
                      height: 24,
                      width: 24,
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? startDate =
                      doaController.text.isNotEmpty
                          ? DateTime.parse(doaController.text)
                          : DateTime.now();
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: startDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        String formattedDate =
                            "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                        setState(() {
                          doaController.text = formattedDate;
                        });
                      }
                    }),
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
                  const SizedBox(height: 5),
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
                  const SizedBox(height: 5),
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
                  const SizedBox(height: 5),
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
                  const SizedBox(height: 5),
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
                  const SizedBox(height: 5),
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
                  const SizedBox(height: 5),
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
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () async {
                      await pickProfileImage("1");
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
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
                  ),
                  const SizedBox(height: 5),
                  if (idProofFileName != null) ...{
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min, // Minimize the Row size
                      children: [
                        Expanded(
                          // Wrap Text widget in Expanded to avoid overflow
                          child: Text(
                            idProofFileName.toString(),
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.hintColor,
                              fontFamily: 'PoppinsRegular',
                            ),
                            overflow: TextOverflow
                                .ellipsis, // To handle long text overflow
                          ),
                        ),
                        IconButton(
                          icon: Image.asset(
                            Images.orangeRoundCrossIcon,
                            height: 30,
                            width: 30,
                          ),
                          onPressed: () {
                            setState(() {
                              profileImageData=null;
                              _idProofImageFile = null;
                              idProofFileName = null;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                  }
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 15, // Space from the bottom of the screen
            left: 20,
            right: 20,
            child: CustomElevatedButton(
              onPressed: () async{
                  if (firstNameController.text.toString().isEmpty) {
                  Utils.toastMessage("Please enter first name");
                } else if (lastNameController.text.toString().isEmpty) {
                  Utils.toastMessage("Please enter last name");
                } else if (designationController.text.toString().isEmpty) {
                  Utils.toastMessage("Please enter designation");
                } else if (departmentController.text.toString().isEmpty) {
                  Utils.toastMessage("Please enter department");
                } else if (dojController.text.toString().isEmpty) {
                  Utils.toastMessage("Please select date of joining");
                } else if (employeeIdController.text.toString().isEmpty) {
                  Utils.toastMessage("Please enter employee Id");
                } else if (phoneController.text.toString().isEmpty) {
                  Utils.toastMessage("Please enter phone number");
                } else if (emailController.text.toString().isEmpty) {
                  Utils.toastMessage("Please enter email Id");
                } else if (skypeIdController.text.toString().isEmpty) {
                  Utils.toastMessage("Please enter skype Id");
                } else if (dobController.text.toString().isEmpty) {
                  Utils.toastMessage("Please select date of birth");
                } else if (doaController.text.toString().isEmpty) {
                  Utils.toastMessage("Please select date of anniversary");
                } else if (address1Controller.text.toString().isEmpty) {
                  Utils.toastMessage("Please enter address 1");
                } else if (address2Controller.text.toString().isEmpty) {
                  Utils.toastMessage("Please enter address 2");
                } else if (stateController.text.toString().isEmpty) {
                  Utils.toastMessage("Please enter state");
                } else if (cityController.text.toString().isEmpty) {
                  Utils.toastMessage("Please enter city");
                } else if (pinCodeController.text.toString().isEmpty) {
                  Utils.toastMessage("Please enter pincode");
                } else {
                Map data = {
                    'user_id': _userData?.data?.userId.toString(),
                    'customer_id': _userData?.data?.customerTrackId.toString(),
                    'usr_role_track_id':
                        _userData?.data?.roleTrackId.toString(),
                    'user_first_name': firstNameController.text.toString(),
                    'user_last_name': lastNameController.text.toString(),
                    'role': selectRoleId,
                    'emp_id': employeeIdController.text.toString(),
                    'user_designation': designationController.text.toString(),
                    'dojoining': dojController.text.toString(),
                    'user_mobile': phoneController.text.toString(),
                    'user_email': emailController.text.toString(),
                    'user_skypeid': skypeIdController.text.toString(),
                    'doBirth': dobController.text.toString(),
                    'doanniversary': doaController.text.toString(),
                    'profile_picture': profileImageData,
                    'id_proof': idProofData,
                    'manager_id': "",
                    'address1': address1Controller.text.toString(),
                    'address2': address2Controller.text.toString(),
                    'country': selectCountryValue,
                    'state': stateController.text.toString(),
                    'city': cityController.text.toString(),
                    'zipcode': pinCodeController.text.toString(),
                    'user_department': departmentController.text.toString(),
                    'token': _userData?.token.toString(),
                  };
                  if(widget.employeeId!=null){
                    data['employee_id'] = widget.employeeId.toString();
                  }
                  teamViewModel.addEmployeeApi(data, context);
                }

              },
              buttonText:  _isUpdate ? 'UPDATE MEMBER' : 'SAVE MEMBER',
              loading: teamViewModel.loading,
            ),
          ),
        ],
      ),
    );
  }

  String getMimeType(String filePath) {
    String extension = path.extension(filePath).toLowerCase();
    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      default:
        return 'application/octet-stream';  // Fallback for unsupported types
    }
  }
}
